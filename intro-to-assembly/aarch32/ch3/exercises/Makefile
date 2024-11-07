ASM													:= arm-linux-gnueabihf
ASM_FLAGS										:= --gstabs -march=armv7-a+vfpv3-fp16
LINK_FLAGS 									:= -static
DEBUG_ARCH                  := armv7
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

EXECUTABLE1 								:= problem1
EXECUTABLE2 								:= problem2
EXECUTABLE3 								:= problem3
EXECUTABLE5 								:= problem5

all: $(EXECUTABLE1) $(EXECUTABLE2) $(EXECUTABLE3) $(EXECUTABLE5)

$(EXECUTABLE1): $(BIN)/$(EXECUTABLE1)
$(EXECUTABLE2): $(BIN)/$(EXECUTABLE2)
$(EXECUTABLE3): $(BIN)/$(EXECUTABLE3)
$(EXECUTABLE5): $(BIN)/$(EXECUTABLE5)

$(BIN)/$(EXECUTABLE1): $(SRC)/$(EXECUTABLE1)/*.s
	@echo "Making file: $(BIN)/$(EXECUTABLE1)"
	$(ASM)-as $^ -o $(BIN)/$(EXECUTABLE1).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(EXECUTABLE1).o -o $@ $(LINK_FLAGS)

$(BIN)/$(EXECUTABLE2): $(SRC)/$(EXECUTABLE2)/*.s
	@echo "Making file: $(BIN)/$(EXECUTABLE2)"
	$(ASM)-as $^ -o $(BIN)/$(EXECUTABLE2).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(EXECUTABLE2).o -o $@ $(LINK_FLAGS)

$(BIN)/$(EXECUTABLE3): $(SRC)/$(EXECUTABLE3)/*.s
	@echo "Making file: $(BIN)/$(EXECUTABLE3)"
	$(ASM)-as $^ -o $(BIN)/$(EXECUTABLE3).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(EXECUTABLE3).o -o $@ $(LINK_FLAGS)

$(BIN)/$(EXECUTABLE5): $(SRC)/$(EXECUTABLE5)/*.s
	@echo "Making file: $(BIN)/$(EXECUTABLE5)"
	$(ASM)-as $^ -o $(BIN)/$(EXECUTABLE5).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(EXECUTABLE5).o -o $@ $(LINK_FLAGS)

run-$(EXECUTABLE1): clean $(EXECUTABLE1)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(EXECUTABLE1)

run-$(EXECUTABLE2): clean $(EXECUTABLE2)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(EXECUTABLE2)

run-$(EXECUTABLE3): clean $(EXECUTABLE3)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(EXECUTABLE3)
 
run-$(EXECUTABLE5): clean $(EXECUTABLE5)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(EXECUTABLE5)
 
debug-$(EXECUTABLE1):
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(EXECUTABLE1)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-$(EXECUTABLE2):
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(EXECUTABLE2)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-$(EXECUTABLE3):
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(EXECUTABLE3)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-$(EXECUTABLE5):
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(EXECUTABLE5)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

clean:
	-rm ./$(BIN)/*
