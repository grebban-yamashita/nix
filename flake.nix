{
  inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

  inputs.nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

  inputs.nix-darwin.url = "github:LnL7/nix-darwin";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.flake-compat.flake = false;
  inputs.flake-compat.url = "github:edolstra/flake-compat";

  inputs.home-manager.url = "github:nix-community/home-manager";

  inputs.helix.inputs.crane.follows = "crane";
  inputs.helix.inputs.flake-utils.follows = "flake-utils";
  inputs.helix.url = "github:helix-editor/helix/master";

  inputs.catppuccin-helix.url = "github:catppuccin/helix";
  inputs.catppuccin-helix.flake = false;

  inputs.crane.url = "github:ipetkov/crane";

	inputs.devenv.url = "github:cachix/devenv";

	inputs.nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

  inputs.jujutsu.url = "github:martinvonz/jj";

	inputs.zig.url = "github:mitchellh/zig-overlay";

	nixConfig = {
    extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
    extra-substituters = [ "https://devenv.cachix.org" ];
  };

  outputs = { determinate, nix-darwin, home-manager, nix-homebrew, ... }@inputs: let
		overlays = [
			inputs.jujutsu.overlays.default
			inputs.helix.overlays.default
			inputs.zig.overlays.default
		];
	in {
    darwinConfigurations = let
			makeConfig = name: modules: nix-darwin.lib.darwinSystem {
			  modules = [
					{ nixpkgs.overlays = overlays; }
					determinate.darwinModules.default
					./configuration.nix
					./home/${name}/configuration.nix

					home-manager.darwinModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = { inherit inputs ; };
						home-manager.users = {
							${name} = import ./home/${name}/home.nix;
						};
					}
					nix-homebrew.darwinModules.nix-homebrew
					{
						nix-homebrew = {
							enable = true;
							enableRosetta = true;
							user = "${name}";
						};
					}
				];
			};
			in {
			  default = makeConfig "yamashita" [];
			  work = makeConfig "work" [];
			};
  };
}
