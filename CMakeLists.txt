cmake_minimum_required(VERSION 3.16)

project(OuluWeather VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup()

set(CMAKE_AUTORCC ON)

add_subdirectory(vendor/)

qt_add_executable(appOuluWeather
    resouces.qrc
    main.cpp
    networkservice.h networkservice.cpp
    highlightsbackend.h highlightsbackend.cpp
    stationforecastdata.h stationforecastdata.cpp
)

qt_add_qml_module(appOuluWeather
    URI OuluWeather
    VERSION 1.0
    QML_FILES Main.qml Screen01.qml Overview.qml TestOverview.qml Highlights.qml
)

target_include_directories(appOuluWeather PUBLIC vendor/)

set_property(TARGET appOuluWeather PROPERTY QT_ANDROID_EXTRA_LIBS ${ANDROID_EXTRA_LIBS})

set_target_properties(appOuluWeather PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appOuluWeather
    PRIVATE Qt6::Quick Qt6::QuickControls2 json_cpp
)

install(TARGETS appOuluWeather
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
