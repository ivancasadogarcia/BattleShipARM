#-------------------------------------------------------------------------------
# Example Makefile to assembly, link and debug ARM source code
# Author: Santiago Romani
# Date: February 2016
# Licence: Public Domain
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# options for code generation
#-------------------------------------------------------------------------------
ASFLAGS	:= -march=armv5te -mlittle-endian -g
LDFLAGS := -z max-page-size=0x8000


#-------------------------------------------------------------------------------
# make commands
#-------------------------------------------------------------------------------

barcos.elf : barcos_p.o barcos_j.o startup.o
	arm-none-eabi-ld $(LDFLAGS) barcos_p.o barcos_j.o startup.o libBarcos.a -o barcos.elf

barcos_p.o : barcos_p.s
	arm-none-eabi-as $(ASFLAGS) barcos_p.s -o barcos_p.o
	
barcos_j.o : barcos_j.s
	arm-none-eabi-as $(ASFLAGS) barcos_j.s -o barcos_j.o

startup.o : startup.s
	arm-none-eabi-as $(ASFLAGS) startup.s -o startup.o


#-------------------------------------------------------------------------------
# clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv startup.o
	@rm -fv barcos_p.o
	@rm -fv barcos_j.o
	@rm -fv barcos.elf


#-------------------------------------------------------------------------------
# debug commands
#-------------------------------------------------------------------------------
debug : barcos.elf
	arm-eabi-insight barcos.elf &

