{pkgs, ...}: {
  programs.home-manager.enable = true;

  imports = [
    ../sou7-minimal/home.nix
  ];

  home = {
    packages = with pkgs; [
      xfce.xfce4-terminal
      fastfetch
      screen
    ];
  };

}
