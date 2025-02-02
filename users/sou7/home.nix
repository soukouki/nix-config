{pkgs, ...}: {
  programs.home-manager.enable = true;
  home = {
    username = "sou7";
    homeDirectory = "/home/sou7";
    stateVersion = "24.11";
    packages = with pkgs; [
      openrgb
      vim
      xfce.xfce4-terminal
      git
    ];
  };
}

