ASM													:= arm-linux-gnueabihf
# ASM_FLAGS										:= --gstabs -march=armv7-a+vfpv3-fp16
ASM_FLAGS										:= --gstabs -march=armv6+fp
LINK_FLAGS 									:= -static
# DEBUG_ARCH                  := armv7
DEBUG_ARCH                  := armv6
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

STATIC_EXAMPLE							:= printArrayByIndex
STACK_EXAMPLE								:= printStringByIndex
HEAP_EXAMPLE								:= toUpper
CALL_BY_REF_VAR_EXAMPLE			:= SwapByRefType
CALL_BY_REF_EXAMPLE					:= SwapByRef

all: $(BIN)/$(STATIC_EXAMPLE) $(BIN)/$(STACK_EXAMPLE) $(BIN)/$(HEAP_EXAMPLE) $(BIN)/$(CALL_BY_REF_VAR_EXAMPLE) $(BIN)/$(CALL_BY_REF_EXAMPLE)


$(BIN)/$(STATIC_EXAMPLE): $(SRC)/$(STATIC_EXAMPLE).s
	@echo "Making file: $(BIN)/$(STATIC_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(STATIC_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(STATIC_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(STACK_EXAMPLE): $(SRC)/$(STACK_EXAMPLE).s
	@echo "Making file: $(BIN)/$(STACK_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(STACK_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(STACK_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(HEAP_EXAMPLE): $(SRC)/$(HEAP_EXAMPLE).s
	@echo "Making file: $(BIN)/$(HEAP_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(HEAP_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(HEAP_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(CALL_BY_REF_VAR_EXAMPLE): $(SRC)/$(CALL_BY_REF_VAR_EXAMPLE).s
	@echo "Making file: $(BIN)/$(CALL_BY_REF_VAR_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(CALL_BY_REF_VAR_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(CALL_BY_REF_VAR_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(CALL_BY_REF_EXAMPLE): $(SRC)/$(CALL_BY_REF_EXAMPLE).s
	@echo "Making file: $(BIN)/$(CALL_BY_REF_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(CALL_BY_REF_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(CALL_BY_REF_EXAMPLE).o -o $@ $(LINK_FLAGS)

run-static-example: clean $(BIN)/$(STATIC_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(STATIC_EXAMPLE)

run-stack-example: clean $(BIN)/$(STACK_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(STACK_EXAMPLE)

run-heap-example: clean $(BIN)/$(HEAP_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(HEAP_EXAMPLE)

run-ref-var-example: clean $(BIN)/$(CALL_BY_REF_VAR_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(CALL_BY_REF_VAR_EXAMPLE)

run-ref-example: clean $(BIN)/$(CALL_BY_REF_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(CALL_BY_REF_EXAMPLE)

disassemble: all
	$(ASM)-objdump $(BIN)/$(STATIC_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(STACK_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(HEAP_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(CALL_BY_REF_VAR_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(CALL_BY_REF_EXAMPLE).o -d
 
debug-static-example:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(STATIC_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-stack-example:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(STACK_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-heap-example:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(HEAP_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-ref-var-example:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(CALL_BY_REF_VAR_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-ref-example:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(CALL_BY_REF_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

clean:
	-rm ./$(BIN)/*
