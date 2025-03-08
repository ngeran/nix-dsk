# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
       # Include NixOS Hαrdware
       #inputs.nixos-hardware.nixosModules.common-gpu-amd
       #inputs.nixos-hardware.nixosModules.common-cpu-amd
       inputs.nixos-hardware.nixosModules.common-pc-ssd

       # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/global/desktop
      ../common/global/desktop/thunar.nix
      ../common/optional/bluetooth.nix
      ../common/optional/pipewire.nix
      ../common/optional/qemu.nix
      ../common/optional/docker.nix
      #../common/optional/wireguard
    ];

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # Automatic Cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];


  # Define your hostname.
  networking.hostName = "desktop";
   # AMD Graphcs
    hardware.graphics = {
    enable = true;
    enable32Bit = true;
   };
   # AMD OpenCL
  hardware.amdgpu.opencl.enable = true;

  # Hyprland Configuration
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User account.
  users.users.nikos = {
    isNormalUser = true;
    description = "nikos";
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim
    # wget
    # git
  ];

  # This overlay is required by LogSeq
  nixpkgs.config.permittedInsecurePackages = [
                "electron-27.3.11"
              ];

  nixpkgs.overlays = [
  (
    final: prev: {
      logseq = prev.logseq.overrideAttrs (oldAttrs: {
        postFixup = ''
          makeWrapper ${prev.electron_20}/bin/electron $out/bin/${oldAttrs.pname} \
            --set "LOCAL_GIT_DIRECTORY" ${prev.git} \
            --add-flags $out/share/${oldAttrs.pname}/resources/app \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
        '';
      });
    }
  )
 ];

  # Power Management
  powerManagement.powertop.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?
  # Enable Flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
