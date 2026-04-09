---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        disableOrganizeImports = true,
        autoSearchPaths = true,
        typeCheckingMode = 'strict',
        useLibraryCodeForTypes = true,
      },
    },
  },
}
