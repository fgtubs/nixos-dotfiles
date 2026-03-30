{ config, pkgs, ... }:
let
	yazi-flavors = pkgs.fetchFromGitHub {
		owner = "yazi-rs";
		repo = "flavors";
		rev = "master";
		sha256 = "sha256-bynoDEuRLyVqTOty8Ul2vxy8YKaKHcWHAhKvYlwkKo4=";
	};
in
{
	home.username = "fin";
	home.homeDirectory = "/home/fin";
	home.stateVersion = "25.05";

    wayland.windowManager.hyprland = {
        enable = true;

        # IMPORTANT: Disable this to avoid conflicts with UWSM
        systemd.enable = false; 
    };

	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo i use hyprland btw";
			jana = "echo ich liebe dich";
			vim = "nvim";
		};
        # 				exec Hyprland
		profileExtra = ''
			if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                exec start-hyprland
			fi
		'';
		initExtra = ''
			export PS1='\[\e[38;5;208m\]\u\[\e[0m\] in \[\e[38;5;53m\]\w\[\e[0m\] \[\e[38;5;123m\]\\$\[\e[0m\] '
		'';
	};

	programs.yazi = {
		enable = true;
        shellWrapperName = "y";

		# enable the specific flavor
		settings = {
			flavors = {
				use = "catppuchin-mocha";
			};
            opener = {
                pdf = [
                    { run = "zathura \"$@\" & ya emit quit"; orphan = true; }
                ];
                edit = [
                    { run = "nvim \"$@\""; block = true; }
                ];
                impress = [
                    { run = "libreoffice --impress \"$@\" & ya emit quit"; orphan = true; }
                ];
            };
            open = {
                rules = [
                    # Special rule for PDFs
                    { name = "*.pdf"; use = "pdf"; }
                    # Special rule for Presentations in .odp or .ppp format
                    { name = "*.odp";  use = "impress"; }
                    { name = "*.ppt";  use = "impress"; }
                    { name = "*.pptx"; use = "impress"; }
                    # Fallback for text (and other files)
                    {mine = "text/*"; use = "edit"; }
                ];
            };
		};
	};
	# this is used to create a simlink. Nix saves this after the fetchFromGitHub under some weird folder, but with this you copy it to the normal place where you can look for it.


	home.packages = with pkgs; [
		bat
        adwaita-icon-theme
        zathura
		### NEEDED FOR NEOVIM SETUP ###
		ripgrep      # For Telescope
		fd           # For Telescope
		gcc          # For Treesitter compilation
		nodejs       # For Copilot / some LSPs
		# --- LSPs ---
		# Nix manages these now, NOT Mason!
		lua-language-server
		nil          # Nix LSP
		gopls        # Go LSP 
		bash-language-server       # Bash LSP
		yaml-language-server       # YAML LSP
		pyright	     # Python LSP
		clang-tools  # Cpp LSP
		cmake        # needed addon for Cpp
		rust-analyzer# Rust LSP
        ### END OF NEOVIM SETUP ###

        networkmanagerapplet
        swaynotificationcenter
	];

	### NEOVIM SETUP ###
	programs.neovim = {
		enable = true;

		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		plugins = with pkgs.vimPlugins; [
			telescope-nvim
			harpoon
			copilot-lua
			nvim-tree-lua
			nvim-web-devicons
            catppuccin-nvim

			# LSP and autoconfiguration
			nvim-lspconfig
			nvim-cmp
			cmp-nvim-lua
			cmp-nvim-lsp
            lsp-zero-nvim
			luasnip
			cmp_luasnip

            {
                plugin = nvim-treesitter.withAllGrammars;
                type = "lua";
                config = ''
                    require('nvim-treesitter.configs').setup {
                        highlight = { enable = true },
                        indent = { enable = true },

                        -- Disable all installation commands because Nix handles it
                        ensure_installed = {}, 
                        auto_install = false, 
                        sync_install = false, 
                    }
                '';
            }
		];
	};



	# set the default text editor to neovim
	home.sessionVariables = {
		EDITOR = "nvim";
	};

    # 2. Force GTK to use this theme
    gtk = {
        enable = true;
        iconTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
        };
    };

	# here all dotfile need to be liked!
	xdg.configFile."nvim".source = ./config/nvim;
	xdg.configFile."hypr".source = ./config/hypr;
	xdg.configFile."kitty".source = ./config/kitty;
	xdg.configFile."yazi/flavors/catppuccin-mocha.yazi".source = "${yazi-flavors}/catppuccin-mocha.yazi";
	xdg.configFile."iamb".source = ./config/iamb;
	xdg.configFile."waybar".source = ./config/waybar;
	xdg.configFile."wofi".source = ./config/wofi;
	xdg.configFile."swaync".source = ./config/swaync;
}
