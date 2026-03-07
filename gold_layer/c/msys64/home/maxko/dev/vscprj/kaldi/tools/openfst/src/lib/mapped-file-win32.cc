/*
#include <fst/mapped-file.h>
#include <cstdlib>
#include <cstring>

namespace fst {

MappedFile* MappedFile::Allocate(size_t size, int ) {
  void* data = std::malloc(size);
  if (!data) return nullptr;

  // OpenFst expects writable memory
  std::memset(data, 0, size);

  MemoryRegion region;
  region.data = data;
  region.size = size;

  return new MappedFile(region);
}

}  // namespace fst
*/
/*
#include <fst/mapped-file.h>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iostream>

namespace fst {

using std::string;

// Реализация единственного метода Map, который есть в твоем заголовке
MappedFile* MappedFile::Map(std::istream *istrm, bool memorymap, const string &source, size_t size) {
    // Если нам передали готовый поток, читаем из него
    if (istrm && size > 0) {
        void *data = std::malloc(size);
        if (!data) return nullptr;

        if (!istrm->read(static_cast<char *>(data), size)) {
            std::free(data);
            return nullptr;
        }

        MemoryRegion region;
        region.data = data;
        region.size = size;
        region.offset = 0;
        return new MappedFile(region);
    } 
    
    // Если потока нет, но есть имя файла (source), открываем сами
    if (!source.empty()) {
        std::ifstream is(source, std::ios::binary | std::ios::ate);
        if (!is) return nullptr;

        size_t actual_size = is.tellg();
        is.seekg(0, std::ios::beg);

        void *data = std::malloc(actual_size);
        if (!data) return nullptr;

        if (!is.read(static_cast<char *>(data), actual_size)) {
            std::free(data);
            return nullptr;
        }

        MemoryRegion region;
        region.data = data;
        region.size = actual_size;
        region.offset = 0;
        return new MappedFile(region);
    }

    return nullptr;
}

// Реализация Allocate
MappedFile* MappedFile::Allocate(size_t size, int flags) {
    void *data = std::calloc(1, size);
    if (!data) return nullptr;

    MemoryRegion region;
    region.data = data;
    region.size = size;
    region.offset = 0;

    return new MappedFile(region);
}

} // namespace fst
*/