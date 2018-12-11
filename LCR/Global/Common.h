//
//  Common.h
//  HowToWorks
//
//  Created by h on 17/4/10.
//  Copyright © 2017年 bill. All rights reserved.
//
//此头文件，定义消息，用户信息。

#ifndef Common_h
#define Common_h

//通知PDCA和SFC处理
#define kPDCAandSFCNotification            @"PDCAandSFC"


//UpdateItem---key---subkey
#define kFixtureFix1                        @"Fix1"
#define kFixtureFix2                        @"Fix2"
#define kFixtureFix3                        @"Fix3"
#define kFixtureFix4                        @"Fix4"


#define kFixtureFix_ABC_DEF_Res             @"fix_ABC_DEF_Res"
#define kFixtureFix_B2_E2_Res               @"fix_B2_E2_Res"
#define kFixtureFix_B4_E4_Res               @"fix_B4_E4_Res"
#define kFixtureFix_B_E_Res                 @"fix_B_E_Res"
#define kFixtureFix_Cap                     @"fix_Cap"


//从ViewCtroller中传入到TestAction中的参数
#define kSoftwareVersion                    @"Version"
#define kProductNestID                      @"NestID"
#define kProduct_type                       @"Product_type"
#define kConfig_pro                         @"Config_pro"
#define kOperator_ID                        @"Operator_ID"
#define kTemp                               @"Temp"
#define kHumit                              @"Humit"

//串口通信中的截止符号
#define kEndString                          @"ohm@_@\r\n"


typedef enum  __USER_AUTHORITY{
    AUTHORITY_ADMIN = 0,
    AUTHORITY_ENGINEER = 1,
    AUTHORITY_OPERATOR = 2,
}USER_AUTHORITY;

typedef struct __USER_INFOR {
    char szName[32];
    char szPassword[32];
    USER_AUTHORITY Authority;
}USER_INFOR;

enum FixType
{
    FixType_One,    //第一个治具
    FixType_Two,    //第二个治具
    FixType_Three,  //第三个治具
    FixType_Four,   //第四个治具
    FixType_Default=FixType_One,
    
};


#endif /* Common_h */
