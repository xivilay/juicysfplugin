cmake_minimum_required(VERSION 3.15)

set(PROJECT_NAME "juicysfplugin")
set(VERSION "2.3.3")
set(JUCE_DIR "./external/JUCE")
set(SRC_DIR "./src")
set(FORMATS "Standalone" "VST3")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

juce_add_plugin(${PROJECT_NAME}
    PLUGIN_NAME "Juicy SF"
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

juce_generate_juce_header(${PROJECT_NAME})

target_include_directories(${PROJECT_NAME} PRIVATE "include")

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

target_compile_definitions(${PROJECT_NAME} PUBLIC
    JUCE_USE_CURL=0
    JUCE_WEB_BROWSER=0
)

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
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        find_library (FLUIDSYNTH libfluidsynth.lib PATHS lib/win/x64 REQUIRED)
    else()
        find_library (FLUIDSYNTH libfluidsynth.lib PATHS lib/win/x86 REQUIRED)
    endif()
endif(WIN32)

target_link_libraries(${PROJECT_NAME}
  PRIVATE
    juce::juce_audio_basics
    juce::juce_audio_devices
    juce::juce_audio_formats
    juce::juce_audio_plugin_client
    juce::juce_audio_processors
    juce::juce_audio_utils
    juce::juce_core
    juce::juce_data_structures
    juce::juce_events
    juce::juce_graphics
    juce::juce_gui_basics
    juce::juce_gui_extra
    ${FLUIDSYNTH}
  PUBLIC
    juce::juce_recommended_config_flags
    juce::juce_recommended_lto_flags
    juce::juce_recommended_warning_flags
)
