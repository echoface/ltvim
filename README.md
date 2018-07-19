# a vim config and script for my workspace

- ycm 配置支持优先使用`compile_commands.json` database 这样有更好的补全体验， 更加节省内存
- 添加asyncrun 脚本， 支持<leader><leader>s 搜索工程目录当前光标所在单词的使用并通过quickfix打开

# Molokai Color Scheme Setting

Copy the file on your .vim/colors folder.

If you prefer the scheme to match the original monokai background color, put this in your .vimrc file:
```
let g:molokai_original = 1
```

There is also an alternative scheme under development for color terminals which attempts to bring the 256 color version as close as possible to the the default (dark) GUI version. To access, add this to your .vimrc:
```
let g:rehash256 = 1
```

