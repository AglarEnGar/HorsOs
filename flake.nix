{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations.HorsOs = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.catppuccin.nixosModules.catppuccin
        inputs.home-manager.nixosModules.home-manager

        {
          # if you use home-manager
          home-manager.users.nickd = {
            imports = [
              ./hmconfigs/home.nix
              inputs.catppuccin.homeModules.catppuccin
            ];
          };
        }
      ];
    };
  };
}
