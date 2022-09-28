HEADER  	= sharedspectre.h
LIBRARY 	= libspectre.so
HADDOC_ROOT = $(shell stack path | grep 'local-install-root' | cut -d':' -f2)
VERSION 	= 0.1.0.0
MODULE 		= sharedspectre

all: spectre

spectre: src/SharedSpectre.hs package.yaml stack.yaml
	stack build
	mkdir -p ./lib
	find .stack-work/install/ -name '$(LIBRARY)' -exec cp {} ./lib/ \;

doc:
	stack haddock --no-haddock-deps
	cp -rv $(HADDOC_ROOT)/doc/$(MODULE)-$(VERSION)/* ./docs/haddock/

install:
	cp -v ./lib/$(LIBRARY) /usr/lib64/$(LIBRARY)
	mkdir -vp /usr/include/spectre
	cp -v ./csrc/$(HEADER) /usr/include/spectre/$(HEADER)

clean:
	rm -v sharedspectre.cabal
	rm -vrf lib
	stack clean

.PHONY: all spectre doc install clean
