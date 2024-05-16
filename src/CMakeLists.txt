set(SRC main.cpp)

qt_add_resources(RESOURCES qml/glacier-camera.qrc)

add_executable(glacier-camera ${SRC} ${RESOURCES} )

target_link_libraries(glacier-camera
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
	Glacier::App)

install(TARGETS glacier-camera RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})
install(DIRECTORY qml
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-camera)
