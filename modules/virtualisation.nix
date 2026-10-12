{ pkgs, username, ... }:
{
  users.groups = {
    libvirtd.members = [ "${username}" ];
  };

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
}
