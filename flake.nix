{
	description = "ngeran Nixos Flake";


	inputs = {
	  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
          hyprland.url = "github:hyprwm/Hyprland";
          stylix.url = "github:danth/stylix/release-25.11";
          nix-colors.url = "github:misterio77/nix-colors";
          nixos-hardware.url = "github:NixOS/nixos-hardware/master";
          #===[NIXVIM]===
          nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
          };
          #===[HYPRLAND]===
          hyprland-plugins = {
	         url = "github:hyprwm/hyprland-plugins";
	         inputs.hyprland.follows = "hyprland";
           };
           #===[HOME MANAGER]===
          home-manager = {
             url = "github:nix-community/home-manager";
             inputs.nixpkgs.follows = "nixpkgs";
             };
	};


	outputs = { self, nixpkgs, home-manager, nixos-hardware, stylix, ...}@inputs:
		let
       inherit (self) outputs;
       lib = nixpkgs.lib // home-manager.lib;
       system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        user = "nikos";
		in
		{
         inherit lib;
		   # ===[NixOs Configuratation]===
		   nixosConfigurations = {
        # ASUS DESKTOP ===[Custom Workstation]===
        asus = lib.nixosSystem {
                     specialArgs = {inherit inputs outputs system;};
                     modules = [./hosts/asus/configuration.nix ];
		              };

         # ELITEDESK ===[Mini Workstation]===
         elitedesk = lib.nixosSystem {
                     specialArgs = {inherit inputs outputs system;};
                     modules = [./hosts/elitedesk/configuration.nix inputs.stylix.nixosModules.stylix];
		              };

         # DESKTOP ===[Main Workstation]===
         desktop = lib.nixosSystem {
                     specialArgs = {inherit inputs outputs system;};
                     modules = [./hosts/desktop/configuration.nix inputs.stylix.nixosModules.stylix];
		              };

         # VMWARE===[VMWARE INSTALLATION]===
         vmware = lib.nixosSystem {
                     specialArgs = {inherit inputs outputs system;};
                     modules = [./hosts/vmware/configuration.nix inputs.stylix.nixosModules.stylix];
                     };

          # MACBOOK===[MACBOOK INSTALLATION]===
         macbook = lib.nixosSystem {
                     specialArgs = {inherit inputs outputs system;};
                     modules = [./hosts/macbook/configuration.nix inputs.stylix.nixosModules.stylix];
                     };

      };

         # ===[Home Manager Configuration]===
         homeConfigurations = {
         # ELITEDESK ===[Mini Workstation]===
         "nikos@elitedesk" = lib.homeManagerConfiguration {
                     pkgs = nixpkgs.legacyPackages.${system};
                     extraSpecialArgs = {inherit inputs;};
                     modules = [./home-manager/elitedesk.nix];
                  };

         # DESKTOP ===[Main Workstation]===
         "nikos@asus" =  lib.homeManagerConfiguration {
                     pkgs = nixpkgs.legacyPackages.${system};
                     extraSpecialArgs = {inherit inputs;};
                     modules = [./home-manager/asus.nix];
                  };

          #VMWARE ===[VMWARE Workstation]===
         "nikos@vmware" = lib.homeManagerConfiguration {
	                  pkgs = nixpkgs.legacyPackages.${system};
                     extraSpecialArgs = { inherit inputs outputs;};
                     modules = [ ./home-manager/vmware.nix ];
                   };

         #MACBOOK ===[MACBOOK Laptop]===
         "nikos@macbook" = lib.homeManagerConfiguration {
	                  pkgs = nixpkgs.legacyPackages.${system};
                     extraSpecialArgs = { inherit inputs outputs;};
                     modules = [ ./home-manager/macbook.nix ];
                   };

         };
		};

}
