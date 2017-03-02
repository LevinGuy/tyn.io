all:
	echo 'Provide a target: tynio clean'

fmt:
	find src/ -name '*.go' -exec go fmt {} ';'

vet:
	go vet src/internal/types/*.go
	go vet src/internal/store/*.go
	go vet src/cmd/tynio/*.go

staticcheck:
	GOPATH=/home/chilts/src/appsattic-tyn.io/vendor:/home/chilts/src/appsattic-tyn.io staticcheck src/internal/store/*.go
	GOPATH=/home/chilts/src/appsattic-tyn.io/vendor:/home/chilts/src/appsattic-tyn.io staticcheck src/internal/types/*.go
	GOPATH=/home/chilts/src/appsattic-tyn.io/vendor:/home/chilts/src/appsattic-tyn.io staticcheck src/cmd/server/*.go

test: fmt vet staticcheck
	gb test -v

build: fmt
	gb build all

tynio: build
	./bin/tynio

clean:
	rm -rf bin/ pkg/

.PHONY: tynio
