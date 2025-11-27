cmake_minimum_required(VERSION 3.16)

project(TemplateWaylandCompositor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS REQUIRED Core Qml Quick WaylandCompositor )

file(GLOB SRCS "src/*.cpp")
file(GLOB HEADERS "src/*.hpp")

qt_add_executable(appTemplateWaylandCompositor
    ${SRCS} 
    ${HEADERS}
)

file(GLOB QT_RESOURCE LIST_DIRECTORIES false RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "src/QmlSource/*.qml")

set(qt_resource_files
    "src/Resource/background.jpg"
    "src/Resource/48.png"
    "src/Resource/64.png"
)

qt6_add_resources(appTemplateWaylandCompositor "appTemplateWaylandCompositor"
    PREFIX
        "/"
    FILES
        ${qt_resource_files}
        ${QT_RESOURCE}
)

set_target_properties(appTemplateWaylandCompositor PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appTemplateWaylandCompositor PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::WaylandCompositor
    Qt6::Qml
)

include(GNUInstallDirs)
install(TARGETS appTemplateWaylandCompositor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
