FLASH_CMD := openocd \
	-f board/stm32f429discovery.cfg \
	-c "init" \
	-c "reset init" \
	-c "flash probe 0" \
	-c "flash info 0" \
	-c "flash write_image erase $(uboot_target)  0x08000000" \
	-c "flash write_image erase $(kernel_target) 0x08020000" \
	-c "flash write_image erase $(dtb_target)    0x08160000" \
	-c "flash write_image erase $(rootfs_target) 0x08180000" \
	-c "reset run" -c shutdown
