TOOLCHAIN 									:= arm-linux-gnueabihf
TOOLCHAIN_FLAGS 						:= -gstabs
LINK_FLAGS 									:= -static

BIN 												:= bin
SRC 												:= src

EXECUTABLE1 								:= helloWorld
EXECUTABLE2 								:= printName
EXECUTABLE3 								:= printInt

all: $(EXECUTABLE1) $(EXECUTABLE2) $(EXECUTABLE3)

$(EXECUTABLE1): $(BIN)/$(EXECUTABLE1)
$(EXECUTABLE2): $(BIN)/$(EXECUTABLE2)
$(EXECUTABLE3): $(BIN)/$(EXECUTABLE3)

$(BIN)/$(EXECUTABLE1): $(SRC)/$(EXECUTABLE1)Main.s
	@echo "Making file: $(BIN)/$(EXECUTABLE1)"
	$(TOOLCHAIN)-as $^ -o $(BIN)/$(EXECUTABLE1)Main.o $(TOOLCHAIN_FLAGS)
	$(TOOLCHAIN)-gcc $(BIN)/$(EXECUTABLE1)Main.o -o $@ $(LINK_FLAGS)

$(BIN)/$(EXECUTABLE2): $(SRC)/$(EXECUTABLE2)Main.s
	@echo "Making file: $(BIN)/$(EXECUTABLE2)"
	$(TOOLCHAIN)-as $^ -o $(BIN)/$(EXECUTABLE2)Main.o $(TOOLCHAIN_FLAGS)
	$(TOOLCHAIN)-gcc $(BIN)/$(EXECUTABLE2)Main.o -o $@ $(LINK_FLAGS)

$(BIN)/$(EXECUTABLE3): $(SRC)/$(EXECUTABLE3)Main.s
	@echo "Making file: $(BIN)/$(EXECUTABLE3)"
	$(TOOLCHAIN)-as $^ -o $(BIN)/$(EXECUTABLE3)Main.o $(TOOLCHAIN_FLAGS)
	$(TOOLCHAIN)-gcc $(BIN)/$(EXECUTABLE3)Main.o -o $@ $(LINK_FLAGS)

run-$(EXECUTABLE1): clean $(EXECUTABLE1)
	clear
	qemu-arm-static -g 10101 ./$(BIN)/$(EXECUTABLE1)

run-$(EXECUTABLE2): clean $(EXECUTABLE2)
	clear
	qemu-arm-static -g 10101 ./$(BIN)/$(EXECUTABLE2)

run-$(EXECUTABLE3): clean $(EXECUTABLE3)
	clear
	qemu-arm-static -g 10101 ./$(BIN)/$(EXECUTABLE3)
 
debug-$(EXECUTABLE1):
	gdb-multiarch -q --nh \
	-ex 'set architecture arm' \
	-ex 'file ./$(BIN)/$(EXECUTABLE1)' \
	-ex 'target remote localhost:10101' \
	-ex 'break main' \
	-ex continue \
	-ex 'layout split'

debug-$(EXECUTABLE2):
	gdb-multiarch -q --nh \
	-ex 'set architecture arm' \
	-ex 'file ./$(BIN)/$(EXECUTABLE2)' \
	-ex 'target remote localhost:10101' \
	-ex 'break main' \
	-ex continue \
	-ex 'layout split'

debug-$(EXECUTABLE3):
	gdb-multiarch -q --nh \
	-ex 'set architecture arm' \
	-ex 'file ./$(BIN)/$(EXECUTABLE3)' \
	-ex 'target remote localhost:10101' \
	-ex 'break main' \
	-ex continue \
	-ex 'layout split'

clean:
	rm ./$(BIN)/*