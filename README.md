#  taskfile.nvim

A simple Neovim plugin for executing tasks from a [Taskfile](https://taskfile.dev).

![demo](demo.gif)

## Installing

Prerequisites:
    -  `task` binary available on your path ([install guide](https://taskfile.dev/docs/installation))

Install taskfile.nvim with the plugin manager of your choice:

- [vim-plug](https://github.com/junegunn/vim-plug)
```vimscript
Plug 'cspengl/taskfile.nvim'
lua << EOF
require('taskfile').setup()
EOF
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use {'cspengl/taskfile.nvim', config= function() require('taskfile').setup() end}
```

- [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{'cspengl/taskfile.nvim', config=true}
```

## Usage

#### Execute task
```
:Task <name-of-task>
```
#### Select task to run
```
:Task
```

The terminal window which will be opened to print the output of the task can 
be closed using `q` or `<Esc>`
