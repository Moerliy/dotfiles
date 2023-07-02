#!/bin/bash
yay -Syu --noconfirm --needed emacs-nativecomp hunspell hunspell-en_us libvterm languagetool nodejs npm yarn lldb gdb unzip docker docker-compose docker-machine editorconfig-checker sqlite ripgrep git wl-clipboard clang ccls go gopls jdk11-openjdk texlive-most gnuplot marked python pyright rubocop rustup mpd mpc maim scrot gnome-screenshot rust-analyzer tidy stylelint python-pipenv curl gcc make ncurses man-pages xdg-utils dockerfile-language-server wordnet-cli cmake-language-server proselint ktlint shellcheck-bin js-beautify ttf-jetbrains-mono

# pip installs
pip install pytest nose black pyflakes isort python-language-server grib

# rustup component
rustup default stable
rustup component add clippy-preview rustfmt-preview

# cargo installs
cargo install cargo-check

# gomistalls
go install github.com/x-motemen/gore/cmd/gore@latest
go install golang.org/x/tools/gopls@latest
go install github.com/stamblerre/gocode@latest
go install golang.org/x/tools/cmd/godoc@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/cmd/gorename@latest
go install golang.org/x/tools/cmd/guru@latest
go install github.com/cweill/gotests/gotests@latest
go install github.com/fatih/gomodifytags@latest

# ghcup installs
#if ! command -v ghcup &> $HOME/.ghcup/bin/ghcup; then
#    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
#fi
#ghcup install ghc latest
#ghcup install cabal latest
#ghcup install hls latest
