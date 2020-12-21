GOCMD=go
BINARY=mcbroken-exporter
BUILD_FLAGS=-ldflags="-s -w"
VERSION=0.1.0

lint:
	$(GOCMD) test -v ./... -coverprofile=coverage.txt
	@if ! command -v golangci-lint 1>/dev/null; then\
		echo "Need to install golangci-lint";\
		exit 1;\
	fi;\
	golangci-lint run

build:
	$(GOCMD) build -o $(BINARY)

compile:
	GOOS=linux GOARCH=amd64 go build $(BUILD_FLAGS) -o bin/linux/amd64/$(BINARY)
	GOOS=linux GOARCH=arm go build $(BUILD_FLAGS) -o bin/linux/arm/$(BINARY)
	GOOS=linux GOARCH=arm64 go build $(BUILD_FLAGS) -o bin/linux/arm64/$(BINARY)
	GOOS=darwin GOARCH=amd64 go build $(BUILD_FLAGS) -o bin/darwin/amd64/$(BINARY)
	GOOS=windows GOARCH=amd64 go build $(BUILD_FLAGS) -o bin/windows/amd64/$(BINARY).exe

package:
	GOOS=linux GOARCH=amd64 tar -czf bin/$(BINARY)_$(VERSION)_linux_amd64.tar.gz -C bin/linux/amd64 $(BINARY)
	GOOS=linux GOARCH=arm tar -czf bin/$(BINARY)_$(VERSION)_linux_arm.tar.gz -C bin/linux/arm $(BINARY)
	GOOS=linux GOARCH=arm64 tar -czf bin/$(BINARY)_$(VERSION)_linux_arm64.tar.gz -C bin/linux/arm64 $(BINARY)
	GOOS=darwin GOARCH=amd64 tar -czf bin/$(BINARY)_$(VERSION)_darwin_amd64.tar.gz -C bin/darwin/amd64 $(BINARY)
	GOOS=windows GOARCH=amd64 zip -j bin/$(BINARY)_$(VERSION)_windows_amd64.zip bin/windows/amd64/$(BINARY).exe

clean:
	$(GOCMD) clean
	rm -rf $(BINARY) bin/

release: clean compile package

docker-build:
	docker build -t $(BINARY):$(VERSION) .

docker-run:
	docker run --rm -p 8080:8080 $(BINARY):$(VERSION)