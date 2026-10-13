#!/bin/bash
set -e

git submodule update --init --recursive

if ! command -v podman >> /dev/null; then
    read -r -p "podman не установлен. Установить? [Y/n]" answer
    case "${answer:-Y}" in
    [Nn]*)
        echo "Установка прервана"
        exit 1
        ;;
    [Yy]*)
        ;;
    *)
        echo "Нераспознанный ответ. Установка прервана."
        exit 1
        ;;
    esac

    if command -v apt >> /dev/null; then
        sudo apt update
        sudo apt install podman -y
    
    elif command -v brew >> /dev/null; then
        brew install podman
    
    elif command -v pacman >> /dev/null; then
        sudo pacman -S podman --noconfirm
    
    else
        echo "Podman не установлен, пакетные менеджеры не найдены"
        echo "Установите Podman"
        exit 1
    fi
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
    if ! podman machine list --format "{{.Name}}" | grep -q "podman-machine-default"; then
        podman machine init
    fi
    podman machine start || true
fi

podman build -t agy-box -f Dockerfile .

mkdir -p ~/.local/bin
cat src/agy-c > ~/.local/bin/agy-c

chmod +x ~/.local/bin/agy-c