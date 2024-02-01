return {
  root_dir = function() return vim.fn.getcwd() end,
  settings = {
    exportPdf = "onType", -- Choose onType, onSave or never.
    -- serverPath = "" -- Normally, there is no need to uncomment it.
  },
}
