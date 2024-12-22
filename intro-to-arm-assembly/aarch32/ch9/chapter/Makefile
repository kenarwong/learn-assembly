ASM													:= arm-linux-gnueabihf
# ASM_FLAGS										:= --gstabs -march=armv7-a+vfpv3-fp16
ASM_FLAGS										:= --gstabs -march=armv6+fp
LINK_FLAGS 									:= -static
# DEBUG_ARCH                  := armv7
DEBUG_ARCH                  := armv6
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

SUM_EXAMPLE									:= sumRecursion
BAD_EXAMPLE									:= badRecursion
BAD_EXAMPLE2								:= badRecursion2

all: $(BIN)/$(SUM_EXAMPLE) $(BIN)/$(BAD_EXAMPLE) $(BIN)/$(BAD_EXAMPLE2) 

$(BIN)/$(SUM_EXAMPLE): $(SRC)/$(SUM_EXAMPLE).s
	@echo "Making file: $(BIN)/$(SUM_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(SUM_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(SUM_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(BAD_EXAMPLE): $(SRC)/$(BAD_EXAMPLE).s
	@echo "Making file: $(BIN)/$(BAD_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(BAD_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(BAD_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(BAD_EXAMPLE2): $(SRC)/$(BAD_EXAMPLE2).s
	@echo "Making file: $(BIN)/$(BAD_EXAMPLE2)"
	$(ASM)-as $^ -o $(BIN)/$(BAD_EXAMPLE2).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(BAD_EXAMPLE2).o -o $@ $(LINK_FLAGS)

run-sum: clean $(BIN)/$(SUM_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(SUM_EXAMPLE)

run-bad: clean $(BIN)/$(BAD_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(BAD_EXAMPLE)

run-bad2: clean $(BIN)/$(BAD_EXAMPLE2)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(BAD_EXAMPLE2)

disassemble: all
	$(ASM)-objdump $(BIN)/$(SUM_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(BAD_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(BAD_EXAMPLE2).o -d
 
debug-sum:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(SUM_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-bad:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(BAD_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-bad2:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(BAD_EXAMPLE2)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

clean:
	-rm ./$(BIN)/*
