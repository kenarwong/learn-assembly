ASM													:= arm-linux-gnueabihf
# ASM_FLAGS										:= --gstabs -march=armv7-a+vfpv3-fp16
ASM_FLAGS										:= --gstabs -march=armv6+fp
LINK_FLAGS 									:= -static
# DEBUG_ARCH                  := armv7
DEBUG_ARCH                  := armv6
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

EXECUTABLE 									:= problem$(NUMBER)

all: $(BIN)/$(EXECUTABLE)

$(BIN)/$(EXECUTABLE): $(SRC)/$(EXECUTABLE)/*.s
	@echo "Making file: $(BIN)/$(EXECUTABLE)"
	$(ASM)-as $^ -o $(BIN)/$(EXECUTABLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(EXECUTABLE).o -o $@ $(LINK_FLAGS)

run: clean $(BIN)/$(EXECUTABLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(EXECUTABLE)
 
debug:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(EXECUTABLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

clean:
	-rm ./$(BIN)/*
