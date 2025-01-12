{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprlang = {
    #   url = "github:hyprwm/hyprlang/dfeb5811dd6485490cce18d6cc1e38a055eea876";
    # };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.hyprlang.follows = "hyprlang";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
    };

    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
      # because of specialArgs you can access inputs from within other modules
      specialArgs = {inherit inputs;};
      modules = [
        inputs.home-manager.nixosModules.default
        inputs.nixvim.nixosModules.nixvim
        inputs.niri.nixosModules.niri
        ./host/omen/configuration.nix
      ];
    };
  };
}
