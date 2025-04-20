file(GLOB TEST_SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

foreach(testfile ${TEST_SOURCES})
    file(RELATIVE_PATH filename ${CMAKE_CURRENT_SOURCE_DIR} ${testfile})
    string(REPLACE ".cpp" "" file ${filename})
    add_executable(bench_${file} ${testfile})
    target_link_libraries(bench_${file} benchmark::benchmark)
endforeach(testfile ${TEST_SOURCES})
