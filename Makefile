REPO = https://github.com/LPCIC/coq-elpi.git
TAG = v1.14.0
COMMIT = 6dd7511f5f636b748867ae1cdcfcf37511badcbf
WORKDIR = workdir

# Git boilerplate
define GIT_CLONE_COMMIT
mkdir -p $(WORKDIR) && cd $(WORKDIR) && git init && \
git remote add origin $(REPO) && \
git fetch --depth=1 origin $(COMMIT) && git reset --hard FETCH_HEAD
endef

GIT_CLONE = ${if $(COMMIT), $(GIT_CLONE_COMMIT), git clone --recursive --depth=1 -b $(TAG) $(REPO) $(WORKDIR)}

.PHONY: all get prepare

all: $(WORKDIR) prepare $(WORKDIR)/src/coq_elpi_config.ml
	cp -r dune-files/* $(WORKDIR)/
	dune build $(WORKDIR)/src/META.coq-elpi @all -j1
	# must build plugin first
	#dune build $(WORKDIR)/src && dune build

prepare: $(WORKDIR)
	@echo '- Installing dependencies -'
	sed -i.bak '/"coq"/d' workdir/coq-elpi.opam  # don't install Coq
	unset DUNE_WORKSPACE && opam install -y --deps-only $(WORKDIR)/
	node adjust_paths.js

# can probably go in dune as well
$(WORKDIR)/src/coq_elpi_config.ml: prepare
	echo "let elpi_dir = \"$$(ocamlfind query elpi)\"" > $@

get: $(WORKDIR)

$(WORKDIR):
	$(GIT_CLONE)
	rm -f $(WORKDIR)/coq-builtin.elpi  # this file should not be there

clean:
	make -C $(WORKDIR) clean
	rm -f $(WORKDIR)/Makefile.coq{,.conf}

install:
	dune install coq-elpi
