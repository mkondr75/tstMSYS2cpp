🏆 Описание

Данный репозиторий содержит «Золотой слой» (патчи и скрипты), необходимый для сборки полностью статического ядра Kaldi и монолитной libvosk.dll в среде MSYS2 UCRT64 (Windows 11). Решение исключает зависимости от libgfortran, libgomp и прочих runtime-библиотек MSYS2.



🛠 Окружение

OS: Windows 11.



Environment: MSYS2 (терминал UCRT64).



Packages: mingw-w64-ucrt-x86\_64-gcc, cmake, make, openblas.



🚀 Пошаговая инструкция (через 6-8 месяцев)

Подготовка исходников:



Скачать чистый Kaldi (рекомендуемый коммит: \[твой текущий]) в папку vscprj/kaldi.



Скачать чистый Vosk-API в папку vscprj/vosk.



Собрать OpenFST 1.7.2 вручную с флагом --disable-shared.



Накат патчей (DNA Transfer):



Скопировать измененные файлы из репозитория поверх чистых исходников:



Bash

\# Из папки gold\_layer (сохраняя структуру)

cp -rf c/msys64/home/maxko/dev/vscprj/kaldi/\* ../vscprj/kaldi/

cp -rf c/msys64/home/maxko/dev/vscprj/vosk/\* ../vscprj/vosk/

Сборка статического ядра Kaldi:



Перейти в kaldi/src.



Запустить ключевой скрипт:



Bash

./build\_kaldi\_a.sh

Результат: В папке kaldi\_arch/ должны появиться 19 файлов .a.



Сборка монолита Vosk:



Перейти в vosk-api/.

Использовать vosk.def для контроля экспорта.

Запустить финальную линковку:

Bash

./build\_voskkaldi\_dll.sh

Результат: libvosk.dll, работающая в обычном cmd.exe.



⚠️ Критические точки (Audit Notes)

OpenFST: Если линковка падает на MappedFile, проверь патч в mapped-file.cc (заглушка деструктора).



Undefined Reference: Если возникают ошибки vtable в nnet3, убедись, что файл vtable-force.cc включен в сборку.



LDFLAGS: Для полной статики обязательно использование -static -static-libgcc -static-libstdc++.







\# MaxWinUCRT: Vosk-Kaldi Static Build for UCRT64



\## Суть метода

Отказ от `kaldi.dll` в пользу 19 статических архивов (`.a`). Это решает проблему `undefined reference` и конфликтов рантайма в Windows 11.



\## Компоненты

\### 1. OpenFST (v1.7.2)

\- \*\*Конфигурация\*\*: `--enable-static --disable-shared --D\_FILE\_OFFSET\_BITS=64`

\- \*\*Важно\*\*: Применен фикс для `MappedFile`, исключающий зависимость от POSIX `mmap`.



\### 2. Kaldi (Static)

\- Сборка выполняется скриптом `scripts/kaldi/build\_kaldi\_a.sh`. 

\- Результат: 19 библиотек в папку `kaldi\_arch/`.

\- Флаг `-Wa,-mbig-obj` обязателен из-за размера объектных файлов nnet3.



\### 3. Vosk-API (Monolith DLL)

\- \*\*Линковка\*\*: Используется `--whole-archive` для принудительного включения всех символов из архивов Kaldi.

\- \*\*Статика\*\*: `libopenblas.a`, `libgfortran.a` и другие системные либы вшиты внутрь через `-Wl,--start-group`.



\## Как повторить

1\. Собрать OpenFST с патчем из `/patches/openfst`.

2\. Положить `build\_kaldi\_a.sh` в `kaldi/src/` и запустить.

3\. Настроить CMake в `vosk-api` по образцу из `scripts/vosk/CMakeLists.txt`.

####################################################
1. Текущий статус по Vosk
Мы остановились на успешном создании Portable Build для Windows. Главная ценность этого этапа — решение конфликта путей с тулчейном STM32 и сборка набора, работающего в обычном cmd.exe без установленного MSYS2.

2. Структура итогового документа (Project Summary)
Ниже представлен черновик для твоего README.md или технического отчета по проекту:

Project Name: Vosk-Win-UCRT-Portable
Environment: Windows 11, MSYS2 UCRT64, GCC 14.x

Key Achievements:

Скомпилирована libvosk.dll с использованием UCRT (Universal C Runtime).

Решена проблема "DLL Hell": исключена зависимость от путей STM32/MinGW в системном %PATH%.

Минимальный Runtime Set:

libvosk.dll

libstdc++-6.dll

libwinpthread-1.dll

libgcc_s_seh-1.dll

test_vosk.exe (собранный test_vosk.c)

Build Command (UCRT64):

Bash
gcc test_vosk.c -I./vosk-api/src -L. -lvosk -o test_vosk.exe

