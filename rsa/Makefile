ASM													:= arm-linux-gnueabihf
ASM_FLAGS										:= --gstabs -march=armv6+fp # -fno-omit-frame-pointer
LINK_FLAGS 									:= -static
DEBUG_ARCH                  := armv6
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

EXECUTABLE 									:= main

all: $(BIN)/$(EXECUTABLE)

# $(BIN)/$(EXECUTABLE): $(SRC)/*.s
# 	@echo "Making file: $(BIN)/$(EXECUTABLE)"
# 	$(ASM)-as $< -o $@ $(ASM_FLAGS)
# 	$(ASM)-gcc $^ -o $@ $(LINK_FLAGS)

$(BIN)/$(EXECUTABLE): $(SRC)/main.s $(SRC)/lib.s $(SRC)/math.s
	@echo "Making file: $(BIN)/$(EXECUTABLE)"
	$(ASM)-as $^ -o $(BIN)/$(EXECUTABLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(EXECUTABLE).o -o $@ $(LINK_FLAGS)

run: clean $(BIN)/$(EXECUTABLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(EXECUTABLE)

disassemble: all
	$(ASM)-objdump $(BIN)/$(EXECUTABLE).o -d
 
debug:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(EXECUTABLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

clean:
	-rm ./$(BIN)/*
