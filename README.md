stm32f429-linux-builder
======================
This is a simple tool designed to create a uClinux distribution for STM32f429
Discovery board from [STMicroelectronics](http://www.st.com/). STM32F429 MCU
offers the performance of ARM Cortex M4 core (with floating point unit) running
at 180 MHz while reaching reasonably lower static power consumption.


Prerequisites
=============
The builder requires that various tools and packages be available for use in
the build procedure:

* [OpenOCD](http://openocd.sourceforge.net/)
  - OpenOCD 0.7.0 (and the 0.7.0-2 from Debian) can't write romfs to flash
    because of a post-0.7.0-stable bug (bad flash detection on stm32f429).
    You need to use 0.8.0 development version.
```
    git clone git://git.code.sf.net/p/openocd/code openocd
    cd openocd
    ./bootstrap
    ./configure --prefix=/usr/local --enable-stlink
    echo -e "all:\ninstall:" > doc/Makefile
    make
    sudo make install
```
* Set ARM/uClinux Toolchain:
  - Install arm-cortexm3-uclinuxeabi toolchain (http://www.pengutronix.de/oselas/toolchain/index_en.html)
```
     echo "deb http://debian.pengutronix.de/debian/ sid main contrib non-free" | sudo tee /etc/apt/sources.list.d/pengutronix.list
     sudo apt-get install oselas.toolchain-2014.12.0-arm-cortexm3-uclinuxeabi-gcc-4.9.2-uclibc-0.9.33.2-binutils-2.24-kernel-3.16-sanitized
     $ export PATH=/opt/OSELAS.Toolchain-2014.12.0/arm-cortexm3-uclinuxeabi/gcc-4.9.2-uclibc-0.9.33.2-binutils-2.24-kernel-3.16-sanitized/bin:$PATH

```
* [genromfs](http://romfs.sourceforge.net/)
```
    sudo apt-get install genromfs
```


Build Instructions
==================
* Simply execute ``make``, and it will fetch and build u-boot, linux kernel, and busybox from scratch:
```
    make
```
* Once STM32F429 Discovery board is properly connected via USB wire to Linux host, you can execute ``make install`` to flash the device. Note: you have to ensure the installation of the latest OpenOCD in advance.
```
    sudo env "PATH=$PATH" make install
```
Be patient when OpenOCD is flashing. Typically, it takes about 55 seconds.
Use `make help` to get detailed build targets.


USART Connection
================
The STM32F429 Discovery is equipped with various USARTs. USART stands for
Universal Synchronous Asynchronous Receiver Transmitter. The USARTs on the
STM32F429 support a wide range of serial protocols, the usual asynchronous
ones, plus things like IrDA, SPI etc. Since the STM32 works on 3.3V levels,
a level shifting component is needed to connect the USART of the STM32F429 to
a PC serial port.

Most PCs today come without an native RS232 port, thus an USB to serial
converter is also needed.

For example, we can simply connect the RX of the STM32 USART1 to the TX of
the converter, and the TX of the USART1 to the RX of the converter:
* pin PA9  (USART1_TX) -> USB UART RXD (White cable)
* pin PA10 (USART1_RX) -> USB UART TXD (Green cable)


Reference Boot Messages
=======================
```
U-Boot 2015.04-g0b08303 (May 26 2015 - 22:02:26)

DRAM:  8 MiB
WARNING: Caches not enabled
Flash: 2 MiB

Hit any key to stop autoboot:  0 
## Booting kernel from Legacy Image at 08020000 ...
...

Starting kernel ...

Booting Linux on physical CPU 0x0
Linux version 4.0.0-g21370f3 (adrian@adrian-F6S) (gcc version 4.9.2 (OSELAS.Toolchain-2014.12.0) ) #1 PREEMPT Tue May 26 22:08:23 CST 2015
CPU: ARMv7-M [410fc241] revision 1 (ARMv7M), cr=00000000
CPU: unknown data cache, unknown instruction cache
Machine model: STMicroelectronics STM32F429i-DISCO board
...
VFS: Mounted root (romfs filesystem) readonly on device 31:0.
...
Welcome to
          ____ _  _
         /  __| ||_|                 
    _   _| |  | | _ ____  _   _  _  _ 
   | | | | |  | || |  _ \| | | |\ \/ /
   | |_| | |__| || | | | | |_| |/    \
   |  ___\____|_||_|_| |_|\____|\_/\_/
   | |
   |_|

For further information check:
http://www.uclinux.org/
```
