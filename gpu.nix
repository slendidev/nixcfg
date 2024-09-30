{ config, lib, pkgs, ... }: {
	hardware.nvidia = {
		package = config.boot.kernelPackages.nvidiaPackages.latest;

		open = true;
		modesetting.enable = true;
		nvidiaSettings = true;
	};

	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.opengl.enable = true;
	hardware.opengl.driSupport32Bit = true;
}

