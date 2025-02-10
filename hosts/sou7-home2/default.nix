# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sou7-home2"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.wireless.userControlled.enable = true;

  networking.networkmanager.dns = "none";

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk libsForQt5.fcitx5-qt];
  };

  fonts.packages = with pkgs; [
    ipafont
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    jetbrains-mono
  ];

  # Configure console keymap
  console.keyMap = "jp106";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sou7 = {
    isNormalUser = true;
    description = "sou7";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    traceroute
    dig
  ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "";
    };
    desktopManager = {
      xterm.enable = true;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3blocks
        i3lock-fancy
      ];
    };
  };
  services.displayManager.defaultSession = "none+i3";

  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
    extraConfig = ''
      X11DisplayOffset 10
    '';
  };

  services.tailscale.enable = true;

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
    server = {
      port = 6742;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    2049 # NFS
    13353 # simutrans
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 7 * * * sou7 openrgb -m rainbow"
      "0 21 * * * sou7 openrgb -m off"
      "59 * * * * sou7 /home/sou7/nanasaba1st/autosave.sh"
      "30 4 * * * sou7 /home/sou7/nanasaba1st/daily.sh"
    ];
  };

  fileSystems."/home/sou7" = {
    device = "/home/sou7";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /home/sou7 192.168.0.0/24(rw,sync,no_root_squash,no_subtree_check)
      /home/sou7 100.64.0.0/10(rw,sync,no_root_squash,no_subtree_check)
    '';
    # 192.168.0.0/24 is the local network
    # 100. 64.0.0/10 is the Tailscale network
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
