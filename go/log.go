package main

import (
	"fmt"

	"github.com/neovim/go-client/nvim"
)

type nvimLogger struct {
	v *nvim.Nvim
}

func NewNvimLogger(v *nvim.Nvim) *nvimLogger {
	return &nvimLogger{v: v}
}


func (log *nvimLogger) Print(v ...any){
	log.write(fmt.Sprint(v...), nvim.LogInfoLevel)
}
func (log *nvimLogger) Printf(format string, v ...any){
	log.write(fmt.Sprintf(format, v...), nvim.LogInfoLevel)
}


func (log *nvimLogger) Debug(v ...any){
	log.write(fmt.Sprint(v...), nvim.LogDebugLevel)
}
func (log *nvimLogger) Debugf(format string, v ...any){
	log.write(fmt.Sprintf(format, v...), nvim.LogDebugLevel)
}


func (log *nvimLogger) Info(v ...any){
	log.write(fmt.Sprint(v...), nvim.LogInfoLevel)
}
func (log *nvimLogger) Infof(format string, v ...any){
	log.write(fmt.Sprintf(format, v...), nvim.LogInfoLevel)
}


func (log *nvimLogger) Warn(v ...any){
	log.write(fmt.Sprint(v...), nvim.LogWarnLevel)
}
func (log *nvimLogger) Warnf(format string, v ...any){
	log.write(fmt.Sprintf(format, v...), nvim.LogWarnLevel)
}


func (log *nvimLogger) Error(v ...any){
	log.write(fmt.Sprint(v...), nvim.LogErrorLevel)
}
func (log *nvimLogger) Errorf(format string, v ...any){
	log.write(fmt.Sprintf(format, v...), nvim.LogErrorLevel)
}

func (log *nvimLogger) write(msg string, level nvim.LogLevel) {
	log.v.ExecLua(fmt.Sprintf(`vim.notify("%s", %d)`, msg, level),nil)
//	log.v.Notify(msg, level, nil)
}
