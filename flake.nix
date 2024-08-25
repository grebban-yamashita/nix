{
  inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

  inputs.nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

  inputs.nix-darwin.url = "github:LnL7/nix-darwin";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.flake-compat.flake = false;
  inputs.flake-compat.url = "github:edolstra/flake-compat";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "determinate";

  inputs.helix-master.inputs.crane.follows = "crane";
  inputs.helix-master.inputs.flake-utils.follows = "flake-utils";
  inputs.helix-master.inputs.nixpkgs.follows = "determinate";
  inputs.helix-master.url = "github:helix-editor/helix";

  inputs.catppuccin-helix.url = "github:catppuccin/helix";
  inputs.catppuccin-helix.flake = false;
  inputs.catppuccin-wezterm.url = "github:catppuccin/wezterm";
  inputs.catppuccin-wezterm.flake = false;

  inputs.wezterm.flake = false;
  inputs.wezterm.url = "github:notohh/wezterm?dir=nix&ref=nix-add-overlay";

  inputs.crane.inputs.nixpkgs.follows = "determinate";
  inputs.crane.url = "github:ipetkov/crane";

  outputs = { determinate, nix-darwin, home-manager, nix-homebrew, helix-master, catppuccin-helix, ... }: {
    darwinConfigurations = let
			makeConfig = name: modules: nix-darwin.lib.darwinSystem {
			  modules = [
					determinate.darwinModules.default
					./configuration.nix
					./home/${name}/configuration.nix
					home-manager.darwinModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = { inherit helix-master catppuccin-helix determinate; };
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
