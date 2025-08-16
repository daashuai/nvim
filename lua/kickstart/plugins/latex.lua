return {
  'lervag/vimtex',
  lazy = false, -- 确保插件立即加载
  config = function()
    vim.g.vimtex_compiler_silent = 1 -- 显示编译过程
    vim.g.vimtex_quickfix_mode = 0 -- 开启错误提示
    vim.g.vimtex_view_method = 'general'
    -- 若 nvr 未安装，先注释此行
    -- vim.g.vimtex_compiler_progname = 'nvr'
    vim.g.vimtex_view_general_viewer = 'okular'
    vim.g.vimtex_compiler_latexmk_engines = {
      _ = '-xelatex', -- 强制使用 xelatex
    }
    vim.g.tex_comment_nospell = 1
    vim.g.vimtex_view_general_options = [[--unique file:@pdf#src:@line@tex]]
    -- vim.g.vimtex_view_general_options_latexmk = '--unique'
  end,
  ft = 'tex',
}
