add_subdirectory(json_cpp)

if (ANDROID)
    include(android_openssl/CMakeLists.txt)
endif()
