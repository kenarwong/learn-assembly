ASM													:= arm-linux-gnueabihf
# ASM_FLAGS										:= --gstabs -march=armv7-a+vfpv3-fp16
ASM_FLAGS										:= --gstabs -march=armv6+fp
LINK_FLAGS 									:= -static
# DEBUG_ARCH                  := armv7
DEBUG_ARCH                  := armv6
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

IF_EXAMPLE									:= if
SPAGHETTI_EXAMPLE						:= spaghettiCode
LOGICAL_VAR_EXAMPLE					:= logicalVariable
IF_ELSE_EXAMPLE							:= ifElse
IF_ELSE_IF_ELSE_EXAMPLE			:= ifElseIfElse
SENTINAL_LOOP_EXAMPLE				:= sentinelLoop
COUNTER_LOOP_EXAMPLE				:= counterLoop
NESTED_LOOP_EXAMPLE					:= nestedLoop
PRINTF_ARGS_EXAMPLE					:= printfArgs

all: $(BIN)/$(IF_EXAMPLE) $(BIN)/$(SPAGHETTI_EXAMPLE) $(BIN)/$(LOGICAL_VAR_EXAMPLE) $(BIN)/$(IF_ELSE_EXAMPLE) $(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE) $(BIN)/$(SENTINAL_LOOP_EXAMPLE) $(BIN)/$(COUNTER_LOOP_EXAMPLE) $(BIN)/$(NESTED_LOOP_EXAMPLE)

$(BIN)/$(IF_EXAMPLE): $(SRC)/$(IF_EXAMPLE).s
	@echo "Making file: $(BIN)/$(IF_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(IF_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(IF_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(SPAGHETTI_EXAMPLE): $(SRC)/$(SPAGHETTI_EXAMPLE).s
	@echo "Making file: $(BIN)/$(SPAGHETTI_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(SPAGHETTI_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(SPAGHETTI_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(LOGICAL_VAR_EXAMPLE): $(SRC)/$(LOGICAL_VAR_EXAMPLE).s
	@echo "Making file: $(BIN)/$(LOGICAL_VAR_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(LOGICAL_VAR_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(LOGICAL_VAR_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(IF_ELSE_EXAMPLE): $(SRC)/$(IF_ELSE_EXAMPLE).s
	@echo "Making file: $(BIN)/$(IF_ELSE_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(IF_ELSE_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(IF_ELSE_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE): $(SRC)/$(IF_ELSE_IF_ELSE_EXAMPLE).s
	@echo "Making file: $(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(SENTINAL_LOOP_EXAMPLE): $(SRC)/$(SENTINAL_LOOP_EXAMPLE).s
	@echo "Making file: $(BIN)/$(SENTINAL_LOOP_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(SENTINAL_LOOP_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(SENTINAL_LOOP_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(COUNTER_LOOP_EXAMPLE): $(SRC)/$(COUNTER_LOOP_EXAMPLE).s
	@echo "Making file: $(BIN)/$(COUNTER_LOOP_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(COUNTER_LOOP_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(COUNTER_LOOP_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(NESTED_LOOP_EXAMPLE): $(SRC)/$(NESTED_LOOP_EXAMPLE).s
	@echo "Making file: $(BIN)/$(NESTED_LOOP_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(NESTED_LOOP_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(NESTED_LOOP_EXAMPLE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(PRINTF_ARGS_EXAMPLE): $(SRC)/$(PRINTF_ARGS_EXAMPLE).s
	@echo "Making file: $(BIN)/$(PRINTF_ARGS_EXAMPLE)"
	$(ASM)-as $^ -o $(BIN)/$(PRINTF_ARGS_EXAMPLE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(PRINTF_ARGS_EXAMPLE).o -o $@ $(LINK_FLAGS)

run-if: clean $(BIN)/$(IF_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(IF_EXAMPLE)

run-spaghetti: clean $(BIN)/$(SPAGHETTI_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(SPAGHETTI_EXAMPLE)

run-logical-var: clean $(BIN)/$(LOGICAL_VAR_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(LOGICAL_VAR_EXAMPLE)

run-if-else: clean $(BIN)/$(IF_ELSE_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(IF_ELSE_EXAMPLE)

run-if-elseif-else: clean $(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE)

run-sentinel-loop: clean $(BIN)/$(SENTINAL_LOOP_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(SENTINAL_LOOP_EXAMPLE)

run-counter-loop: clean $(BIN)/$(COUNTER_LOOP_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(COUNTER_LOOP_EXAMPLE)

run-nested-loop: clean $(BIN)/$(NESTED_LOOP_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(NESTED_LOOP_EXAMPLE)

run-printf: clean $(BIN)/$(PRINTF_ARGS_EXAMPLE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(PRINTF_ARGS_EXAMPLE)

disassemble: all
	$(ASM)-objdump $(BIN)/$(IF_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(SPAGHETTI_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(LOGICAL_VAR_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(IF_ELSE_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(SENTINAL_LOOP_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(COUNTER_LOOP_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(NESTED_LOOP_EXAMPLE).o -d
	$(ASM)-objdump $(BIN)/$(PRINTF_ARGS_EXAMPLE).o -d
 
debug-if:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(IF_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-spaghetti:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(SPAGHETTI_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-logical-var:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(LOGICAL_VAR_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-if-else:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(IF_ELSE_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-if-elseif-else:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(IF_ELSE_IF_ELSE_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-sentinel-loop:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(SENTINAL_LOOP_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-counter-loop:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(COUNTER_LOOP_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-nested-loop:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(NESTED_LOOP_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \
 
debug-printf:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(PRINTF_ARGS_EXAMPLE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

clean:
	-rm ./$(BIN)/*
