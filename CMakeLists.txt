cmake_minimum_required(VERSION 3.6.0)

project(glacier-camera
        VERSION 0.2
	DESCRIPTION "The Glacier camera")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

include(FeatureSummary)
include(GNUInstallDirs)

set(QT_MIN_VERSION "6.0.0")
find_package(Qt6 COMPONENTS Gui Qml Quick LinguistTools REQUIRED)
find_package(Glacier 0.9 COMPONENTS App REQUIRED)

add_subdirectory(src)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt_add_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES})
add_dependencies(glacier-camera translations)

install(FILES ${QM_FILES}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-camera/translations)

install(FILES glacier-camera.desktop
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)
install(DIRECTORY images
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-camera)
