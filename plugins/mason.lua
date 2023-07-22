---@diagnostic disable, 211: 211, 211: unused-local, 211
-- customize mason plugins
--  vim.fn.split(argument_string, " ", true)
-- support passing args
local find_next_start = function(str, cur_idx)
  while cur_idx <= #str and str:sub(cur_idx, cur_idx) == " " do
    cur_idx = cur_idx + 1
  end
  return cur_idx
end

local str2argtable = function(str)
  -- trim spaces
  str = string.gsub(str, "^%s*(.-)%s*$", "%1")
  local arg_list = {}

  local start = 1
  local i = 1
  local quote_refs_cnt = 0
  while i <= #str do
    local c = str:sub(i, i)
    if c == '"' then
      quote_refs_cnt = quote_refs_cnt + 1
      start = i
      i = i + 1
      -- find next quote
      while i <= #str and str:sub(i, i) ~= '"' do
        i = i + 1
      end
      if i <= #str then
        quote_refs_cnt = quote_refs_cnt - 1
        arg_list[#arg_list + 1] = str:sub(start, i)
        start = find_next_start(str, i + 1)
        i = start
      end
      -- find next start
    elseif c == " " then
      arg_list[#arg_list + 1] = str:sub(start, i - 1)
      start = find_next_start(str, i + 1)
      i = start
    else
      i = i + 1
    end
  end

  -- add last arg if possiable
  if start ~= i and quote_refs_cnt == 0 then arg_list[#arg_list + 1] = str:sub(start, i) end
  return arg_list
end

return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "lua_ls",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "prettier",
        -- "stylua",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        -- "python",
      })
    end,
    config = function()
      local CODELLDB_DIR = require("mason-registry").get_package("codelldb"):get_install_path()
        .. "/extension/adapter/codelldb"
      local dap = require "dap"
      dap.adapters.lldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = CODELLDB_DIR,
          args = { "--port", "${port}" },
        },
      }

      local CPPDBG_DIR = require("mason-registry").get_package("cpptools"):get_install_path()
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = CPPDBG_DIR .. "/extension/debugAdapters/bin/OpenDebugAD7",
      }

      local cppdbg_launch = {
        name = "Launch file(cppdbg)",
        type = "cppdbg",
        request = "launch",
        miDebuggerPath = "/usr/local/bin/lldb-mi",
        MIMode = "lldb",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        args = function()
          local input = vim.fn.input "Input args: "
          return str2argtable(input)
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
        setupCommands = {
          {
            description = "enable pretty printing",
            text = "-enable-pretty-printing",
            ignoreFailures = false,
          },
        },
      }
      -- local cppdbg_attach_p = {
      --   name = "Attach process",
      --   type = "cppdbg",
      --   request = "attach",
      --   processId = require("dap.utils").pick_process,
      --   program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
      --   cwd = "${workspaceFolder}",
      --   setupCommands = {
      --     {
      --       description = "enable pretty printing",
      --       text = "-enable-pretty-printing",
      --       ignoreFailures = false,
      --     },
      --   },
      -- }
      local attach_s = {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "lldb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/local/bin/lldb-mi",
        cwd = "${workspaceFolder}",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        setupCommands = {
          {
            text = "-enable-prett-printing",
            description = "enable pretty printing",
            ignoreFailures = false,
          },
        },
      }

      local lldb = {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        ---@diagnostic disable-next-line: redundant-parameter
        program = function() return vim.fn.input("executable: ", vim.fn.getcwd() .. "/build/", "file") end,
        args = function()
          local input = vim.fn.input "Input args: "
          return str2argtable(input)
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      }
      dap.configurations.c = { lldb, attach_s, cppdbg_launch }
      dap.configurations.cpp = { lldb, attach_s, cppdbg_launch }
      dap.configurations.rust = { lldb }
    end,
  },
}
