local M = {}

M.copy_file_here = function(filepath)
  local outfolder = vim.fn.getcwd()
  vim.ui.input({ prompt = "enter filename" }, function(input)
    local out = vim.system({ "cp", filepath, outfolder .. "/" .. input }, { text = true }):wait()
    if out.code ~= 0 then
      vim.print(out.stderr)
      vim.print(out.stdout)
      return
    end

    vim.print(("Created file %s/%s"):format(outfolder, input))
  end)
end

M.extract_page = function(pdfpath)
  vim.print("getting page from ".. pdfpath)
  vim.ui.input({ prompt = "enter pagenumber (or nothing for whole file)" }, function(pagenum)
    if pagenum == "" then
      M.copy_file_here(pdfpath)
    end
    local tmpcutpath = os.tmpname()
    local out = vim.system({ "pdfseparate", "-f", pagenum, "-l", pagenum, pdfpath, tmpcutpath }, { text = true }):wait()
    if out.code ~= 0 then
      vim.print(out.stderr)
      vim.print(out.stdout)
      return
    end
--    M.copy_file_here(tmpcutpath)
  end)
end

M.download = function(item)
  vim.print("download")
  vim.print(item)

  local tmpdownpath = os.tmpname()
  local out = vim
    .system({ "curl", "--silent", "-o", tmpdownpath, ("http://10.11.99.1/download/%s/pdf"):format(item.ID) }, { text = true })
    :wait()
  if out.code ~= 0 then
    vim.print(out.stderr)
    vim.print(out.stdout)
    return
  end
  M.extract_page(tmpdownpath)
end

M.select_file = function(resultlist)
  vim.ui.select(resultlist, {
    format_item = function(item)
      return item.VissibleName
    end,
  }, function(item, idx)
    if not item then
      return
    end
    if item.Type == "DocumentType" then
      M.download(item)
    else
      M.list(item.ID)
    end
  end)
end

M.list = function(root)
  if not root then
    root = ""
  end
  local curlsysout = vim.system({ "curl", "--silent", "http://10.11.99.1/documents/" .. root }, { text = true }):wait()

  local result = vim.json.decode(curlsysout.stdout)
  M.select_file(result)
end

M.list()

--return M
