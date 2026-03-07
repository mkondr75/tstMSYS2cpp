import ctypes
from . import libvosk

# --- Глобальные функции ---
libvosk.vosk_set_log_level.argtypes = [ctypes.c_int]
libvosk.vosk_gpu_init.argtypes = []
libvosk.vosk_gpu_thread_init.argtypes = []

def SetLogLevel(level):
    libvosk.vosk_set_log_level(level)

def GpuInit():
    libvosk.vosk_gpu_init()

def GpuThreadInit():
    libvosk.vosk_gpu_thread_init()

# --- Model & Speaker Model ---
libvosk.vosk_model_new.argtypes = [ctypes.c_char_p]
libvosk.vosk_model_new.restype = ctypes.c_void_p
libvosk.vosk_model_free.argtypes = [ctypes.c_void_p]
libvosk.vosk_model_find_word.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
libvosk.vosk_model_find_word.restype = ctypes.c_int

libvosk.vosk_spk_model_new.argtypes = [ctypes.c_char_p]
libvosk.vosk_spk_model_new.restype = ctypes.c_void_p
libvosk.vosk_spk_model_free.argtypes = [ctypes.c_void_p]

class Model:
    def __init__(self, model_path):
        self.res = libvosk.vosk_model_new(model_path.encode('utf-8'))
        if not self.res: raise Exception("Failed to create a model")
    def __del__(self):
        if hasattr(self, 'res') and self.res: libvosk.vosk_model_free(self.res)
    def find_word(self, word):
        return libvosk.vosk_model_find_word(self.res, word.encode('utf-8'))

class SpkModel:
    def __init__(self, model_path):
        self.res = libvosk.vosk_spk_model_new(model_path.encode('utf-8'))
        if not self.res: raise Exception("Failed to create a speaker model")
    def __del__(self):
        if hasattr(self, 'res') and self.res: libvosk.vosk_spk_model_free(self.res)

# --- Recognizer ---
libvosk.vosk_recognizer_new.argtypes = [ctypes.c_void_p, ctypes.c_float]
libvosk.vosk_recognizer_new.restype = ctypes.c_void_p
libvosk.vosk_recognizer_new_spk.argtypes = [ctypes.c_void_p, ctypes.c_float, ctypes.c_void_p]
libvosk.vosk_recognizer_new_spk.restype = ctypes.c_void_p
libvosk.vosk_recognizer_new_grm.argtypes = [ctypes.c_void_p, ctypes.c_float, ctypes.c_char_p]
libvosk.vosk_recognizer_new_grm.restype = ctypes.c_void_p
libvosk.vosk_recognizer_free.argtypes = [ctypes.c_void_p]

libvosk.vosk_recognizer_set_spk_model.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
libvosk.vosk_recognizer_set_grm.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
libvosk.vosk_recognizer_set_max_alternatives.argtypes = [ctypes.c_void_p, ctypes.c_int]
libvosk.vosk_recognizer_set_words.argtypes = [ctypes.c_void_p, ctypes.c_int]
libvosk.vosk_recognizer_set_partial_words.argtypes = [ctypes.c_void_p, ctypes.c_int]
libvosk.vosk_recognizer_set_nlsml.argtypes = [ctypes.c_void_p, ctypes.c_int]
libvosk.vosk_recognizer_set_endpointer_mode.argtypes = [ctypes.c_void_p, ctypes.c_int]
libvosk.vosk_recognizer_set_endpointer_delays.argtypes = [ctypes.c_void_p, ctypes.c_float, ctypes.c_float, ctypes.c_float]

libvosk.vosk_recognizer_accept_waveform.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_int]
libvosk.vosk_recognizer_accept_waveform.restype = ctypes.c_int
libvosk.vosk_recognizer_accept_waveform_s.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_short), ctypes.c_int]
libvosk.vosk_recognizer_accept_waveform_s.restype = ctypes.c_int
libvosk.vosk_recognizer_accept_waveform_f.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_float), ctypes.c_int]
libvosk.vosk_recognizer_accept_waveform_f.restype = ctypes.c_int

libvosk.vosk_recognizer_result.argtypes = [ctypes.c_void_p]
libvosk.vosk_recognizer_result.restype = ctypes.c_char_p
libvosk.vosk_recognizer_partial_result.argtypes = [ctypes.c_void_p]
libvosk.vosk_recognizer_partial_result.restype = ctypes.c_char_p
libvosk.vosk_recognizer_final_result.argtypes = [ctypes.c_void_p]
libvosk.vosk_recognizer_final_result.restype = ctypes.c_char_p
libvosk.vosk_recognizer_reset.argtypes = [ctypes.c_void_p]

