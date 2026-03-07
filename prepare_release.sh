#!/bin/bash
# 1. Очистка старой папки сборки
rm -rf ~/dev/togit/python_build/vosk/*.dll

# 2. Копирование свежих артефактов для упаковки в Wheel
cp ~/dev/togit/artifacts/*.dll ~/dev/togit/python_build/vosk/

# 3. Проверка наличия всех компонентов
ls -1 ~/dev/togit/python_build/vosk/
