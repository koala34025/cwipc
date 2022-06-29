
# Creating installers
if(APPLE)
    set(CPACK_GENERATOR TGZ)
    set(CPACK_SOURCE_GENERATOR TGZ)
elseif(UNIX)
    set(CPACK_GENERATOR DEB)
    set(CPACK_SOURCE_GENERATOR TGZ)
    set(_debdir "${CMAKE_CURRENT_LIST_DIR}/CwipcInstallers-debian")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Jack Jansen")
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "python3 (>=3.8), python3-pip (>=20.0), libc6 (>= 2.29), libgcc-s1 (>= 3.0), libglfw3 (>= 3.0), libglu1-mesa | libglu1, libjpeg8 (>= 8c), liblz4-1 (>= 0.0~r130), libopencv-core4.2 (>= 4.2.0+dfsg), libopencv-imgproc4.2 (>= 4.2.0+dfsg), libopengl0, libpcl-common1.10 (>= 1.10.0+dfsg), libpcl-io1.10 (>= 1.10.0+dfsg), libstdc++6 (>= 9), libturbojpeg")
	set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "libk4a1.3 (= 1.3.0), libk4abt1.0 (= 1.0.0), librealsense2 (>= 2.50.0)")
    #set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS YES)
    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${_debdir}/postinst;${_debdir}/postrm")
    set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)
elseif(WIN32)
    set(CPACK_GENERATOR NSIS)
    set(CPACK_SOURCE_GENERATOR ZIP)
    set(_nsisdir "${CMAKE_CURRENT_LIST_DIR}/CwipcInstallers-nsis")
    set(CPACK_NSIS_PACKAGE_NAME "cwipc")
	set(CPACK_NSIS_INSTALL_DIRECTORY "cwipc")
    set(CPACK_NSIS_INSTALL_REGISTRY_KEY "cwipc")
    set(CPACK_NSIS_MODIFY_PATH YES)
	set(CPACK_NSIS_DEFINES "RequestExecutionLevel admin")
    set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "")
	#string(APPEND CPACK_NSIS_EXTRA_INSTALL_COMMANDS "LogSet On\\n")
	set(_hide "")
	#set(_hide "-WindowStyle Hidden")
    string(APPEND CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait 'powershell -ExecutionPolicy Bypass ${_hide} -File \\\"$INSTDIR\\\\share\\\\cwipc\\\\scripts\\\\install-3rdparty-full-win1064.ps1\\\"'\\n")
    string(APPEND CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait '$INSTDIR\\\\bin\\\\cwipc_pymodules_install.bat'")
    set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "")
    string(APPEND CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "ExecWait 'python3 -m pip uninstall -y cwipc_util cwipc_codec cwipw_realsense2 cwipc_kinect'\\n")
else()
    message(WARNING Cannot create packages for this system)
endif()
set(CPACK_PACKAGE_VENDOR "CWI DIS Group")
set(CPACK_PACKAGE_CONTACT "Jack.Jansen@cwi.nl")
set(CPACK_PACKAGE_VERSION ${CWIPC_VERSION})
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/readme.md")
set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_SOURCE_DIR}/readme.md")
set(CPACK_OUTPUT_FILE_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/package")
set(CPACK_PACKAGE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} _arch)
string(TOLOWER ${CMAKE_SYSTEM_NAME} _sys)
string(TOLOWER ${PROJECT_NAME} _project_lower)
set(CPACK_PACKAGE_FILE_NAME "${_project_lower}-${CWIPC_VERSION}-${_sys}-${_arch}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${_project_lower}-${CWIPC_VERSION}")

# not .gitignore as its regex syntax is distinct
file(READ ${CMAKE_CURRENT_LIST_DIR}/.cpack_ignore _cpack_ignore)
string(REGEX REPLACE "\n" ";" _cpack_ignore ${_cpack_ignore})
set(CPACK_SOURCE_IGNORE_FILES "${_cpack_ignore}")

install(FILES ${CPACK_RESOURCE_FILE_README} ${CPACK_RESOURCE_FILE_LICENSE}
  DESTINATION share/docs/${PROJECT_NAME})

include(CPack)
