local dap = require('dap')
dap.adapters.python = {
  type = 'executable';
  command = '';
  args = { '-m', 'debugpy.adapter' };
}

local dap = require('dap')
dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = 'Launch file';
  }
}
