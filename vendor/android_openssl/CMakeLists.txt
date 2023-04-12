set (SSL_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR})

if (QT_VERSION LESS 6.5.0)
    set(ANDROID_EXTRA_LIBS
        ${SSL_ROOT_PATH}/ssl_1.1/${ANDROID_ABI}/libcrypto_1_1.so
        ${SSL_ROOT_PATH}/ssl_1.1/${ANDROID_ABI}/libssl_1_1.so
        CACHE INTERNAL "")
else()
    set(ANDROID_EXTRA_LIBS
        ${SSL_ROOT_PATH}/ssl_3/${ANDROID_ABI}/libcrypto_3.so
        ${SSL_ROOT_PATH}/ssl_3/${ANDROID_ABI}/libssl_3.so
        CACHE INTERNAL "")
endif()
