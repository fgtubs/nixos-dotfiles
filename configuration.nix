{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hyprland-btw"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Temporarly allow traffic on port 8000
  networking.firewall.allowedTCPPorts = [ 8000 ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  services.getty.autologinUser = "fin";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" "dialout" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # Automatically deletes all nixos-builds that are: not the last 5 builds or that done in the last 4 days
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 5";
  };

  # allow unfree packages (for example for vagrant)
  nixpkgs.config.allowUnfree = true;

  # enable virtualisation programs
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    kitty
    alacritty
    waybar
    git
    hyprpaper
    hyprlock
    wofi
    neovim
    yazi
    iamb
    element-desktop
    libreoffice
    pamixer # soundcontrol
    brightnessctl # brightness control
    libvirt # virtualisation
    qemu_kvm # virtualisation
    virt-manager # virtualisation
    vagrant # virtualisation
    openconnect
    opencode
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05"; # Did you read the comment?

}

