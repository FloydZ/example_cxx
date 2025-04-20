#include <gtest/gtest.h>

using ::testing::InitGoogleTest;
using ::testing::Test;

TEST(SimpleTest, DoesNothing) {
	std::cout << "test\n";
}

int main(int argc, char **argv) {
    InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();
}
