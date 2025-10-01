package main

import (

	"github.com/neovim/go-client/nvim"
)

func SetNvimOption(v *nvim.Nvim, key string, value any) error {
		inf, err := v.OptionInfo(key)
		if err != nil {
			log.Print(err)
			return err
		}

		if inf.Scope == "win" {
			err := v.SetWindowOption(nvim.Window(0), key, value)
			if err != nil {
				log.Errorf("Error setting opt: %v", err)
				return err
			}
		} else if inf.Scope == "buf" {
			err := v.SetBufferOption(nvim.Buffer(0), key, value)
			if err != nil {
				log.Errorf("Error setting opt: %v", err)
				return err
			}
		}
		err = v.SetOption(key, value)
		if err != nil {
			log.Errorf("Error setting opt: %v", err)
			return err
		}
	return nil
}
