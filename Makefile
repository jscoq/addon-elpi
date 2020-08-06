REPO = https://github.com/LPCIC/coq-elpi.git
TAG = coq-v8.12
WORKDIR = workdir

.PHONY: all get

all: $(WORKDIR)
	@echo '- Installing dependencies -'
	sed -i.bak '/"coq"/d' workdir/coq-elpi.opam  # don't install Coq
	opam install --deps-only $(WORKDIR)/
	make -C $(WORKDIR)
	dune build
# @todo: can run make as part of Dune build?

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 -b $(TAG) $(REPO) $(WORKDIR)
	rm -f $(WORKDIR)/coq-builtin.elpi  # this file should not be there

