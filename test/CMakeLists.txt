file(GLOB TEST_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

foreach(testfile ${TEST_SOURCES})
    file(RELATIVE_PATH filename ${CMAKE_CURRENT_SOURCE_DIR} ${testfile})
    string(REPLACE ".cpp" "" file ${filename})
    add_executable(tests_${file} ${testfile})
    target_link_libraries(tests_${file} gtest)
endforeach(testfile ${TEST_SOURCES})
