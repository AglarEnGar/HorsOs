{pkgs, ...}:
{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024;
    }
  ];
	boot.resumeDevice = "/dev/nvme1n1p3";
	services.udev.extraRules = ''
		ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x1483" ATTR{power/wakeup}="disabled"
	'';
}
