set(JSONCPP_SOURCES
    src/json_tool.h
    src/json_reader.cpp
    src/json_valueiterator.inl
    src/json_value.cpp
    src/json_writer.cpp
)

add_library(json_cpp STATIC ${JSONCPP_SOURCES})
target_include_directories(json_cpp PUBLIC include/)
