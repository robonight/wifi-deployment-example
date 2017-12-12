
CXX=${ARDUINO_ROOT}/hardware/tools/avr/bin/avr-c++
CXXFLAGS=-g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics \
		 -MMD -flto -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10803 -DARDUINO_AVR_UNO_WIFI_DEV_ED -DARDUINO_ARCH_AVR \
		 -DESP_CH_UART -DESP_CH_UART_BR=19200 "-I${ARDUINO_ROOT}/hardware/arduino/avr/cores/arduino"  \
		 "-I${ARDUINO_ROOT}/hardware/arduino/avr/variants/standard" -DFROM_MAKE

LINK=${ARDUINO_ROOT}/hardware/tools/avr/bin/avr-gcc
LINKFLAGS=-w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p -L/build -lm

CORE_SOURCES=$(wildcard ${ARDUINO_ROOT}/hardware/arduino/avr/cores/arduino/*.cpp)
CORE_OBJECTS=$(patsubst ${ARDUINO_ROOT}/hardware/arduino/avr/cores/arduino/%,build/core/%.o,$(CORE_SOURCES))

build:
	mkdir -p build

build/%.cpp.o: %.cpp build
	#$(CXX) $(CXXFLAGS) -c -o $@ $<

build/core: build
	mkdir -p build/core

build/core/%.cpp.o: ${ARDUINO_ROOT}/hardware/arduino/avr/cores/arduino/%.cpp build/core
	$(CXX) $(CXXFLAGS) -c -o $@ $<

build/wifi.elf: $(CORE_OBJECTS) build/wifi.cpp.o 
	$(LINK) $(LINKFLAGS) -o $@ $^

clean:
	rm -r build
