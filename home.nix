{ config, pkgs, ... }:
let
    yazi-flavors = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "flavors";
        rev = "master";
        sha256 = "sha256-erZI0H5TxqFu2P917juL5PIB3LC0oJGKPcB1VibJDqo=";
    };
in
{
	home.username = "fin";
	home.homeDirectory = "/home/fin";
	home.stateVersion = "25.05";

    wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang"; # Silences the warning, keeps your config working

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
		#profileExtra = ''
		#	if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #       exec start-hyprland
		#   fi
		#'';
#		initExtra = ''
#			export PS1='\[\e[38;5;208m\]\u\[\e[0m\] in \[\e[38;5;53m\]\w\[\e[0m\] \[\e[38;5;123m\]\\$\[\e[0m\] '
#		'';
	};

	# this is used to create a simlink. Nix saves this after the fetchFromGitHub under some weird folder, but with this you copy it to the normal place where you can look for it.

    programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        # We leave settings out! Yazi will now read from your ./config/yazi folder.
    };
    programs.starship = {
        enable = true;
    };

	home.packages = with pkgs; [
		bat
        adwaita-icon-theme
        zathura
        swaybg             # Wallpaper utility for Niri
        xwayland-satellite # Required for X11 apps in Niri

        # --- Custom Godot 4.6 Wayland Wrapper ---
        (symlinkJoin {
            name = "godot-4.6-wayland";
            paths = [ godotPackages_4_6.godot ]; 
            nativeBuildInputs = [ makeWrapper ];
            postBuild = ''
                wrapProgram $out/bin/godot4 \
                    --add-flags "--display-driver wayland"
            '';
        })

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
        brave
	];

	### NEOVIM SETUP ###
	programs.neovim = {
		enable = true;
        withRuby = false;    # Silences the warning, saves space
        withPython3 = false; # Silences the warning, saves space

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
            snacks-nvim

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
        XCURSOR_SIZE = "24";
	};

    # 2. Force GTK to use this theme
    gtk = {
        enable = true;
        iconTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
        };
    };

    xdg.mimeApps = {
        enable = true;
    
        defaultApplications = {
          # --- Default Browser ---
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";

          # --- Default PDF Reader ---
          "application/pdf" = "zathura.desktop"; 
        };
      };

	# here all dotfile need to be liked!
	xdg.configFile."nvim".source = ./config/nvim;
	xdg.configFile."hypr".source = ./config/hypr;
	xdg.configFile."kitty".source = ./config/kitty;
	xdg.configFile."iamb".source = ./config/iamb;
	xdg.configFile."waybar".source = ./config/waybar;
	xdg.configFile."wofi".source = ./config/wofi;
	xdg.configFile."swaync".source = ./config/swaync;
    xdg.configFile."starship.toml".source = ./config/starship/starship.toml;
    xdg.configFile."niri".source = ./config/niri;


    # YAZI MAPPING
    # 1. Map your local folder recursively
    xdg.configFile."yazi" = {
        source = ./config/yazi;
        recursive = true; 
    };
    
    # 2. Inject the Catppuccin flavor into that mapped folder
    xdg.configFile."yazi/flavors/catppuccin-mocha.yazi".source = "${yazi-flavors}/catppuccin-mocha.yazi";


    # Cursor configuration
    home.pointerCursor = {
      name = "BreezeX-Dark"; # Change to BreezeX-Light or BreezeX-Black if you prefer
      size = 24;             # Adjust to your preferred size
      gtk.enable = true;
      x11.enable = true;
  
      package = pkgs.stdenv.mkDerivation {
        pname = "breezex-cursor";
        version = "2.0.1";

        src = pkgs.fetchzip {
          url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Dark.tar.xz";
          # We use a fake hash here on purpose! 
          hash = "sha256-HqjO/ogAd/dsrO5WHIilUQaq1CbiU48lEaoefcUmmBM="; 
          
        };

        installPhase = ''
          mkdir -p $out/share/icons/BreezeX-Dark
          cp -R . $out/share/icons/BreezeX-Dark/
        '';
      };
    };
}
