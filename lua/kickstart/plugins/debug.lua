-- debug.lua

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-telescope/telescope-dap.nvim',
    'mfussenegger/nvim-dap-python',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    local widgets = require 'dap.ui.widgets'
    local nvim_tree_api = require 'nvim-tree.api'

    local function close_dap_and_ui()
      dap.close()
      dapui.close()
      nvim_tree_api.tree.open()
      vim.schedule(function()
        vim.cmd 'wincmd l'
      end)
    end

    local function start_dap_and_close_tree()
      local ok, err = pcall(function()
        vim.cmd 'source .nvim.lua'
      end)

      if not ok then
        vim.notify('loading .nvim.lua fail ' .. err, vim.log.levels.ERROR)
        return
      end

      dap.continue()
      nvim_tree_api.tree.close()
    end

    return {
      { '<leader>ds', start_dap_and_close_tree, desc = 'Debug: Start/Continue' },
      { '<leader>de', close_dap_and_ui },
      { '<leader>dr', dap.repl.open, desc = 'Open repl' },
      { '<leader>j', dap.step_over, desc = 'Debug: Step Over' },
      { '<leader>l', dap.step_into, desc = 'Debug: Step Into' },
      { '<leader>k', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>dbc', dap.clear_breakpoints, desc = 'Debug: Clear Toggle Breakpoint' },
      { '<leader>dh', widgets.hover, mode = { 'n', 'v' } },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
      },
    }

    dapui.setup {
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          disconnect = '',
          pause = '',
          play = '',
          run_last = '',
          step_back = '',
          step_into = '',
          step_out = '',
          step_over = '',
          terminate = '',
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = '',
        current_frame = '',
        expanded = '',
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 1.0 },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = {
            { id = 'repl', size = 0.8 },
          },
          position = 'bottom',
          size = 15,
        },
      },
      mappings = {
        edit = 'e',
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        repl = 'r',
        toggle = 't',
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    }

    -- ✅ 根据 launch / attach 模式，选择性打开 dapui 的 layout
    dap.listeners.after.event_initialized['dapui_config'] = function(session)
      local dap_config = session.config or {}
      local dap_type = dap_config.request or 'launch'

      if dap_type == 'attach' then
        -- 只打开 layout 1（例如 scopes），不打开 repl
        dapui.open { reset = true, layout = 1 }
      else
        -- 默认 launch 模式，打开所有 layout（包括 repl）
        dapui.open()
      end
    end

    -- 如果你还希望自动关闭 UI，可自行解开这些注释：
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
