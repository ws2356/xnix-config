" 引用普通 Neovim 已安装的插件
set runtimepath^=~/.vim/plugged/neoscroll.nvim

" 禁止 nvimpager 默认快捷键映射覆盖插件配置
lua nvimpager.maps = false

lua << EOF
require('neoscroll').setup({
  mappings = {
    '<C-f>', '<C-b>',
    '<C-d>', '<C-u>',
  },
  easing = 'cubic',
  duration_multiplier = 1.6,
})
EOF
