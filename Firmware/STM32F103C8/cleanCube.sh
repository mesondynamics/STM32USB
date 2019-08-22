#!/bin/sh

# Clean up the STM32CubeMX generated code.

if [ $# -eq 0 ]; then
    echo "root/ of STM32CubeMX generated code needed."
    exit 1
fi

cube="$1"
echo "Cleaning up $cube ..."

find "$cube" -type d -exec chmod 0755 {} \;
find "$cube" -type f -exec chmod 0644 {} \;

# Create a new 'makefile'.
# `make` searches for 'makefile' before 'Makefile', so the new file will be used.
mkf="$cube/Makefile"
mkfo="$cube/makefile"

# dos to unix, then remove trailing white space
# This one can work if using bash: sed $'s/\r$//' "$mkf".
# Then add .c's and -I directories.
sed -e 's/$//; s/[ 	]*$//' \
    -e 's#Src/main\.c#main\.c#' \
    -e 's#Src/usbd_cdc_if\.c#usbd_cdc_if\.c#' \
    -e '/C_SOURCES =/{
        a \
../cmdinterp.c \\\
../syscalls.c \\
        }' \
    -e '/C_INCLUDES =/{
        a \
-I.. \\
        }' \
    "$mkf" > "$mkfo"

# Create a new main.c file with local additions.
mf="$cube/Src/main.c"
mfo="$cube/main.c"
sed -e 's/$//; s/[ 	]*$//' \
    -e '/USER CODE BEGIN Includes/{
        a \
#include "usbd_cdc_if.h"
       }' \
    -e '/USER CODE BEGIN 0/{
        a \
#include "../insertIntoMain.c"
        }' \
    -e '/USER CODE BEGIN 2/{
        a \
\ \ stm32_init();
        }' \
    -e '/USER CODE BEGIN 3/{
        a \
\ \ \ \ stm32_main_loop();
        }' \
    -e '/USER CODE BEGIN 6/{
        a \
\ \ printf("Error: file %s, line %lu\\n", file, line);
        }' \
    "$mf" > "$mfo"

# Create a new usbd_cdc_if.c file with local additions.
mf="$cube/Src/usbd_cdc_if.c"
mfo="$cube/usbd_cdc_if.c"
sed -e 's/$//; s/[ 	]*$//' \
    -e '/USER CODE BEGIN PRIVATE_FUNCTIONS_DECLARATION/{
        a \
#include "../insertIntoUsbd_cdc_if.c"
        }' \
    -e '/USER CODE BEGIN 6/{
        a \
\ \ usb_recv(Buf, Len);
        }' \
    "$mf" > "$mfo"
