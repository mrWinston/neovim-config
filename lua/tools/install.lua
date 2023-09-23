local install = {}

local runInZsh = function(cmd)
  return vim
    .system({ "zsh", "-c", cmd }, {
      text = true,
    })
    :wait()
end

install.withAsdf = function(tool)
  if not tool.exe or not tool.name then
    return
  end
  if vim.fn.executable(tool.exe) == 1 then
    return
  end
  local addPluginOut = runInZsh("asdf plugin-add " .. tool.name)
  if addPluginOut.code == 2 then -- means, that the plugin is already added
    return
  end
  if addPluginOut.code ~= 0 then
    vim.print("Error installing " .. tool.name .. " with asdf while adding plugin:")
    vim.print(addPluginOut.stdout)
    vim.print(addPluginOut.stderr)
    return
  end

  local installPluginOut = runInZsh(string.format("asdf install %s latest", tool.name))
  if installPluginOut.code ~= 0 then
    vim.print(string.format("Error installing %s with asdf:", tool.name))
    vim.print(installPluginOut.stdout)
    vim.print(installPluginOut.stderr)
    return
  end

  local setGlobalOut = runInZsh(string.format("asdf global %s latest", tool.name))
  if setGlobalOut.code ~= 0 then
    vim.print(string.format("Error setting %s as global with asdf:", tool.name))
    vim.print(setGlobalOut.stdout)
    vim.print(setGlobalOut.stderr)
  end
end

install.withCargo = function(tool)
  if not tool.exe or not tool.name then
    return
  end
  if vim.fn.executable(tool.exe) == 1 then
    return
  end

  local installPluginOut = runInZsh(string.format("cargo install %s && asdf reshim rust", tool.name))
  if installPluginOut.code ~= 0 then
    vim.print(string.format("Error installing %s cargo:", tool.name))
    vim.print(installPluginOut.stdout)
    vim.print(installPluginOut.stderr)
  end
end

install.withPip = function(tool)
  if not tool.exe or not tool.name then
    return
  end
  if vim.fn.executable(tool.exe) == 1 then
    return
  end

  local installPluginOut = runInZsh(string.format("pip install '%s' --user", tool.name))
  if installPluginOut.code ~= 0 then
    vim.print(string.format("Error installing %s pip:", tool.name))
    vim.print(installPluginOut.stdout)
    vim.print(installPluginOut.stderr)
  end
end

install.withYarn = function(tool)
  if not tool.exe or not tool.name then
    return
  end
  if vim.fn.executable(tool.exe) == 1 then
    return
  end

  local installPluginOut = runInZsh(string.format("yarn global add %s", tool.name))
  if installPluginOut.code ~= 0 then
    vim.print(string.format("Error installing %s yarn:", tool.name))
    vim.print(installPluginOut.stdout)
    vim.print(installPluginOut.stderr)
  end
end

install.withDownload = function(tool)
  if not tool.exe or not tool.name or not tool.url then
    vim.print("Required params for tool not defined in 'withDownload'")
    return
  end
  if vim.fn.executable(tool.exe) == 1 then
    return
  end

  local installPluginOut =
    runInZsh(string.format("curl -L -o ~/.local/bin/%s %s && chmod +x ~/.local/bin/%s", tool.exe, tool.url, tool.exe))
  if installPluginOut.code ~= 0 then
    vim.print(string.format("Error installing %s with download:", tool.name))
    vim.print(installPluginOut.stdout)
    vim.print(installPluginOut.stderr)
  end
end

install.withGo = function(tool)
  if not tool.exe or not tool.name or not tool.url then
    vim.print("Required params for tool not defined in 'withGo'")
    return
  end
  if vim.fn.executable(tool.exe) == 1 then
    return
  end

  local installPluginOut = runInZsh(string.format("go install %s", tool.url))
  if installPluginOut.code ~= 0 then
    vim.print(string.format("Error installing %s with go:", tool.name))
    vim.print(installPluginOut.stdout)
    vim.print(installPluginOut.stderr)
  end
end

install.tools = {
  {
    name = "black",
    exe = "black",
    install = install.withPip,
  },
  {
    name = "shellcheck",
    exe = "shellcheck",
    install = install.withAsdf,
  },
  {
    name = "bash-language-server",
    exe = "bash-language-server",
    install = install.withYarn,
  },
  {
    name = "marksman",
    exe = "marksman",
    url = "https://github.com/artempyanykh/marksman/releases/download/2023-07-25/marksman-linux-x64",
    install = install.withDownload,
  },
  {
    name = "gopls",
    exe = "gopls",
    url = "golang.org/x/tools/gopls@latest",
    install = install.withGo,
  },
  {
    name = "golines",
    exe = "golines",
    url = "github.com/segmentio/golines@latest",
    install = install.withGo,
  },
  {
    name = "yaml-language-server",
    exe = "yaml-language-server",
    install = install.withYarn,
  },
  {
    name = "typescript",
    exe = "tsc",
    install = install.withYarn,
  },
  {
    name = "typescript-language-server",
    exe = "typescript-language-server",
    install = install.withYarn,
  },
  {
    name = "jedi-language-server",
    exe = "jedi-language-server",
    install = install.withPip,
  },
  {
    name = "python-lsp-server[all]",
    exe = "pylsp",
    install = install.withPip,
  },
  {
    name = "stylua",
    exe = "stylua",
    install = install.withAsdf,
  },
  {
    name = "beautysh",
    exe = "beautysh",
    install = install.withPip,
  },
  {
    name = "yamlfix",
    exe = "yamlfix",
    install = install.withPip,
  },
  {
    name = "shellharden",
    exe = "shellharden",
    install = install.withCargo,
  },
  {
    name = "terraform",
    exe = "terraform",
    install = install.withAsdf,
  },
  {
    name = "shfmt",
    exe = "shfmt",
    url = "mvdan.cc/sh/v3/cmd/shfmt@latest",
    install = install.withGo,
  },
  {
    name = "prettier",
    exe = "prettier",
    install = install.withYarn,
  },
  {
    name = "deno",
    exe = "deno",
    install = install.withAsdf,
  },
  {
    name = "remark-language-server",
    exe = "remark-language-server",
    install = install.withYarn,
  },
  {
    name = "fd",
    exe = "fd",
    install = install.withAsdf,
  },
}

install.installAll = function()
  for _, tool in pairs(install.tools) do
    if not tool.install then
      vim.print(string.format("tool %s is missing an install function", tool.name))
      goto continue
    end
    tool.install(tool)
    ::continue::
  end
end

return install
