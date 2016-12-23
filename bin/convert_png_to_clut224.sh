#!/bin/sh

FILE=$1
NAME=$(basename $FILE .png)
DIR=$(dirname $FILE)

# Method from http://www.armadeus.com/wiki/index.php?title=Linux_Boot_Logo

# png --> ppm
convert $FILE ${DIR}/${NAME}.ppm

# reduce number of colors to 224
ppmquant 224 ${DIR}/${NAME}.ppm > ${DIR}/${NAME}_224.ppm

# ppm --> ppm ascii
pnmnoraw ${DIR}/${NAME}_224.ppm > ${DIR}/${NAME}_ascii_224.ppm

echo "You may now:"
echo "$ cp ${DIR}/${NAME}_ascii_224.ppm ~/linux*/drivers/video/logo/${NAME}_clut224.ppm"

# For Barebox, just
# $ lzop -o logo.bmp.lzo logo.bmp
# $ cp logo.bmp.lzo ~/barebox/arch/arm/boards/navocap_thelma7/env/logo.bmp.lzo
