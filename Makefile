MAIN_SOURCE := src/main.cr
BUILD_OUTPUT := build/passman

run: $(BUILD_OUTPUT)
	./$(BUILD_OUTPUT)

.PHONY: build
build: 
	crystal build $(MAIN_SOURCE) -o $(BUILD_OUTPUT)
		
$(BUILD_OUTPUT):
	crystal build $(MAIN_SOURCE) -o $(BUILD_OUTPUT)
