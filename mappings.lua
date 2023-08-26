-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

function show_documentation()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand "<cword>")
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand "<cword>")
  elseif vim.fn.expand "%:t" == "Cargo.toml" and require("crates").popup_available() then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end
return {
  -- first key is the mode
  n = {
    ["<leader>k"] = { "<cmd>lua show_documentation()<cr>" },
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

    ["<leader>Tn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>Tc"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
    -- a table with the `name` key will register with which-key if it's available
    -- this an easy way to add menu titles in which-key
    ["<leader>T"] = { name = "Tab" },

    ["H"] = { "^" },
    ["L"] = { "$" },
    -- SnipRun
    ["<leader>rr"] = { "<cmd>SnipRun<CR>" },
    ["<leader>rc"] = { "<cmd>SnipClose<cr>", desc = "Clearing" },
    ["<leader>rs"] = { "<cmd>SnipReset<cr>", desc = "Stopping" },
    -- swap line
    ["<M-j>"] = { ":m .+1<CR>==" },
    ["<M-k>"] = { ":m .-2<CR>==" },
    ["<leader>Q"] = { "<cmd>confirm qa<cr>", desc = "Quit All" },
  },
  v = {
    ["H"] = { "^" },
    ["L"] = { "$" },
    ["<leader>rr"] = { "<cmd>SnipRun<CR>" },
  },
  x = {
    ["<M-j>"] = { ":m '>+1<CR>gv-gv" },
    ["<M-k>"] = { ":m '<lt>-2<CR>gv-gv" },
  },
  i = {
    ["<M-j>"] = { "<Esc>:m .+1<CR>==gi" },
    ["<M-k>"] = { "<Esc>:m .-2<CR>==gi" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
