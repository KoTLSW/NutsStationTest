//
//  UpLoadDataToPDCA.h
//  LeftButtonFlexCompassSenorTest
//
//  Created by linanlin on 2017/7/22.
//  Copyright © 2017年 linanlin. All rights reserved.
//

/*上传PDCA的步骤
 1: 调用  UUTStartTest 初始化环境。
 
 2: 调用  ValidateSerialNumber 检查SN是不是合格。
 
 3: 调用 ValidateAMIOK 检查产线的网络环境是否正常。
 
 ------如果以上都正常，往下执行---------
 
 4: 调用 AddDefaultAttribute 添加默认的属性 ---软件的版本和软件的名称
 
 5: 调用 AddAttribute 添加其他的String字段。
 
 6: 调用 AddTestItemWithItemName 添加测试项。
 
 7: 最后调用 CommitPDCA 把以上添加的字段和测试项全部上传PDCA系统
 
 
 */

//PS: 一般产线的环境都会把 libInstantPudding 库放在 /usr/local/lib/目录下。如果没有，需要手动添加。

#import <Foundation/Foundation.h>
#import "InstantPudding_API.h"
@interface UpLoadDataToPDCA : NSObject
{
    int Number;
    IP_UUTHandle IP_UID;
    IP_API_Reply IP_REPLY;
}
@property (nonatomic,assign) BOOL isFailed;

/*
  param: number 默认传 1，用于测试环境
 */
 
-(instancetype)initWithNumber:(int)number;


/*
 初始化测试环境
 */

- (BOOL) UUTStartTest;
/*
 废除测试环境
 */
- (BOOL) UUTCancelTest;

/*
   验证二维码是否合格，Apple的 InstantPudding_API有自己的正则表达式去规则去验证SN是否合格。
   @param : 传入的是产品的SN。
   @return : PASS 或者 FAIL 用于判断验证结果
 */

- (NSString*) ValidateSerialNumber: (NSString*)SN;

/*
    验证网络是否OK,产线的上网线连接如果是正常状态，屏幕显示的是非红色背景，比如蓝色和绿色，如果连接异常，显示的是红色。
    @param : 传入的是产品的SN。
    @return : PASS 或者 FAIL 用于判断验证结果
 */

- (NSString*)ValidateAMIOK:(NSString*)SN;

/*
    添加默认属性，PDCA系统需要记录软件名称和版本号。
    @param sn 产品的 SN，一般是17位的字符串。
    @param swVer 软件的版本号，格式是V1.2.1。
    @param swName 软件的名字。没有特别的格式要求
 
 
 */
- (void)AddDefaultAttribute:(NSString*)sn SoftwareVersion:(NSString*)swVer SoftwareName:(NSString*)swName;


/*
    以 key-value的形式添加String字段给PDCA系统。
 */

- (void)AddAttribute: (NSString*)name AttributeValue:(NSString*)value;


/*
    添加测试项
    @param itemName 测试项的名字
    @param testValue 测试项的值，传入的是字符串，但是这个字符串一定是要能解包成int或者float类型的，而且不能是Null。负责系统会报错。
    @param testResult 传入PASS 或者 FAIL 字样
    @param hightlimit 上限。必须是能够解包成int或者float类型。
    @param lowlimit 上限。必须是能够解包成int或者float类型。
    @param errorInfo 错误信息，如果测试结果是Fail，这里可以输入fail的原因，底层会把这个fail的原因上传给系统。
    @param model PDCA存放的位置，常用的是realTime 和 audit 模式，对应的是 MP 和 GRR两种方式。如果需要上传到realTime服务器，请传入 MP 字符串，如果需要上传到audit 服务器，请传入 GRR 字符串。
 */


-(BOOL)AddTestItemWithItemName:(NSString*)itemName
                      TestValue:(NSString*)testValue
                     TestResult:(NSString*)testResult
                      HighLimit:(NSString*)highLimit
                       LowLimit:(NSString*)lowLimit
                       Unit:(NSString*)unit
                      ErrorInfo:(NSString*)errorInfo withModel:(NSString *)model;


/*
  上传PDCA的
  @param : isTestOK 传入Bool值，测试pass 传入 1，否则传入 0.
  @return : PASS 或者 FAIL  或者 错误信息 用于判断上传结果。
 */

- (NSString*) CommitPDCA:(bool)isTestOk;  //commit到PDCA




//添加本地文件到PDCA服务器
/*
 fileName 是文件的名字 eg ： DLC81960015JQJT1T_Touch_Station_3_2018-05-22T000514.txt.gz
 filePath 是文件名字前面的路径，会在Api的实现里面把名字和路径拼接起来。 eg: /vault/X1501_FATP_Results/GRR_DOE/2018-05-22 
 return : PASS 或者一堆错误的信息，用于判断上传Blob是否成功。
 */
-(NSString*)addBlobFileName:(NSString*)fileName filePath:(NSString*)filePath;


//检验SN的返回值
-(NSString *)SFC_CheckSN:(NSString *)Sn WithStationID:(NSString *)station_id;



@end
