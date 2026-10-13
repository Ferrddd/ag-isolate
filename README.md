# Установка:

```bash
git clone --recurse-submodules git@github.com:Ferrddd/ag-isolate.git
cd ag-isolate

./install.sh
```

# Запуск
```bash
agy-c
```

> [!WARNING]
> Важно: при запуске в контейнер пробрасывается текущая дирректория, поэтому запуск из корня (/) или домашней дирректории(~) дает значительный доступ агенту и он может повредить хост!