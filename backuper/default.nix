{ config, pkgs, ... }:
{
  fileSystems."/mnt/nfs" = {
    device = "/dev/disk/by-uuid/6ee83677-4096-4a6f-8795-dc23a16dfb4b";
    fsType = "ext4";
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "joris" ];
      PermitRootLogin = "no";
    };
  };
}
