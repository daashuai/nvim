local dap = require 'dap'

-- 从环境变量读取 DEBUG_PORT
function read_debug_port()
  -- 使用 Neovim 内置函数获取环境变量
  local port_str = vim.fn.getenv 'DEBUG_PORT'
  print(port_str)
  if not port_str or port_str == '' then
    vim.notify('⚠️ DEBUG_PORT environment variable not set', vim.log.levels.WARN)
    return nil
  end

  local port = tonumber(port_str)
  print(port)
  if not port then
    vim.notify('⚠️ Invalid value for DEBUG_PORT environment variable', vim.log.levels.WARN)
    return nil
  end

  return port
end

-- 适配器：根据请求类型动态返回 attach 或 launch 的配置
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    cb {
      type = 'server',
      host = '127.0.0.1',
      port = 5678,
    }
  else -- launch 模式
    cb {
      type = 'executable',
      command = 'python',
      args = { '-m', 'debugpy.adapter' },
    }
  end
end
-- 自动计算当前文件的模块路径（相对于项目根目录）
function get_module_path()
  -- 1. 获取当前文件的绝对路径
  local file_path = vim.fn.expand '%:p' -- 例如: /project/spec8k/spec8k/generate_dataset.py
  -- 2. 查找项目根目录（这里以 .git 目录作为标志，可替换为 pyproject.toml 等）
  local project_root = vim.fn.finddir('.git/..', file_path .. ';')
  if project_root == '' then
    -- 若找不到 .git，默认使用当前工作目录
    project_root = vim.fn.getcwd()
  end
  -- 3. 计算文件相对于项目根目录的相对路径
  local rel_path = vim.fn.fnamemodify(file_path, ':.' .. project_root .. ':') -- 例如: spec8k/spec8k/generate_dataset.py
  -- 4. 转换为模块路径（去掉 .py 扩展名，替换 / 为 .）
  local module_path = rel_path:gsub('.py$', ''):gsub('/', '.') -- 例如: spec8k.spec8k.generate_dataset
  print(module_path)
  return module_path
end

-- 合并后的配置：包含原有的 launch 配置、带参数的 launch 配置，以及 attach 配置
dap.configurations.python = {
  -- 原配置中的基础 launch
  {
    type = 'python',
    request = 'launch',
    name = 'Launch',
    cwd = '${workspaceFolder}',
    module = get_module_path(),
    -- module = 'spec8k.spec8k.generate_dataset',
  },
  -- 原配置中带参数的 launch
  {
    type = 'python',
    request = 'launch',
    name = 'Launch with Args',
    program = '${file}',
    args = { '--model_name', 'trans' },
  },
  -- 新配置中的 attach
  {
    type = 'python',
    request = 'attach',
    name = 'Attach to Python Process',
    connect = {
      host = '127.0.0.1',
      port = 5678,
    },
    mode = 'remote',
    justMyCode = false,
    pathMappings = {
      {
        localRoot = vim.fn.getcwd(),
        remoteRoot = vim.fn.getcwd(),
      },
    },
  },
}
