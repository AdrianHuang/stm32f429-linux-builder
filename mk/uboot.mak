build-uboot:
	$(shell mkdir -p ${target_out_uboot})
	make -C $(uboot_dir) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(target_out_uboot) stm32f429-discovery_defconfig
	env LANG=C make -C $(uboot_dir) \
		ARCH=arm CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(target_out_uboot)
