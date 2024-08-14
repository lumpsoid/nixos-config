{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let 
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./host/omen/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
    apps.${system}.default = {
      type = "app";
      program = pkgs.writeShellApplication {
        name = "rebuild-nix";

        runtimeEnv = [ ];

        runtimeInputs = with pkgs; [
          coreutils
          git
          alejandra
          libnotify
        ];

        text = builtins.readFile ./modules/scripts/nix-rebuild.sh;
      };
    };
  };
}
