{ config, lib, pkgs, ... }:

{
  # imports = [ ./hardware-configuration.nix ];  # this is handled by the flake.nix file, so we don't need to import it here.

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  programs.niri.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable Thunderbird
  programs.thunderbird.enable = true;

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the Blueman service
  services.blueman.enable = true;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Add specific printer
  hardware.printers = {
    ensurePrinters = [
      {
        name = "KYOCERA-IPP";
        deviceUri = "ipp://134.169.115.2:443/ipp";
        model = "everywhere";
      }
    ];
  };

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
    fastfetch
    yazi
    fluffychat
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
    rpi-imager
    polkit_gnome # to be able to start some desktop apps
    xhost
    grim # screenshot: grep img
    slurp # screenshot: select region
    wl-clipboard # screenshot: copy to clipboard
    brave
    bazecor # keyboard configuration tool
    wl-clipboard # copy to clipboard for neovim
    arduino-ide



    ###################
    # Costum Commands #
    ###################

    # to start the policy kit agent (needed for some desktop apps that need root access), called when system starts
    (pkgs.writeShellScriptBin "start-polkit-agent" ''
      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '')
    # to start the RPi Imager using "flash-pi"
    (pkgs.writeShellScriptBin "flash-pi" ''
      # 1. Grant root GUI access
      ${pkgs.xhost}/bin/xhost +SI:localuser:root
      
      # 2. Trap ensures access is revoked the moment this script exits
      trap "${pkgs.xhost}/bin/xhost -SI:localuser:root" EXIT
      
      # 3. Launch the app as root while preserving Wayland display variables
      sudo -E ${pkgs.rpi-imager}/bin/rpi-imager
    '')
  ];
  

  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05"; # Did you read the comment?

}

