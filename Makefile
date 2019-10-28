# Paths
SRCDIR := src
OBJDIR := build
SRC    := $(wildcard $(SRCDIR)/*.s)
OBJ    := $(SRC:$(SRCDIR)/%.s=$(OBJDIR)/%.o)
PRG    := $(OBJ:$(OBJDIR)/%.o=$(OBJDIR)/%.prg)
D64    := $(OBJDIR)/1nvader.d64

# Commands
ASM = tmpx -o $@ -i $<
PAK = exomizer sfx 0x4000 -B -o $@ $<
RM := rm -rf
MKDIR := mkdir -p
MKD64 := c1541 -format 1nvader,1n d64

# Rules
$(OBJDIR)/%.o: $(SRCDIR)/%.s
	$(ASM)

$(OBJDIR)/%.prg: $(OBJDIR)/%.o
	$(PAK)

# Targets
.PHONY: all d64 prg clean

all: d64
prg: $(PRG)

d64: $(PRG)
	$(MKD64) $(D64) -attach $(D64) $(foreach p,$(PRG),-write $(p) $(subst .prg,,$(subst build/,,$(p))))

$(SRC): | $(OBJDIR)

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

clean:
	$(RM) $(OBJDIR)
