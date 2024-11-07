{ config, pkgs, ... }:
{
  fileSystems."/mnt/nfs" = {
    device = "/dev/disk/by-uuid/6ee83677-4096-4a6f-8795-dc23a16dfb4b";
    fsType = "ext4";
  };

  users.users.backuper = {
    isSystemUser = true;
    uid = 500;
    group = "backuper";
    shell = pkgs.bashInteractive;
    description = "Restic Backups";
    createHome = true;
    openssh.authorizedKeys.keyFiles = [ ../ssh/thinkpad_yubikey.pub ];
  };
  users.groups.backuper.gid = 500;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "backuper" ];
      PermitRootLogin = "no";
    };
  };
}
