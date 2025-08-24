# ============================================================
# NixOS Configuration for AMD GPU Optimization (Ollama Focus)
# ============================================================
#
# Description:
# This configuration is tailored for systems with modern AMD GPUs (e.g., RX 7600, "gfx1101")
# to enable full GPU acceleration for compute workloads like Ollama, machine learning,
# and scientific computing via the ROCm platform. It also maintains a robust desktop
# environment (Hyprland) and system management setup.
#
# Key Features:
# - Full ROCm stack enablement for GPU compute (OpenCL, HIP)
# - Automatic targeting of the specific "gfx1101" GPU architecture
# - Ollama installation and systemd service for automatic startup
# - User permission configuration for GPU access
# - Performance monitoring tools (rocm-smi)
# - Hyprland Wayland compositor with necessary GPU support
#
# Dependencies:
# - A flake input for `nixos-hardware` (for common AMD modules)
# - A flake input for `hyprland` (if using the Hyprland module)
#
# How to Use:
# 1. Place this file as your /etc/nixos/configuration.nix
# 2. Ensure your /etc/nixos/flake.nix imports the necessary inputs (nixos-hardware, hyprland).
# 3. Run `sudo nixos-rebuild switch` to build and apply the configuration.
# 4. Reboot to ensure all kernel modules and user groups are properly loaded.
# 5. Verify with `rocm-smi` and `ollama ps`.
# ============================================================

{ config, pkgs, lib, inputs, ... }:

