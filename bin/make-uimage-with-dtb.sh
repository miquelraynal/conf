#!/bin/sh

echo "*** Make zImage ***"
#cd ~/linux-stable-work # base dire
rm -f arch/arm/boot/*Image*
rm -f arch/arm/boot/.*Image*
make zImage

echo "*** Make DTB ***"
rm -f arch/arm/boot/dts/*thelma7*dtb
make dtbs

echo "*** Append dtb to zImage ***"
cd arch/arm/boot # boot dir
mv zImage zImage-wo-dtb
cat zImage-wo-dtb dts/*thelma7*dtb > zImage-w-dtb
#cat zImage-wo-dtb dts/imx27-eukrea-mbimxsd27-baseboard.dtb > zImage-w-dtb

echo "*** Make uImage ***"
mkimage -A arm -O linux -T kernel -C none -a 0xa0008000 -e 0xa0008000 -d zImage-w-dtb uImage-w-dtb
ln -sf uImage-w-dtb uImage

ls -l *Image*
