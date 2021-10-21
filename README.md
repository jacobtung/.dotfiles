## Jacob's Config Files

> These files are organized in GNU stow needed structure, so I can easily deploy these config files just use stow command.

### Deploy Method

```bash
cd ~
git clone https://github.com/jacobtung/.dotfiles.git
cd .dotfiles
stow -nvt ~ *            //test what will be done but not do it right now
stow -vt ~ WhatYouWant   //remove `n` flag and do what you want to do
```
### start using branch feature
Desktop Use
Server Use
