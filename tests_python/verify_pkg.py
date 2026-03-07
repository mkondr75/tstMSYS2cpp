import vosk
import wave
import sys
import os

# Пути
MODEL_PATH = r"C:\MAX\download\speechtotext\models\ru\vosk-model-small-ru-0.22"
AUDIO_FILE = r"C:\msys64\home\maxko\dev\togit\artifacts\a.wav"

def run_test():
    # 1. Проверка инициализации (и подгрузки DLL)
    print("--- Инициализация логов ---")
    vosk.SetLogLevel(0)
    
    if not os.path.exists(MODEL_PATH):
        print(f"ОШИБКА: Модель не найдена: {MODEL_PATH}")
        return

    # 2. Загрузка модели через наш новый класс
    print("--- Загрузка модели ---")
    model = vosk.Model(MODEL_PATH)
    
    # 3. Настройка распознавателя
    rec = vosk.KaldiRecognizer(model, 16000.0)
    rec.SetWords(True) # Проверим работу новых методов
    
    # 4. Чтение аудио
    if not os.path.exists(AUDIO_FILE):
        print(f"ОШИБКА: Аудио-файл не найден: {AUDIO_FILE}")
        return

    wf = wave.open(AUDIO_FILE, "rb")
    print(f"Обработка файла: {AUDIO_FILE}")

    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            print(rec.Result())
        else:
            # Можно выводить частичные результаты для красоты
            # print(rec.PartialResult())
            pass

    # 5. Финальный результат
    print("\n--- Финальный результат ---")
    print(rec.FinalResult())

if __name__ == "__main__":
    run_test()