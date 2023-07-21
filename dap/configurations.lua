local lldb = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      local path
      vim.ui.input(
        { prompt = "Path to executable: ", default = vim.loop.cwd() .. "/build/" },
        function(input) path = input end
      )
      vim.cmd [[redraw]]
      return path
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
return {
  c = { lldb },
  cpp = { lldb },
  rust = { lldb },
}
