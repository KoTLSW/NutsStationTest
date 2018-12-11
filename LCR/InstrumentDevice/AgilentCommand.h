//
//  AgilentCommand.h
//  LCR
//
//  Created by mac on 15/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


/*
   电容选择规则:小电容选择并联电路模式CPD，CPG，大电容选择串联模式Cs-D,Cs-Q
   电感选择规则:大电感选择并联等效电路，模式为LPD，LPQ，LPG
              小电感，使用串联等效电路，LSD，LSQ
*/



enum AgilentType {
    Agilent4980,
    Agilent2987,
    Agilent34461,
};

enum AgilentMessureMode
{
    //2987A系列
    AgilentB2987A_RES,
    AgilentB2987A_CURR,
    AgilentB2987A_VOLT,
    
    
    
    
    //4980系列
    AgilentE4980A_AC_RX,   //交流电阻模式
    AgilentE4980A_DC_RX,   //直流电阻模式
    
    AgilentE4980A_LPD,     //利用并联等效电路测得的电感值
    AgilentE4980A_LPQ,     //利用并联等效电路测得的电感值
    AgilentE4980A_LSD,     //利用串联等效电路测得的电感值
    AgilentE4980A_LSQ,     //利用串联等效电路测得的电感值
    
    
    
    AgilentE4980A_CPD,     //利用并联等效电路测得的电容值
    AgilentE4980A_CPQ,     //利用并联等效电路测得的电容值
    AgilentE4980A_CSD,     //利用串联等效电路测得的电容值
    AgilentE4980A_CSQ,     //利用串联等效电路测得的电容值
    
    //34461系列
    Agilent34461A_MODE_RES_4W,     //4线电阻模式
    Agilent34461A_MODE_RES_2W,     //2线电阻模式
    Agilent34461A_MODE_DIODE,      //二极管测试
    Agilent34461A_MODE_CURR_DC,    //直流电流
    Agilent34461A_MODE_CURR_AC,    //交流电流
    Agilent34461A_MODE_VOLT_DC,    //直流电压
    Agilent34461A_MODE_VOLT_AC,    //交流电压
    Agilent34461A_MODE_TEMP_4W,    //温度 四线
    Agilent34461A_MODE_TEMP_2W,    //温度 二线
    Agilent34461A_MODE_CAP,        //电容

};


//定义Block
typedef void(^ReturnBlock)(NSString*,enum AgilentType);

@protocol AgilentDelegate <NSObject>


-(void)getValueFromAgilentValue:(NSString *)value AgilentType:(enum AgilentType)agilentType;

@end



@interface AgilentCommand : NSObject
@property(nonatomic,strong)id<AgilentDelegate> delegate;
@property(nonatomic,assign)BOOL isCollect;
@property(nonatomic,copy)ReturnBlock returnBlock;




//初始化仪器
-(instancetype)initWithHost:(NSString *)host Port:(int)port Queue:(dispatch_queue_t)queueString Delegate:(id)delegate tag:(int)tag AgilentType:(enum AgilentType)agilentType MessageMode:(enum AgilentMessureMode)agilentMessure;

//设置仪器仪表
-(void)SendAgilentCommandsWithType:(enum AgilentType)agilentType MessageMode:(enum AgilentMessureMode)agilentMessure;


//更新某些设置
-(void)uploadAgilentCommands:(NSArray *)commands;

//读取数据
-(void)readData;

//释放网口
-(void)releaseSocket;

@end
