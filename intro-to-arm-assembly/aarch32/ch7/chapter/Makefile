ASM													:= arm-linux-gnueabihf
# ASM_FLAGS										:= --gstabs -march=armv7-a+vfpv3-fp16
ASM_FLAGS										:= --gstabs -march=armv6+fp
LINK_FLAGS 									:= -static
# DEBUG_ARCH                  := armv7
DEBUG_ARCH                  := armv6
DEBUG_PORT                  := 10101

BIN 												:= bin
SRC 												:= src

INCREMENT_MAIN							:= incrementMain
INCREMENT_INFINITE					:= incrementInfiniteLoop
REENTRANT_STATIC						:= reentrantStaticVar
PROGRAM_STACK								:= programStack
ADD_VALUE										:= addValue
MY_LIB											:= libmylib
INCHES_TO_FT								:= inches2FtMain

all: $(BIN)/$(INCREMENT_MAIN) $(BIN)/$(INCREMENT_INFINITE) $(BIN)/$(REENTRANT_STATIC) $(BIN)/$(PROGRAM_STACK)	$(BIN)/$(ADD_VALUE) $(BIN)/$(INCHES_TO_FT)

$(BIN)/$(INCREMENT_MAIN): $(SRC)/$(INCREMENT_MAIN).s
	@echo "Making file: $(BIN)/$(INCREMENT_MAIN)"
	$(ASM)-as $^ -o $(BIN)/$(INCREMENT_MAIN).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(INCREMENT_MAIN).o -o $@ $(LINK_FLAGS)

$(BIN)/$(INCREMENT_INFINITE): $(SRC)/$(INCREMENT_INFINITE).s
	@echo "Making file: $(BIN)/$(INCREMENT_INFINITE)"
	$(ASM)-as $^ -o $(BIN)/$(INCREMENT_INFINITE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(INCREMENT_INFINITE).o -o $@ $(LINK_FLAGS)

$(BIN)/$(REENTRANT_STATIC): $(SRC)/$(REENTRANT_STATIC).s
	@echo "Making file: $(BIN)/$(REENTRANT_STATIC)"
	$(ASM)-as $^ -o $(BIN)/$(REENTRANT_STATIC).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(REENTRANT_STATIC).o -o $@ $(LINK_FLAGS)

$(BIN)/$(PROGRAM_STACK): $(SRC)/$(PROGRAM_STACK).s
	@echo "Making file: $(BIN)/$(PROGRAM_STACK)"
	$(ASM)-as $^ -o $(BIN)/$(PROGRAM_STACK).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(PROGRAM_STACK).o -o $@ $(LINK_FLAGS)

$(BIN)/$(ADD_VALUE): $(SRC)/$(ADD_VALUE).s
	@echo "Making file: $(BIN)/$(ADD_VALUE)"
	$(ASM)-as $^ -o $(BIN)/$(ADD_VALUE).o $(ASM_FLAGS)
	$(ASM)-gcc $(BIN)/$(ADD_VALUE).o -o $@ $(LINK_FLAGS)

$(BIN)/libConversions.o: $(SRC)/libConversions.s
	$(ASM)-as $(SRC)/libConversions.s -o $(BIN)/libConversions.o $(ASM_FLAGS)

$(BIN)/libTypes.o: $(SRC)/libTypes.s
	$(ASM)-as $(SRC)/libTypes.s -o $(BIN)/libTypes.o $(ASM_FLAGS)

$(BIN)/$(MY_LIB).a: $(BIN)/libConversions.o $(BIN)/libTypes.o
	@echo "Creating library: $(BIN)/$(MY_LIB).a"
	$(ASM)-ar rcs $(BIN)/$(MY_LIB).a $(BIN)/libConversions.o $(BIN)/libTypes.o

$(BIN)/$(INCHES_TO_FT): $(SRC)/$(INCHES_TO_FT).s $(BIN)/$(MY_LIB).a
	@echo "Making file: $(BIN)/$(INCHES_TO_FT)"
	$(ASM)-as $< -o $(BIN)/$(INCHES_TO_FT).o $(ASM_FLAGS)
	$(ASM)-gcc -lm $(BIN)/$(INCHES_TO_FT).o -L$(BIN) -lmylib -o $@ $(LINK_FLAGS)

run-main: clean $(BIN)/$(INCREMENT_MAIN)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(INCREMENT_MAIN)

run-infinite: clean $(BIN)/$(INCREMENT_INFINITE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(INCREMENT_INFINITE)

run-static: clean $(BIN)/$(REENTRANT_STATIC)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(REENTRANT_STATIC)

run-stack: clean $(BIN)/$(PROGRAM_STACK)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(PROGRAM_STACK)

run-add: clean $(BIN)/$(ADD_VALUE)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(ADD_VALUE)

run-inches2Ft: clean $(BIN)/$(INCHES_TO_FT)
	clear
	qemu-arm-static -g $(DEBUG_PORT) ./$(BIN)/$(INCHES_TO_FT)

disassemble: all
	$(ASM)-objdump $(BIN)/$(INCREMENT_MAIN).o -d
	$(ASM)-objdump $(BIN)/$(INCREMENT_INFINITE).o -d
	$(ASM)-objdump $(BIN)/$(REENTRANT_STATIC).o -d
	$(ASM)-objdump $(BIN)/$(PROGRAM_STACK).o -d
	$(ASM)-objdump $(BIN)/$(ADD_VALUE).o -d
	$(ASM)-objdump $(BIN)/$(MY_LIB).a -d
	$(ASM)-objdump $(BIN)/$(INCHES_TO_FT).o -d
 
debug-main:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(INCREMENT_MAIN)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-infinite:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(INCREMENT_INFINITE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-static:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(REENTRANT_STATIC)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-stack:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(PROGRAM_STACK)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-add:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(ADD_VALUE)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

debug-inches2Ft:
	gdb-multiarch -q \
	-ex 'set architecture $(DEBUG_ARCH)' \
	-ex 'file ./$(BIN)/$(INCHES_TO_FT)' \
	-ex 'target remote localhost:$(DEBUG_PORT)' \
	-ex 'break main' \
	-ex continue \

clean:
	-rm ./$(BIN)/*
