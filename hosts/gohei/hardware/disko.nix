{ hostProps, ... }:
{
  disko.devices = {
    disk.main = {
      device = "${hostProps.mainDiskDevice}";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            start = "1M";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
    disk.data = {
      device = "/dev/disk/by-id/nvme-KIOXIA-EXCERIA_PLUS_G3_SSD_3FQKS0CSZ0E7";
      content = {
        type = "gpt";
        partitions = {
          main = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/root";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@saya" = {
                  mountpoint = "/home/saya";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /root 0700 root root -"
    "d /home/saya 0700 saya users -"
  ];
}
