//
//  TestAction.h
//  WorkingFrameWork
//
//  Created by mac on 2017/10/27.
//  Copyright © 2017年 macjinlongpiaoxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Table.h"
#import "Common.h"
#import "Item.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "GetTimeDay.h"
#import "Param.h"
#import "UpdateItem.h"
#import "Plist.h"
#import "Common.h"
#import "InstantPudding_API.h"
#import "UpLoadDataToPDCA.h"
#import "SaveCsvData.h"
#import "SaveDataTool.h"
#import "AgilentCommand.h"
#import "Alert.h"
#import "Calculate.h"
#import "ORSSerialPort.h"
#import "NSString+Extension.h"
#import "Piao_ZipArchive.h"





typedef enum : NSUInteger {
    AutoCode,      //自动               由账户决定
    ManualCode,    //手动
    DebugCode,
} MyQrcCode;

typedef enum : NSUInteger {
    
    StateReady,   //子线程初始化OK
    StateStart,   //可以开始测试
    StateFinsh,   //测试已经结束
    
} StationState;



@protocol FlushMainWindowDelegate <NSObject>

@optional

-(void)FlushMainViewStartTestSolat:(int)fixtype;                              //开始测试前刷新界面
-(void)FlushMainViewFinshTestSolat:(int)fixtype Result:(NSString *)result;    //测试结束后刷新界面
-(void)FlushTestCount:(BOOL)isPass;                                           //测试结果
-(void)DeliverySolat:(int)fixtype DutSn:(NSString *)dutSn;                    //刷新界面输入框的值
-(void)writeDataToTotalCsvPath:(NSString *)path fileName:(NSString *)fileName content:(NSString *)content;  //写入总文件中

@end

@interface TestAction : NSObject


//******************引用的View*******************//
@property(nonatomic,strong)Table  * tab;
@property(nonatomic,strong)NSTextView       * Log_View;              //显示Log日志


//******************枚举*******************//
@property(nonatomic,assign)MyQrcCode      qrCode;                    //手动还是自动
@property(nonatomic,assign)StationState   ActionState;               //线程开始的状态
@property(nonatomic,assign)id<FlushMainWindowDelegate>    delegate;  //代理方法







//需要传递写入csv中的值
@property(nonatomic,strong)NSString     * NestID;                //测试产品的型号
@property(nonatomic,strong)NSString     * Product_type;          //材料的类型
@property(nonatomic,strong)NSString     * Config_pro;            //配置文件的类型
@property(nonatomic,strong)NSString     * Operator_ID;           //操作员工的号码
@property(nonatomic,strong)NSDictionary * Config_Dic;            //上述相关参数





@property(nonatomic,strong)NSString     * dut_sn;                //产品的SN





//==================================
-(id)initWithTable:(Table *)tab withTextView:(NSTextView *)LogView withFixParam:(Param *)param withType:(int)type_num
            titile:(NSString *)title withDelegate:(id<FlushMainWindowDelegate>)delegate;
-(void)TestAction; //测试流程
-(void)threadStart;//线程开启
-(void)threadEnd;//线程结束


@end
