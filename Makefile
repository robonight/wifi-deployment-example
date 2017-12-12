
CXX=${ARDUINO_ROOT}/hardware/tools/avr/bin/avr-c++
CXXFLAGS=-g -Os -w -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics \
		 -flto -w -x c++ -E -CC -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10803 -DARDUINO_AVR_UNO_WIFI_DEV_ED \
		 -DARDUINO_ARCH_AVR -DESP_CH_UART -DESP_CH_UART_BR=19200 -I${ARDUINO_ROOT}/hardware/arduino/avr/cores/arduino \
		 -I${ARDUINO_ROOT}/hardware/arduino/avr/variants/standard

build:
	mkdir build

build/%.cpp.o: %.cpp build
	$(CXX) $(CXXFLAGS) -c -o $@ $<

build/wifi.hex: build/wifi.cpp.o
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:
	rm -r build
