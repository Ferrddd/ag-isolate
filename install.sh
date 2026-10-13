#!/bin/bash

git submodule update

if ! command -v podman >> /dev/null; then
    if command -v apt; then
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

mkdir -p ~/.local/bin ~/.config/antigravity-docker
cat << 'EOF' > ~/.local/bin/agy-c
#!/bin/bash
set -e

IMAGE_NAME="agy-box"

INTERACTIVE_FLAGS=""
if [ -t 0 ] && [ -t 1 ]; then
    INTERACTIVE_FLAGS="-it"
fi

exec podman run $INTERACTIVE_FLAGS --rm \
    -v agy-gemini-data:/root/.gemini:Z \
    -v agy-config-data:/root/.config/antigravity:Z \
    -v "${PWD}:/workspace:Z" \
    -w /workspace \
    "${IMAGE_NAME}" "$@"
EOF

chmod +x ~/.local/bin/agy-c