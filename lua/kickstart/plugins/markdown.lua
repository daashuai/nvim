return {

  -- 2. 终端预览
  {
    'ellisonleao/glow.nvim',
    -- 去掉 cmd = "Glow" 后，用快捷键触发加载
    keys = { -- 新增这行：快捷键按下时自动加载插件
      { '<leader>gg', '<cmd>Glow<CR>', desc = '终端预览 Markdown (Glow)' },
    },
    config = function()
      require('glow').setup {
        border = 'rounded',
        style = 'dark',
        -- pager = false,
        width = 400,
        command_args = { '--wrap', 'never' },
      }
      -- 这里可以保留快捷键定义（也可以删掉，因为上面 keys 里已经定义了）
      -- vim.keymap.set("n", "<leader>gg", "<cmd>Glow<CR>", { desc = "终端预览 Markdown (Glow)" })
    end,
  },

  -- -- 2. 实时预览（浏览器预览，支持 MathJax、代码高亮）
  -- {
  --   'iamcco/markdown-preview.nvim',
  --   cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  --   ft = 'markdown', -- 只在 markdown 中加载
  --   build = function()
  --     vim.fn['mkdp#util#install']() -- 自动安装依赖
  --   end,
  --   config = function()
  --     vim.g.mkdp_auto_start = 0 -- 不自动启动预览
  --     vim.g.mkdp_auto_close = 1 -- 关闭文件时自动关闭预览
  --     vim.g.mkdp_refresh_slow = 0 -- 快速刷新
  --     vim.g.mkdp_theme = 'light' -- 预览主题
  --     -- 限定在 markdown 缓冲区生效
  --     vim.keymap.set('n', '<leader>mv', '<cmd>MarkdownPreviewToggle<CR>', {
  --       desc = 'Markdown 预览切换',
  --       buffer = true, -- 只在当前缓冲区（markdown文件）生效
  --     })
  --   end,
  -- },

  -- 4. 内置窗口预览 (可选，与浏览器预览二选一或都保留)
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    keys = { -- 新增这行：快捷键按下时自动加载插件
      { '<leader>mv', '<cmd>PeekOpen<CR>', desc = '预览 Markdown (Peek)' },
      { '<leader>mc', '<cmd>PeekClose<CR>', desc = '关闭 Markdown (Peek)' },
    },
    config = function()
      require('peek').setup {
        vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {}),
        vim.api.nvim_create_user_command('PeekClose', require('peek').close, {}),
        auto_load = false, -- 不自动加载
        close_on_bdelete = true,
        syntax = true,
        theme = 'dark',
        update_on_change = true,
        app = 'browser', -- 预览类型: webview / browser
        filetype = { 'markdown' },
        throttle_at = 200000,
        throttle_time = 'auto',
      }
      -- 快捷键
      -- vim.keymap.set('n', '<leader>mv', '<cmd>PeekOpen<CR>', {
      --   buffer = true,
      --   desc = 'Open Peek Preview',
      -- })
      -- vim.keymap.set('n', '<leader>mc', '<cmd>PeekClose<CR>', {
      --   buffer = true,
      --   desc = 'Close Peek Preview',
      -- })
    end,
  },
  {
    'dhruvasagar/vim-table-mode',
    ft = 'markdown', -- 关键：只在 markdown 中加载插件
    config = function()
      -- 限定在 markdown 中生效
      vim.keymap.set('n', '<leader>mt', '<cmd>TableModeToggle<CR>', {
        desc = '表格模式切换',
        buffer = true, -- 只在当前 markdown 缓冲区生效
      })
      vim.g.table_mode_corner = '|' -- 表格角落符号
      vim.g.table_mode_disable_mappings = 0 -- 启用默认映射（如 | 自动对齐）
    end,
  },
}
