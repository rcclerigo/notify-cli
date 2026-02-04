BINARY_NAME = notify
INSTALL_PATH = /usr/local/bin

.PHONY: build install clean test

build:
	@echo "Building $(BINARY_NAME)..."
	swiftc notify.swift -o $(BINARY_NAME)
	@echo "Build complete: ./$(BINARY_NAME)"

install: build
	@echo "Installing to $(INSTALL_PATH)..."
	cp $(BINARY_NAME) $(INSTALL_PATH)/$(BINARY_NAME)
	chmod +x $(INSTALL_PATH)/$(BINARY_NAME)
	codesign --sign - --force $(INSTALL_PATH)/$(BINARY_NAME)
	@echo "Installed successfully!"

clean:
	@echo "Cleaning..."
	rm -f $(BINARY_NAME)

test: build
	@echo "Testing with sample notification..."
	./$(BINARY_NAME) --title "Test Notification" --description "This is a test message" --label-ok "Visit GitHub" --ok-opens-url "https://github.com"
