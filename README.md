# STM32USB
STM32 with USB connectivity (serial server)

# STM32F103C8T6 (Blue Pill)
  - [Pinout pdf](http://reblag.dk/wordpress/wp-content/uploads/2016/07/The-Generic-STM32F103-Pinout-Diagram.pdf).
  - [Info and schematic](https://github.com/jeelabs/embello/blob/master/docs/hardware/bluepill.md).  Also [here](https://os.mbed.com/users/hudakz/code/STM32F103C8T6_Hello/).

# STM32 ARM MCU firmware
  - `STM32CubeMX` is used to configure the pin function/clock and setup the basic software skeleton.
    - Make sure SYS->Debug = Serial Wire is selected.  Otherwise future flash writing will be disabled.
    - Choose `Makefile` under `Toolchain/IDE` for GNU-RM compatible skeleton.
    - Choose HAL set all free pins as analog and Enable full assert.
    - Make minimal modification to the generated code.  Place the majority of user code in separate files one level up to the generated code directory.
    - It seems asking the software to update the already generated files is not reliable.  Better delete all generated files and re-generate.
    - After copying the files over, run `cleanCube.sh` to clean up the file permissions and add additional information into `Makefile`.  New `makefile` is generated and `make` will pick up the new one automatically.  Modify `cleanCube.sh` accordingly when new `.c` files are added.
    - A new `main.c` is generated as well.  This way, no manual intervention to any of the STM32CubeMX generated files is needed.
## Useful commands
  - `readelf -a xxx.elf` or `objdump -h xxx.elf` to see the built image size.  Add up the size of all the loadable sections, such as `.text` and `.data`.  Look for the `LOAD` flag in the output from `objdump`.  Ignore non-loadable sections such as `.comment`, `.debug` and `.bss`.
## USB CDC ACM
  - (https://damogranlabs.com/2018/02/stm32-usb-cdc/).
## Toolchain
  - [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html)
  - [GNU](https://developer.arm.com/open-source/gnu-toolchain/gnu-rm)
    - Download and put into `~/Applications/arm`.
    - `~/Applications/arm/env.sh`:
    ```
    #!/bin/sh

    ARMROOT=$HOME/Applications/arm
    export PATH=$ARMROOT/bin:$ARMROOT/arm-none-eabi/bin:$PATH
    export LD_LIBRARY_PATH=$ARMROOT/lib:$LD_LIBRARY_PATH
    export MANPATH=$ARMROOT/share/man:$MANPATH
    ```
    - `arm-none-eabi-objdump -d build/main.o` to see the assembly code generated by `gcc`.
  - [stlink stm32 discovery line linux programmer](https://github.com/texane/stlink)
    - Install under `~/Applications/arm/`
    ```
    $ mkdir build && cd build
    $ cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/arm ..
    $ make -j5
    $ make DESTDIR=~/Applications install
    ```
    - `st-util`, `st-flash`, `st-info` to download image to/manipulate STM32 MCU.
  - [In-Application Programming (IAP)](https://www.st.com/en/embedded-software/x-cube-iap-usart.html)
  - [Open source ARM Cortex-M microcontroller library libopencm3](https://github.com/libopencm3/libopencm3)
  - [J-Link Debug Probes](https://www.segger.com/products/debug-probes/j-link/)
  - [Black Magic Probe: In application debugger for ARM Cortex microcontrollers](https://github.com/blacksphere/blackmagic)
