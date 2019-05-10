#source filename
code=main/main

#output filename
outfile=main/main
	
doxy:
	doxygen DoxyConfig
    
all: 
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c $(code).c -o $(outfile).o
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c Source/CRC.c -o CRC.o
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c Source/UART_Init.c -o UART_Init.o
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c Source/ISR.c -o ISR.o
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c Source/PhysicalLayer/PhysicalLayer.c -o PhysicalLayer.o
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c Source/DataLinkLayer/DataLinkLayer.c -o DataLinkLayer.o
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c Source/NetworkLayer/NetworkLayer.c -o NetworkLayer.o
	avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=12000000L -c Source/PinConf.c -o PinConf.o

	avr-gcc -mmcu=atmega328p -o $(outfile).elf $(outfile).o PhysicalLayer.o DataLinkLayer.o NetworkLayer.o CRC.o UART_Init.o ISR.o PinConf.o
	avr-objcopy -O ihex $(outfile).elf $(outfile).hex
	avrdude -c gpio -F -V -p ATMEGA328P -P /dev/ttyAMA0 -b 9600 -U flash:w:$(outfile).hex

	rm $(outfile).elf $(outfile).hex $(outfile).o PhysicalLayer.o DataLinkLayer.o NetworkLayer.o CRC.o UART_Init.o ISR.o PinConf.o
