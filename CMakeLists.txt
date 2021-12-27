cmake_minimum_required(VERSION 3.15)

if(ANDROID_PLATFORM)
    set(PROJECT_NAME "juce_jni")
else()
    set(PROJECT_NAME "juicysfplugin")
endif()

set(VERSION "2.3.3")
set(JUCE_DIR "./external/JUCE")
set(JUCE_MODULES_DIR "${JUCE_DIR}/modules")
set(FLUIDSYNTH_DIR "./external/fluidsynth")
set(FLUIDSYNTH_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/fluidsynth")
set(SRC_DIR "./src")
set(FORMATS "Standalone" "VST3")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(${PROJECT_NAME} VERSION ${VERSION})

add_subdirectory(${JUCE_DIR} "juce")

if(WIN32)
    message(STATUS "Building for Windows...")
    set(ASIO_DIR "sdk/asio")
    set(VST2_DIR "sdk/vst2")
    if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/${ASIO_DIR})
        set(BUILD_ASIO 1)
    endif()
    if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/${VST2_DIR})
        set(BUILD_VST2 1)
        juce_set_vst2_sdk_path(${VST2_DIR})
        list(APPEND FORMATS "VST")
    endif()
endif(WIN32)

if(ANDROID_PLATFORM)
    add_library(${PROJECT_NAME} SHARED)
    _juce_initialise_target(${PROJECT_NAME})
else()
    juce_add_plugin(${PROJECT_NAME}
        PLUGIN_NAME "JuicySF"
        VERSION "${VERSION}"
        DESCRIPTION "Audio plugin to play soundfonts"
        PLUGIN_MANUFACTURER_CODE "Blbs"
        PLUGIN_CODE "Jspf"
        COMPANY_NAME "Birchlabs"
        COMPANY_WEBSITE "https://birchlabs.co.uk"
        BUNDLE_ID "uk.co.birchlabs.${PROJECT_NAME}"
        ICON_BIG "Juicy.png"
        FORMATS ${FORMATS}
        IS_SYNTH TRUE
        NEEDS_MIDI_INPUT TRUE
        EDITOR_WANTS_KEYBOARD_FOCUS TRUE
        AU_SANDBOX_SAFE TRUE
    )
endif()

juce_generate_juce_header(${PROJECT_NAME})

target_include_directories(${PROJECT_NAME} PRIVATE 
    "${FLUIDSYNTH_BUILD_DIR}/include"
    "${FLUIDSYNTH_DIR}/include"
)

target_compile_definitions(${PROJECT_NAME} PUBLIC
    JucePlugin_Build_Standalone=1
    JUCE_USE_CURL=0
    JUCE_WEB_BROWSER=0
)

if(BUILD_ASIO)
    message(STATUS "Adding ASIO...")
    target_compile_definitions(${PROJECT_NAME} PRIVATE JUCE_ASIO=1)
    target_include_directories(${PROJECT_NAME} PRIVATE ${ASIO_DIR})
endif(BUILD_ASIO)

if(BUILD_VST2)
    message(STATUS "Adding VST2...")
    target_compile_definitions(${PROJECT_NAME} PUBLIC JUCE_VST3_CAN_REPLACE_VST2=1)
else()
    target_compile_definitions(${PROJECT_NAME} PUBLIC JUCE_VST3_CAN_REPLACE_VST2=0)
endif(BUILD_VST2)

target_sources(${PROJECT_NAME}
  PRIVATE
    "${SRC_DIR}/FilePicker.cpp"
    "${SRC_DIR}/FluidSynthModel.cpp"
    "${SRC_DIR}/MyColours.cpp"
    "${SRC_DIR}/Pills.cpp"
    "${SRC_DIR}/PluginEditor.cpp"
    "${SRC_DIR}/PluginProcessor.cpp"
    "${SRC_DIR}/SlidersComponent.cpp"
    "${SRC_DIR}/SurjectiveMidiKeyboardComponent.cpp"
    "${SRC_DIR}/TableComponent.cpp"
    "${SRC_DIR}/TablesComponent.cpp"
)

if(WIN32)
    find_library (FLUIDSYNTH fluidsynth.lib PATHS "${FLUIDSYNTH_BUILD_DIR}/src/${CMAKE_BUILD_TYPE}" REQUIRED)
endif(WIN32)

if(CMAKE_SYSTEM MATCHES "Linux")
    message(STATUS "Building for Linux...")
    find_library (FLUIDSYNTH fluidsynth PATHS "${FLUIDSYNTH_BUILD_DIR}/src" REQUIRED)
endif()

if(CMAKE_SYSTEM MATCHES "Darwin")
    message(STATUS "Building for MacOS...")
    find_library (FLUIDSYNTH fluidsynth PATHS "${FLUIDSYNTH_BUILD_DIR}/src" REQUIRED)
endif()