{
  # ==================== SYSTEM IMPORTS ====================
  # Description: Import common hardware profiles and modular configurations.
  # This promotes reuse and keeps the main config file clean.
  imports =
    [
      # Import common AMD hardware profiles from nixos-hardware flake
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-pc-ssd

      # Import the generated hardware scan and modular configs
      ./hardware-configuration.nix
      ../common/global/desktop
      ../common/optional/bluetooth.nix
      ../common/optional/pipewire.nix
      ../common/optional/qemu.nix
      ../common/optional/docker.nix
      ../common/optional/wireshark.nix
    ];


  # ==================== SYSTEM AUTOMATION ====================
  # Description: Automates system updates and garbage collection to keep the system
  # lean and up-to-date without manual intervention.
  system.autoUpgrade = {
    enable = true; # Enable automatic weekly system updates
    dates = "weekly";
  };
  nix = {
    gc = {
      automatic = true; # Automatically run garbage collection
      dates = "daily";
      options = "--delete-older-than 10d"; # Remove store paths older than 10 days
    };
    settings.auto-optimise-store = true; # Automatically optimise the store
  };


  # ==================== BOOT CONFIGURATION ====================
  # Description: Configures the bootloader and initial ramdisk modules.
  # Loading the 'amdgpu' kernel module early is crucial for GPU functionality.
  boot = {
    loader = {
      systemd-boot.enable = true; # Use systemd-boot as the bootloader
      efi.canTouchEfiVariables = true; # Allow management of EFI boot variables
    };
    initrd.kernelModules = [ "amdgpu" ]; # Load AMD GPU driver early in the boot process
  };


  # ==================== STORAGE CONFIGURATION ====================
  # Description: Mounts additional internal drives at boot.
  fileSystems."/mnt/DATA-2T" = {
    device = "UUID=1b079941-401f-430f-97e7-8eacd6b25e82";
    fsType = "ext4";
    options = [ "defaults" ];
  };
  fileSystems."/mnt/SSD-250" = {
    device = "UUID=C8057DD5A2F97C72";
    fsType = "ntfs";
    options = [ "defaults" "uid=1000" "gid=100" ]; # Mount with specific user/group permissions
  };


  # ==================== NETWORKING & HOSTNAME ====================
  # Description: Basic network configuration.
  networking = {
    hostName = "ngeran"; # Define your machine's hostname
    networkmanager.enable = true; # Use NetworkManager for network management
  };


  # ==================== AMD GPU & ROCm CONFIGURATION ====================
  # Description: The core configuration for enabling GPU compute.
  # This section installs the ROCm stack, targets the specific GPU architecture (gfx1101),
  # and sets environment variables required for tools like Ollama to detect and use the GPU.
  hardware = {
    opengl = {
      enable = true; # Essential for hardware acceleration
      driSupport = true; # Enable Direct Rendering Infrastructure
      driSupport32Bit = true; # Support 32-bit OpenGL applications
      extraPackages = with pkgs; [
        rocm-opencl-icd    # OpenCL support for compute tasks
        rocm-runtime       # Core ROCm runtime, includes HIP (Heterogeneous-Compute Interface for Portability)
        rocm-smi           # Monitoring tool for AMD GPUs (incredibly useful for verification)
        amdvlk             # AMD's open-source Vulkan driver for graphics
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk # 32-bit Vulkan driver for compatibility
      ];
    };
    # Enable AMD's open-source Vulkan driver
    amdgpu.amdvlk.enable = true;
  };

  # Environment variables critical for ROCm to find libraries and target the correct GPU
  environment.variables = {
    ROCM_PATH = "${pkgs.rocm-runtime}"; # Points to the ROCm installation directory
    # Override to target the specific GPU architecture (Navi 33/RX 7600 is 'gfx1101')
    # The version format is 'major.minor.patch'. For architecture ID 'gfx1101', use '11.0.0'.
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    # Alternative environment variable used by some older ROCm tools
    HCC_AMDGPU_TARGET = "gfx1101";
  };


  # ==================== DESKTOP & DISPLAY ====================
  # Description: Configures the Hyprland Wayland compositor.
  programs.hyprland = {
    enable = true;
    # Use the Hyprland package from the flake input to ensure latest version
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # Use the matching portal for proper desktop integration
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };


  # ==================== LOCALIZATION ====================
  # Description: Sets time zone and locale settings.
  time.timeZone = "America/New_York"; # Define your time zone
  i18n.defaultLocale = "en_US.UTF-8"; # Set the default system locale
  # Configure console and X11 keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # ==================== USER CONFIGURATION ====================
  # Description: Defines the primary user account and grants necessary permissions.
  # The 'render' and 'video' groups are required for GPU access.
  users.users.nikos = {
    isNormalUser = true;
    description = "nikos";
    # Grant user permissions for network, admin, containers, and GPU access
    extraGroups = [ "networkmanager" "wheel" "docker" "render" "video" ];
    packages = with pkgs; [];
  };


  # ==================== SYSTEM PACKAGES ====================
  # Description: Installs essential system-wide packages.
  environment.systemPackages = with pkgs; [
    ollama  # The Ollama CLI and server for running LLMs
  ];


  # ==================== OLLAMA SERVICE ====================
  # Description: Configures Ollama to run as a systemd service, automatically
  # starting at boot and restarting on failure. This allows Ollama to be always available.
  systemd.services.ollama = {
    enable = true;
    description = "Ollama Service";
    after = [ "network.target" ]; # Start after the network is online
    wantedBy = [ "multi-user.target" ]; # Start when the multi-user system is ready
    serviceConfig = {
      ExecStart = "${pkgs.ollama}/bin/ollama serve"; # Command to start the service
      User = "nikos"; # Run the service as the main user for file permissions
      Group = "users";
      Restart = "on-failure"; # Automatically restart if the process fails
      # (Optional) You can set environment variables specific to the service here too
      # Environment = "HSA_OVERRIDE_GFX_VERSION=11.0.0";
    };
  };


  # ==================== NIXPKGS SETTINGS ====================
  # Description: Global settings for the Nix package manager.
  nixpkgs.config.allowUnfree = true; # Allow installation of proprietary software

  # Overlay to fix LogSeq electron version
  nixpkgs.overlays = [
    (final: prev: {
      logseq = prev.logseq.overrideAttrs (oldAttrs: {
        postFixup = ''
          makeWrapper ${prev.electron_20}/bin/electron $out/bin/${oldAttrs.pname} \
            --set "LOCAL_GIT_DIRECTORY" ${prev.git} \
            --add-flags $out/share/${oldAttrs.pname}/resources/app \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
            --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [ prev.stdenv.cc.cc.lib ]}"
        '';
      });
    })
  ];
  # Permit specific insecure packages (required for the LogSeq overlay)
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];


  # ==================== SYSTEM UTILITIES ====================
  # Description: Enables various system services.
  powerManagement.powertop.enable = true; # Enable power management tuning
  services.openssh.enable = true; # Enable SSH server for remote access


  # ==================== NIX & SYSTEM VERSION ====================
  # Description: Core Nix settings and system state version.
  # This must match the version you initially installed.
  system.stateVersion = "24.11";
  # Enable the experimental Flakes and nix-command features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
