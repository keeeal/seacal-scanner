#include "message.h"

TEST(MessageTest, SendPackedMessage) {
    message::PackedMessage packed = {0, 1, 2};

    /* Expect this message to be packed as 4 bytes:
    - 0x93 (array of 3 elements)
    - 0x00 (discriminant)
    - 0x01 (parameter_0)
    - 0x02 (parameter_1)
    */
    EXPECT_CALL(Serial, write(testing::_, testing::Eq(4)));
    message::send(packed);
}
