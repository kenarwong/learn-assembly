ASM													:= arm-linux-gnueabihf
# ASM_FLAGS										:= --gstabs -march=armv7-a+vfpv3-fp16
ASM_FLAGS										:= --gstabs -march=armv6+fp
# LINK_FLAGS 									:= -static
# DEBUG_ARCH                  := armv7
DEBUG_ARCH                  := armv6
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

USERNAME										:= ken
PI_HOSTNAME									:= pi-zero

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

pi: $(SRC)/$(EXECUTABLE)/*.s
	@echo "Assembling file: $(BIN)/$(EXECUTABLE)"
	$(ASM)-as $^ -o $(BIN)/$(EXECUTABLE).o $(ASM_FLAGS)
	scp $(BIN)/$(EXECUTABLE).o $(USERNAME)@$(PI_HOSTNAME):~ 
	# ssh $(USERNAME)@$(PI_HOSTNAME) "$(ASM)-gcc $(EXECUTABLE).o -o $(EXECUTABLE)"

clean:
	-rm ./$(BIN)/*
