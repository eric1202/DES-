//
//  TribleDes.m
//  DES算法
//
//  Created by My MacPro on 15/7/6.
//  Copyright (c) 2015年 My MacPro. All rights reserved.
//

#import "TribleDes.h"
#import "des.h"
@implementation TribleDes

- (NSString *)encData:(NSString *)data mainKey:(NSString *)key
{
    NSString *inputString = @"6227003769000146431d39025208211020000fffffffffff5359189912980903d15615600000000000000000000002141140000dd000000000000d000000000000d0363140000000000fffffffffffff";
    NSString *encKey = @"E798654F0096C745B9829C2B779BEFC6";
    
    
    inputString = data;
    encKey = key;
    NSData *inputData = [self hexStr2Data:inputString];
    NSData *encKeyData = [self hexStr2Data:encKey];
    uint8_t *indata = (uint8_t *)[inputData bytes];
    const uint8_t * kkey = (const uint8_t *)[encKeyData bytes];
    int len = (int)[inputString length]/2;
    unsigned char outdata[len];
    
//    memset(outdata, 0, (int)[inputString length]);
    //    char *s = (char *)malloc(n(www.jb51.net));
    bool b = Des_EncData(indata, outdata, [inputString length]/2, kkey, DES_KEY_MODE_DOUBLE);
    if (b == YES) {
        NSLog(@"%s", [self BinToHex:outdata off:0 length:(int)[inputString length]/2]);
        
        
    }else
    {
        NSLog(@"");
    }
    return [[NSString alloc] initWithFormat:@"%s", [self BinToHex:outdata off:0 length:len]];

}
- (NSString *)decData:(NSString *)data mainKey:(NSString *)key
{
    NSString *inputString = @"6227003769000146431d39025208211020000fffffffffff5359189912980903d15615600000000000000000000002141140000dd000000000000d000000000000d0363140000000000fffffffffffff";
    NSString *encKey = @"E798654F0096C745B9829C2B779BEFC6";
    
    
    inputString = data;
    encKey = key;
    NSData *inputData = [self hexStr2Data:inputString];
    NSData *encKeyData = [self hexStr2Data:encKey];
    uint8_t *indata = (uint8_t *)[inputData bytes];
    const uint8_t * kkey = (const uint8_t *)[encKeyData bytes];
    int len = (int)[inputString length]/2;
    unsigned char outdata[len];
    
//    memset(outdata, 0, (int)[inputString length]);
    //    char *s = (char *)malloc(n(www.jb51.net));
    bool b = Des_DecData(indata, outdata, [inputString length]/2, kkey, DES_KEY_MODE_DOUBLE);
    if (b == YES) {
        NSLog(@"%s", [self BinToHex:outdata off:0 length:(int)[inputString length]/2]);
        
    }else
    {
        NSLog(@"");
    }
    return [[NSString alloc] initWithFormat:@"%s", [self BinToHex:outdata off:0 length:len]];
}
- (NSString *)lisan:(NSString *)data mainKey:(NSString *)key;
{
    
//    a、	用磁道密钥对8字节随机数进行加密，加密的结果作为密钥的左8字节。
    NSString *leftString = [self encData:data mainKey:key];
    
//    b、	8字节随机数和0xFFFFFFFFFFFFFFFF异或。
    
    NSString *temp1 = @"C386A154000000BB";
    NSString *temp2 = @"FFFFFFFFFFFFFFFF";
    temp1 = data;
    unsigned char * buf1 = (unsigned char *)[[self hexStr2Data:temp1] bytes];
    unsigned char * buf2 = (unsigned char *)[[self hexStr2Data:temp2] bytes];
    unsigned char outData[8];
    for (int i = 0; i < 8; i++) {
        outData[i] = buf1[i]^buf2[i];
    }
    NSString *midString = [[NSString alloc] initWithFormat:@"%s",[self BinToHex:outData off:0 length:8]];
//    c、	用磁道密钥对异或后的随机数进行加密，加密的结果作为密钥的右8字节。
    NSString *rightString = [self encData:midString mainKey:key];
    
    NSString *res  = [[NSString alloc] initWithFormat:@"%@%@",leftString,rightString];
    return res;
}

char hout[4096];//可以放在函数体里面
- (char *)BinToHex:(unsigned char *)bin off:(int)off length:(int)len
{
    memset(hout, 0, 4096);
    int i;
    //	hout=(char*)hout;
    for (i=0;i<len;i++)
    {
        sprintf((char*)hout+i*2,"%02x",*(unsigned char*)((char*)bin+i+off));
    }
    hout[len*2]=0;
    return hout;
}

-(NSMutableData *) hexStr2Data:(NSString *) hexString{
    int j=0;
    Byte bytes[hexString.length/2];
    for (int i = 0; i < [hexString length]; i+=2) {
        unichar hex_high = [hexString characterAtIndex:i];
        unichar hex_low = [hexString characterAtIndex:i+1];
        int int_high;
        int int_low;
        if (hex_high >= '0' && hex_high <='9')
            int_high = (hex_high-48)*16;
        else if (hex_high >= 'A' && hex_high <='F')
            int_high = (hex_high-55)*16;
        else
            int_high = (hex_high-87)*16;
        
        if (hex_low >= '0' && hex_low <='9')
            int_low = (hex_low-48);
        else if (hex_low >= 'A' && hex_low <='F')
            int_low = hex_low-55;
        else
            int_low = hex_low-87;
        bytes[j] = int_high+int_low;
        j++;
    }
    NSMutableData *newData = [[NSMutableData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}

@end
