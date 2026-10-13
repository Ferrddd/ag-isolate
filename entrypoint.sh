#!/bin/bash
set -e

# Активация обхода при старте контейнера
if [ -d "/agy/ag-bypass" ]; then
    echo "[*] Активация ag-bypass..."
    cd /agy/ag-bypass

    # Защита от ошибки ядра "Device or resource busy":
    # В Docker /etc/hosts примонтирован ядром, поэтому os.replace падает.
    if [ -f "core/hosts.py" ]; then
        sed -i 's/os.replace(temp_path, hosts_path)/shutil.copyfile(temp_path, hosts_path); os.remove(temp_path)/g' core/hosts.py 2>/dev/null || true
    fi

    ./ag on || true
    cd /workspace
fi

# Передача управления команде (по умолчанию /bin/bash)
exec "$@"