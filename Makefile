
C_OBJECTS =
ASM_OBJECTS = tableGen.o

makegray: $(C_OBJECTS) $(ASM_OBJECTS)
	gcc -g -o main $(C_OBJECTS) $(ASM_OBJECTS)

.c.o:
	gcc -I. -g -c $<

.S.o:
	gcc -I. -g -c $< 

clean:
	rm -f *.o main *~ *.pgm

