# Cadeia de ferramentas ARM
AS      = arm-none-eabi-as
LD      = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
SIZE    = arm-none-eabi-size

# Opções para Cortex-M4F
CPU     = cortex-m4
ASFLAGS = -mcpu=$(CPU) -mthumb -g
LDFLAGS = -T linker.ld -nostdlib

# Arquivos
OBJ = startup.o main.o
ELF = firmware.elf
BIN = firmware.bin
HEX = firmware.hex

.PHONY: all clean flash size

all: $(BIN) $(HEX) size

%.o: %.s
	@echo "  AS      $<"
	$(AS) $(ASFLAGS) $< -o $@

$(ELF): $(OBJ)
	@echo "  LD      $@"
	$(CC) $(LDFLAGS) $(OBJ) -o $@

$(BIN): $(ELF)
	@echo "  OBJCOPY $@"
	$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	@echo "  OBJCOPY $@"
	$(OBJCOPY) -O ihex $< $@

size: $(ELF)
	@echo "  Tamanho da imagem:"
	$(SIZE) $(ELF)

clean:
	rm -f $(OBJ) $(ELF) $(BIN) $(HEX)

flash: