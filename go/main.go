package main

import (
	"fmt"
	"os"

	"github.com/neovim/go-client/nvim"
)

var opts map[string]any = map[string]any{
	"cursorline":     true,
	"expandtab":      true,
	"ignorecase":     true,
	"number":         true,
	"relativenumber": true,
	"scrolloff":      10,
	"shellcmdflag":   "-c",
	"shiftwidth":     2,
	"showcmd":        true,
	"smartcase":      true,
	"tabstop":        2,
	"conceallevel":   0,
	"termguicolors":  true,
	"timeoutlen":     200,
	"updatetime":     200,
	// folding
	"foldcolumn":     "1",
	"foldenable":     true,
	"foldlevel":      99,
	"foldlevelstart": 99,
}

var globalVars map[string]any = map[string]any{
	"root_spec":                  []string{"cwd"},
	"markdown_folding":           1,
	"markdown_recommended_style": 0,
	"disable_autoformat":         true,
	"bullets_enabled_file_types": []string{
		"markdown",
		"text",
		"org",
		"gitcommit",
		"scratch",
	},
	"bullets_outline_levels":              []string{"ROM", "ABC", "num", "abc", "rom", "std-"},
	"lazygit_floating_window_winblend":    1,
	"lazygit_floating_window_use_plenary": 1,
	"netrw_browsex_viewer":                "cd %:h && xdg-open",
}

var log *nvimLogger

func configure(v *nvim.Nvim, args []string) error {
	log.Info("Calling configure")
	for key, value := range opts {
		if err := SetNvimOption(v, key, value); err != nil {
			log.Errorf("Error setting option %s: %v", key, err)
			return err
		}
	}

	for key, value := range globalVars {
		if err := v.SetVar(key, value); err != nil {
			log.Errorf("Error setting var %s: %v", key, err)
			return err
		}
	}

	return nil
}

func main() {
	// Turn off timestamps in output.
	// Direct writes by the application to stdout garble the RPC stream.
	// Redirect the application's direct use of stdout to stderr.
	stdout := os.Stdout
	os.Stdout = os.Stderr

	// Create a client connected to stdio. Configure the client to use the
	// standard log package for logging.
	v, err := nvim.New(os.Stdin, stdout, stdout, log.Printf)
	if err != nil {
		fmt.Printf("Error initializing vim connection: %v\n", err)
		os.Exit(1)
	}
	log = NewNvimLogger(v)

	// Register function with the client.
	v.RegisterHandler("configure", configure)

	// Run the RPC message loop. The Serve function returns when
	// nvim closes.
	if err := v.Serve(); err != nil {
		fmt.Printf("Error closing conn: %v\n", err)
		os.Exit(1)
	}
}
