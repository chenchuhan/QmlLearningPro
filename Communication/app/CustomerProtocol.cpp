#include "Customer.h"

Customer::Customer()
{

}


//

void Customer::receiveBytes(LinkInterface* link, QByteArray b) {


    for (int i = 0; i < buf.length(); i++)
    {
        /* code */
        if (sanhang_parse_char(static_cast<unsigned char>(buf[i]), _msg))
        {
            /* code */
            switch (_msg.msg_head.cmd)
            {
            case 0xB4:    /* 设备信息 */
                _devinfo_process(_msg);
                break;
            case 0xB5:    /* 基础信息 */
                _baseinfo_process(_msg);
                break;
            case 0xB6:    /* 检测信息 */
                _detectinfo_process(_msg);
                break;
            case 0xB7:    /* 跟踪信息 */
                _trackinfo_process(_msg);
                break;
            default:
                break;
            }
        }
    }

}


int SanHangCtr::sanhang_parse_char(unsigned char char_d, SANHANG_MSG& msg)
{
    int ret_bool = 0;
    // printf("pro_state:%d\n", pro_state);
    switch (_pro_state)
    {
    case SANHANG_DEFAULT:
        /* code */
        if (char_d == 0xeb) {
            /* code */
            memset(&msg, 0, sizeof(msg));
            msg.msg_head.header[0] = char_d;
            _pro_state = SANHANG_HEAD;
        }
        _data_index = 0;
        break;
    case SANHANG_HEAD:
        if (char_d == 0x90) {
            /* code */
            msg.msg_head.header[1] = char_d;
            _pro_state = SANHANG_LEN1;
        }
        else {
            _pro_state = SANHANG_DEFAULT;
        }
        break;
    case SANHANG_LEN1:
        msg.msg_head.len = char_d;
        _pro_state = SANHANG_LEN2;
        break;
    case SANHANG_LEN2:
        msg.msg_head.len |= char_d << 8;
        _pro_state = SANHANG_ID1;
        break;
    case SANHANG_ID1:
        msg.msg_head.identificationCode[0] = char_d;
        _pro_state = SANHANG_ID2;
        break;
    case SANHANG_ID2:
        msg.msg_head.identificationCode[1] = char_d;
        _pro_state = SANHANG_CMD;
        break;
    case SANHANG_CMD:
        msg.msg_head.cmd = char_d;
        _pro_state = SANHANG_DATA;
        break;
    case SANHANG_DATA:
        msg.data[_data_index] = char_d;
        _data_index++;
        if ((msg.msg_head.len - 7) == _data_index) {
            /* code */
            _pro_state = SANHANG_CRC1;
        }
        break;
    case SANHANG_CRC1:
        msg.crc = char_d;
        // printf("msg.crc1:0x%x\n", msg.crc);
        // msg.data[_data_index] = char_d;
        // printf("SANHANG_CRC1:0x%x\n", char_d);
        _pro_state = SANHANG_CRC2;
        break;
    case SANHANG_CRC2:
    {
        // printf("msg.crc21:0x%x\n", msg.crc);
        // printf("msg.len:0x%x\n", msg.msg_head.len);

        msg.crc |= ((short)char_d)<<8;
        // printf("msg.crc22:0x%x\n", msg.crc);

        // msg.data[_data_index + 1] = char_d;
        unsigned short crc = crcCount((char*)&msg + 2, (int)msg.msg_head.len - 2);
        // printf("SANHANG_CRC2:0x%x\n", char_d);
        _pro_state = SANHANG_DEFAULT;
        if (crc == msg.crc) {
            /* code */
            ret_bool = 1;
        }
        else {
//           qDebug("udp", "[cmd:%.2x]crc error!!! crcCount:%d crcData:%d\n", msg.msg_head.cmd, crc, msg.crc);           //qDebug("udp", "[cmd:%.2x]crc error!!! crcCount:%d crcData:%d\n", msg.msg_head.cmd, crc, msg.crc);
//            qDebug() << QString("[cmd:%.2x]crc error!!! crcCount:%d crcData:%d\n").arg(msg.msg_head.cmd).arg(crc).arg(msg.crc);
        }
        if (msg.msg_head.cmd == 0xb4) {
            /* code */
            ret_bool = 1;
        }
    }
        break;
    default:
        break;
    }
    return ret_bool;
}