class KaldiRecognizer:
    def __init__(self, *args):
        if len(args) == 2:
            self.res = libvosk.vosk_recognizer_new(args[0].res, args[1])
        elif len(args) == 3 and isinstance(args[2], SpkModel):
            self.res = libvosk.vosk_recognizer_new_spk(args[0].res, args[1], args[2].res)
        elif len(args) == 3 and isinstance(args[2], str):
            self.res = libvosk.vosk_recognizer_new_grm(args[0].res, args[1], args[2].encode('utf-8'))
        else: raise TypeError("Invalid arguments")
        if not self.res: raise Exception("Failed to create recognizer")

    def __del__(self):
        if hasattr(self, 'res') and self.res: libvosk.vosk_recognizer_free(self.res)
    def SetSpkModel(self, spk_model): libvosk.vosk_recognizer_set_spk_model(self.res, spk_model.res)
    def SetGrammar(self, grammar): libvosk.vosk_recognizer_set_grm(self.res, grammar.encode('utf-8'))
    def SetMaxAlternatives(self, max_alt): libvosk.vosk_recognizer_set_max_alternatives(self.res, max_alt)
    def SetWords(self, words): libvosk.vosk_recognizer_set_words(self.res, 1 if words else 0)
    def SetPartialWords(self, p_words): libvosk.vosk_recognizer_set_partial_words(self.res, 1 if p_words else 0)
    def SetNLSML(self, nlsml): libvosk.vosk_recognizer_set_nlsml(self.res, 1 if nlsml else 0)
    def SetEndpointerMode(self, mode): libvosk.vosk_recognizer_set_endpointer_mode(self.res, mode)
    def SetEndpointerDelays(self, start_max, end, max_val): libvosk.vosk_recognizer_set_endpointer_delays(self.res, start_max, end, max_val)
    def AcceptWaveform(self, data): return libvosk.vosk_recognizer_accept_waveform(self.res, data, len(data))
    def Result(self): return libvosk.vosk_recognizer_result(self.res).decode('utf-8')
    def PartialResult(self): return libvosk.vosk_recognizer_partial_result(self.res).decode('utf-8')
    def FinalResult(self): return libvosk.vosk_recognizer_final_result(self.res).decode('utf-8')
    def Reset(self): libvosk.vosk_recognizer_reset(self.res)

# --- Batch API ---
libvosk.vosk_batch_model_new.argtypes = [ctypes.c_char_p]
libvosk.vosk_batch_model_new.restype = ctypes.c_void_p
libvosk.vosk_batch_model_free.argtypes = [ctypes.c_void_p]
libvosk.vosk_batch_recognizer_new.argtypes = [ctypes.c_void_p, ctypes.c_float]
libvosk.vosk_batch_recognizer_new.restype = ctypes.c_void_p
libvosk.vosk_batch_recognizer_free.argtypes = [ctypes.c_void_p]

class BatchModel:
    def __init__(self, path):
        self.res = libvosk.vosk_batch_model_new(path.encode('utf-8'))
    def __del__(self):
        if hasattr(self, 'res') and self.res: libvosk.vosk_batch_model_free(self.res)

class BatchRecognizer:
    def __init__(self, model, sample_rate):
        self.res = libvosk.vosk_batch_recognizer_new(model.res, sample_rate)
    def __del__(self):
        if hasattr(self, 'res') and self.res: libvosk.vosk_batch_recognizer_free(self.res)

# --- Text Processor ---
libvosk.vosk_text_processor_new.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
libvosk.vosk_text_processor_new.restype = ctypes.c_void_p
libvosk.vosk_text_processor_free.argtypes = [ctypes.c_void_p]
libvosk.vosk_text_processor_itn.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
libvosk.vosk_text_processor_itn.restype = ctypes.c_char_p

class TextProcessor:
    def __init__(self, tagger, verbalizer):
        self.res = libvosk.vosk_text_processor_new(tagger.encode('utf-8'), verbalizer.encode('utf-8'))
    def __del__(self):
        if hasattr(self, 'res') and self.res: libvosk.vosk_text_processor_free(self.res)
    def itn(self, text):
        return libvosk.vosk_text_processor_itn(self.res, text.encode('utf-8')).decode('utf-8')