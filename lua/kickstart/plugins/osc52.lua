return {
  'ojroques/nvim-osc52',
  config = function()
    require('osc52').setup {
      max_length = 0, -- 不限制剪贴板长度
      silent = false, -- 操作后显示复制提示
      trim = false, -- 不自动去除行尾空格
    }

    -- 自动在复制时触发 osc52
    local function copy()
      if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
        require('osc52').copy_register ''
      end
    end
    vim.api.nvim_create_autocmd('TextYankPost', { callback = copy })
  end,
}