target_link_libraries(${PROJECT_NAME}
  PRIVATE
    juce::juce_audio_basics
    juce::juce_audio_devices
    juce::juce_audio_formats
    juce::juce_audio_plugin_client_utils
    juce::juce_audio_plugin_client_Standalone
    juce::juce_audio_processors
    juce::juce_audio_utils
    juce::juce_core
    juce::juce_data_structures
    juce::juce_events
    juce::juce_graphics
    juce::juce_gui_basics
    juce::juce_gui_extra
  PUBLIC
    juce::juce_recommended_config_flags
    juce::juce_recommended_lto_flags
    juce::juce_recommended_warning_flags
)

if(NOT ANDROID)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${FLUIDSYNTH})
endif()

if(ANDROID)
    message(STATUS "Building for ANDROID...")
    string(REPLACE "\\" "/" ANDROID_NDK ${ANDROID_NDK})

    set(OBOE_DIR "${JUCE_MODULES_DIR}/juce_audio_devices/native/oboe")
    set(OBOE_LIB "oboe")
    set(CPU_FEATURES_LIB "cpufeatures")
    set(CPU_FEATURES_ENTRY "sources/android/cpufeatures/cpu-features.c")
    set(FLUIDSYNTH_PREBUILD_DIR "${CMAKE_CURRENT_LIST_DIR}/prebuilt")

    include_directories(AFTER
        "${JUCE_MODULES_DIR}"
        "${JUCE_MODULES_DIR}/juce_audio_processors/format_types/VST3_SDK"
        "${ANDROID_NDK}/sources/android/cpufeatures"
    )

    add_subdirectory (${OBOE_DIR} ${OBOE_LIB})

    add_library("${CPU_FEATURES_LIB}" STATIC "${ANDROID_NDK}/${CPU_FEATURES_ENTRY}")
    set_source_files_properties("${ANDROID_NDK}/${CPU_FEATURES_ENTRY}" PROPERTIES COMPILE_FLAGS "-Wno-sign-conversion -Wno-gnu-statement-expression")

    add_definitions(
        "-DJUCER_ANDROIDSTUDIO_7F0E4A25=1"
        "-DJUCE_ANDROID=1"
        "-DJUCE_ANDROID_API_VERSION=24"
        "-DJUCE_PUSH_NOTIFICATIONS=1"
        "-DJUCE_PUSH_NOTIFICATIONS_ACTIVITY=\"com/rmsl/juce/JuceActivity\""
        "-DJUCE_APP_VERSION=${VERSION}"
        "-DJucePlugin_Build_Standalone=1"
        "-DJucePlugin_Name=\"${PROJECT_NAME}\""
        "-DJucePlugin_Desc=\"${PROJECT_NAME}\""
        "-DJucePlugin_Manufacturer=\"Birchlabs\""
        "-DJucePlugin_ManufacturerWebsite=\"birchlabs.co.uk\""
        "-DJucePlugin_ManufacturerEmail=\"\""
        "-DJucePlugin_ManufacturerCode=Blbs"
        "-DJucePlugin_PluginCode=Jspf"
        "-DJucePlugin_IsSynth=1"
        "-DJucePlugin_WantsMidiInput=1"
        "-DJucePlugin_ProducesMidiOutput=1"
        "-DJucePlugin_IsMidiEffect=0"
        "-DJucePlugin_EditorRequiresKeyboardFocus=1"
        "-DJucePlugin_Version=${VERSION}"
        "-DJucePlugin_VersionString=\"${VERSION}\""
    )

    if(JUCE_BUILD_CONFIGURATION MATCHES "DEBUG")
        add_definitions("-DDEBUG=1" "-D_DEBUG=1")
    elseif(JUCE_BUILD_CONFIGURATION MATCHES "RELEASE")
        add_definitions("-DNDEBUG=1")
        if(NOT (ANDROID_ABI STREQUAL "mips" OR ANDROID_ABI STREQUAL "mips64"))
            set(CMAKE_C_FLAGS_RELEASE          "${CMAKE_C_FLAGS_RELEASE} -flto")
            set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS_RELEASE} -flto")
            set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -flto")
        endif()
    else()
        message(FATAL_ERROR "No matching build-configuration found.")
    endif()

    enable_language(ASM)

    target_compile_options(${PROJECT_NAME} PRIVATE "-fsigned-char")

    find_library(log "log")
    find_library(android "android")
    find_library(glesv3 "GLESv3")
    find_library(egl "EGL")

    target_include_directories(${PROJECT_NAME} PRIVATE 
        "${FLUIDSYNTH_PREBUILD_DIR}/include"
    )

    set(PREBUILT_DIR "${FLUIDSYNTH_PREBUILD_DIR}/lib/${ANDROID_ABI}")

    message(STATUS "${ANDROID_ABI}")

    add_library(fluidsynth SHARED IMPORTED)

    set_target_properties(fluidsynth PROPERTIES IMPORTED_LOCATION "${PREBUILT_DIR}/libfluidsynth.so")

    add_library("juceAndroid" INTERFACE)

    target_link_libraries("juceAndroid" INTERFACE
        ${log}
        ${android}
        ${glesv3}
        ${egl}
        ${CPU_FEATURES_LIB}
        ${OBOE_LIB}
    )

    target_link_libraries(${PROJECT_NAME} PRIVATE
        "juceAndroid"
        "fluidsynth"
    )
endif(ANDROID)