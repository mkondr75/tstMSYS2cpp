import os
import sys
import ctypes

_base_dir = os.path.dirname(__file__)

# Добавляем папку с DLL в пути поиска (критично для Python 3.8+)
if sys.platform == "win32" and hasattr(os, "add_dll_directory"):
    os.add_dll_directory(_base_dir)

_dll_name = "libvosk.dll"
lib_path = os.path.join(_base_dir, _dll_name)

if not os.path.exists(lib_path):
    raise ImportError(f"Cannot find {_dll_name} in {_base_dir}")

# Загружаем DLL
libvosk = ctypes.WinDLL(lib_path)

# Импортируем классы для внешнего использования
from .vosk_api import Model, KaldiRecognizer, SpkModel, SetLogLevel
