all:
	echo 'Provide a target: tynio clean'

vendor:
	gb vendor fetch github.com/boltdb/bolt

fmt:
	find src/ -name '*.go' -exec go fmt {} ';'

build: fmt
	gb build all

tynio: build
	./bin/tynio

test:
	gb test -v

clean:
	rm -rf bin/ pkg/

.PHONY: tynio
