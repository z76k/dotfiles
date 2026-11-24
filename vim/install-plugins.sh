#!/bin/sh
d=~/.vim/pack/plugins/start
mkdir -p "$d" ~/.vim/files/backup ~/.vim/files/swap ~/.vim/files/undo ~/.vim/files/info
for r in morhetz/gruvbox junegunn/fzf.vim tpope/vim-commentary tpope/vim-surround justinmk/vim-sneak tpope/vim-repeat mattn/emmet-vim tpope/vim-vinegar mbbill/undotree tpope/vim-sleuth tpope/vim-unimpaired airblade/vim-gitgutter vimwiki/vimwiki andymass/vim-matchup fatih/vim-go wellle/targets.vim; do
  [ -d "$d/${r#*/}" ] || git clone "https://github.com/$r" "$d/${r#*/}"
done
