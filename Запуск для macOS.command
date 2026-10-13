#!/bin/bash
# Пранк "Фейковый вирус" — запуск для macOS (двойной клик в Finder)
# Ничего настоящего не удаляет. Esc / Cmd+Ctrl+F — выход из полноэкранного.
cd "$(dirname "$0")"
if [ -d "/Applications/Microsoft Edge.app" ]; then
  open -a "Microsoft Edge" --args --kiosk "file://$PWD/index.html"
elif [ -d "/Applications/Google Chrome.app" ]; then
  open -a "Google Chrome" --args --kiosk "file://$PWD/index.html"
else
  open -a Safari "file://$PWD/index.html"
  echo "Открылось в Safari. Нажми Cmd+Ctrl+F для полноэкранного режима."
  sleep 3
fi
