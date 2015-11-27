cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
project(wallpaper-snow)
set(PROJECT_VERSION "0.1")

set(KF5_MIN_VERSION "5.0.0")

find_package(ECM 0.0.11 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Plasma)

plasma_install_package(snow org.kde.snow wallpapers wallpaper)
