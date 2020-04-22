REPO = https://github.com/LPCIC/coq-elpi.git
TAG = coq-v8.11
WORKDIR = workdir

.PHONY: all get

all: $(WORKDIR)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 -b $(TAG) $(REPO) $(WORKDIR)
	rm -f $(WORKDIR)/coq-builtin.elpi  # this file should not be there

