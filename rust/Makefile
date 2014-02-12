# Makefile for SPKI - Rust flavor
#
BUILD=build
RUSTC=rustc -O
MAIN_FILE_SRC=main.rs
MAIN_BINARY=$(BUILD)/spki

all:	build run

clean:
	@rm -rf $(BUILD) || true

build: clean
	@mkdir $(BUILD) || true
	$(RUSTC) $(MAIN_FILE_SRC) -o $(MAIN_BINARY)

run:
	./$(MAIN_BINARY)

# - This Is The End
