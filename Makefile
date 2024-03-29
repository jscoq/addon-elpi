REPO = https://github.com/LPCIC/coq-elpi.git
TAG = v1.11.2
WORKDIR = workdir

.PHONY: all get prepare

all: $(WORKDIR) prepare $(WORKDIR)/src/coq_elpi_config.ml
	cp -r dune-files/* $(WORKDIR)/
	# must build plugin first
	dune build $(WORKDIR)/src && dune build

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
	git clone --depth=1 -b $(TAG) $(REPO) $(WORKDIR)
	rm -f $(WORKDIR)/coq-builtin.elpi  # this file should not be there

clean:
	make -C $(WORKDIR) clean
	rm -f $(WORKDIR)/Makefile.coq{,.conf}
