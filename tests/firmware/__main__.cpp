#include <gmock/gmock.h>
#include <gtest/gtest.h>

class MockSerial {
public:
    MOCK_METHOD(int, read, (), ());
    MOCK_METHOD(size_t, write, (const uint8_t* buffer, size_t size), ());
    MOCK_METHOD(int, available, (), (const));
};

MockSerial Serial;

#include "test_message.cpp"

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
