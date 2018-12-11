//
//  AgilentCommand.m
//  LCR
//
//  Created by mac on 15/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import "AgilentCommand.h"

@interface AgilentCommand()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket    * sysncSocket;
    
    enum  AgilentType  agilentDeviceType;
    enum  AgilentMessureMode  MessureType;
    
    NSString          * Host;
    int                 Port;
    
}
@end
@implementation AgilentCommand


-(instancetype)initWithHost:(NSString *)host Port:(int)port Queue:(dispatch_queue_t)queueString Delegate:(id)delegate tag:(int)tag AgilentType:(enum AgilentType)agilentType MessageMode:(enum AgilentMessureMode)agilentMessure
{
   
    if (self = [super init]) {
        
        agilentDeviceType = agilentType;
        MessureType       = agilentMessure;
        self.delegate     = delegate;
        
        sysncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queueString];
        sysncSocket.delegate = self;
        Host = host;
        Port = port;
        
        NSError * error;
        //1.软件进行连接
        [sysncSocket connectToHost:host onPort:port error:&error];
        NSLog(@"sysncSocket connect Host error:%@",error);
   
        //3.读取数据
        [sysncSocket readDataWithTimeout:-1 tag:tag];

        
    }
   
    return self;
}




-(void)SendAgilentCommandsWithType:(enum AgilentType)agilentType MessageMode:(enum AgilentMessureMode)agilentMessure
{
     NSArray * commandArray;
    if (agilentType == Agilent4980) {
        switch (agilentMessure) {
                
            case AgilentE4980A_DC_RX:commandArray = @[@"*RST",@":FREQ 20",@":FUNC:IMP RX",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,1",@":TRIGger:SOURce INTernal"];
                break;
                
            case AgilentE4980A_AC_RX:commandArray = @[@"*RST",@":FREQ 1000",@":FUNC:IMP RX",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,1",@":TRIGger:SOURce INTernal"];
                break;
              
            //电容值
            case AgilentE4980A_CPD:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP CPD",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,1",@":TRIGger:SOURce INTernal"];
                break;
                
            case AgilentE4980A_CPQ:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP CPQ",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,1",@":TRIGger:SOURce INTernal"];
                break;
            case AgilentE4980A_CSD:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP CSD",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,10",@":TRIGger:SOURce INTernal"];
                break;
            case AgilentE4980A_CSQ:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP CSQ",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,10",@":TRIGger:SOURce INTernal"];
                break;
                
            //电感值
            case AgilentE4980A_LPD:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP LPD",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,1",@":TRIGger:SOURce INTernal"];
                break;
                
            case AgilentE4980A_LPQ:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP LPQ",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,1",@":TRIGger:SOURce INTernal"];
                break;
            case AgilentE4980A_LSD:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP LSD",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,10",@":TRIGger:SOURce INTernal"];
                break;
            case AgilentE4980A_LSQ:commandArray = @[@"*RST",@"*CLS",@":FUNC:IMP LSQ",@":FUNC:IMP:RANG:AUTO ON",@":APER LONG,10",@":TRIGger:SOURce INTernal"];
                break;
                
                
                
            default:
                break;
        }
    }
    if (agilentType == Agilent2987) {
        switch (agilentMessure) {
            case AgilentB2987A_RES:
            {
                NSLog(@"开始设置电阻");
                commandArray = @[
                                           @"*RST",
                                           @":SENS:FUNC:ON 'RES'",
                                           @":SENS:RES:RANG:AUTO ON",
                                           @":SENS:CURR:NPLC:AUTO ON",
                                           @":SOUR:FUNC:MODE VOLT",
                                           @":SOUR:VOLT 20",
                                           @":OUTP ON",
                                           @":SENS:RES:APER 1",
                                           @":SENS:RES:NPLC 1",
                                           @":INP ON",
                                           @":SENS:RES:VSEL VSO"
                                           ];
                NSLog(@"电阻已经设置好");
            }
            break;
                
            case AgilentB2987A_CURR:
            {
                NSLog(@"开始设置电流");
                commandArray = @[
                                           @"*RST",
                                           @":SOUR:FUNC:MODE VOLT",
                                           @":SOUR:VOLT 20",
                                           @":SENS:FUNC 'CURR'",
                                           @":SENS:CURR:RANG:AUTO ON",
                                           @":SENS:CURR:NPLC:AUTO OFF",
                                           @":SENS:CURR:APER 1",
                                           @":SENS:CURR:NPLC 1",
                                           @":OUTP ON",
                                           @":INP ON",
                                           @":MEAS:CURR?"
                                           ];
                NSLog(@"电流已经设置好");
             }
                break;
                
            case AgilentB2987A_VOLT:
            {
                NSLog(@"开始设置电流");
                commandArray = @[
                                           @"*RST",
                                           @":SOUR:FUNC:MODE VOLT",
                                           @":SOUR:VOLT 20",
                                           @":SENS:FUNC 'VOLT'",
                                           @":SENS:VOLT:RANG:AUTO ON",
                                           @":SENS:VOLT:NPLC:AUTO ON",
                                           @":SENS:VOLT:APER:AUTO ON",
                                           @":SENS:VOLT:GUAR OFF",
                                           @":OUTP ON",
                                           @":INP ON",
                                           @":MEAS:VOLT?"
                                           ];
                NSLog(@"电流已经设置好");
            }
                break;
            default:
                break;
        }
    }
    if (agilentType == Agilent34461) {
        
        switch (agilentMessure) {
                
            case Agilent34461A_MODE_RES_4W:
            {
                NSLog(@"开始设置4线法测试电阻");
                commandArray = @[
                                          @"*RST",
                                          @"*CLS",
                                          @"ABORT",
                                          @":SENS:FUNC 'FRES'",
                                          @":SENS:FRES:NPLC 1",
                                          @":SENS:FRES:RANG 1000",
                                         ];
                NSLog(@"结束设置4线法测试电阻");
            }
                break;
                
            case Agilent34461A_MODE_RES_2W:
            {
                NSLog(@"开始设置2线法测试电阻");
                commandArray = @[
                                           @"*RST",
                                           @"*CLS",
                                           @"ABORT",
                                           @":SENS:FUNC 'RES'",
                                           @":SENS:RES:NPLC 1",
                                           @":SENS:RES:RANG 1000",
                                           ];
                NSLog(@"结束设置2线法测试电阻");
            }
                break;
                
            case Agilent34461A_MODE_DIODE:
            {

                commandArray = @[
                                           @"*RST",
                                           @"*CLS",
                                           @"ABORT",
                                           @"CONF:DIOD",
                                           ];
                NSLog(@"设置极性测试");
            }
                break;
                
            case Agilent34461A_MODE_CURR_DC:
            {
                commandArray = @[
                                           @"*RST",
                                           @"*CLS",
                                           @"ABORT",
                                           @":SENS:FUNC 'CURR:DC'",
                                           ];
                NSLog(@"设置直流电流");
            }
                break;
            case Agilent34461A_MODE_CURR_AC:
            {
                commandArray = @[
                                           @"*RST",
                                           @"*CLS",
                                           @"ABORT",
                                           @":SENS:FUNC 'CURR:AC'",
                                           @":SENS:CURR:AC:BANDwidth 20",
                                           ];
                NSLog(@"设置交流电流");
                
            }
                break;
            case Agilent34461A_MODE_VOLT_DC:
            {
                
                commandArray = @[
                                           @"*RST",
                                           @"*CLS",
                                           @"ABORT",
                                           @":SENS:FUNC 'VOLT:DC'",
                                           @":SENS:VOLT:DC:NPLC 1",
                                           @":SENS:VOLT:DC:RANG 10"
                                           ];
                NSLog(@"设置交流电流");
            }
                break;
            case Agilent34461A_MODE_VOLT_AC:
            {
                
                commandArray = @[
                                           @"*RST",
                                           @"*CLS",
                                           @"ABORT",
                                           @":SENS:FUNC 'VOLT:AC'",
                                           @":SENS:VOLT:AC:BANDwidth 20",
                                           @":SENS:VOLT:AC:RANG 10"
                                           ];
                NSLog(@"设置交流电压");
                
            }
                break;
                
            case Agilent34461A_MODE_CAP:
            {
                
                commandArray = @[
                                           @"*RST",
                                           @"*CLS",
                                           @"ABORT",
                                           @":SENS:FUNC 'CAP'",
                                           @":SENS:CAP:RANG:AUTO ON",
                                          ];
                NSLog(@"设置交流电压");
                
                
            }
                break;
                
            default:
                break;
        }
    }
    
    //发送测试的指令
    for (NSString  * command in commandArray)
    {
        [sysncSocket writeData:[[command stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:1 tag:1];
        usleep(50*1000);
        if ([command containsString:@"TRG"]) {
            usleep(500*1000);
        }
    }
}




//发送指令
-(void)uploadAgilentCommands:(NSArray *)commands
{
    //发送测试的指令
    for (NSString  * command in commands)
    {
        [sysncSocket writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:1 tag:1];
         usleep(50*1000);
        if ([command containsString:@"TRG"]) {
           usleep(500*1000);
        }
    }
  
}


//读取数据
-(void)readData
{
    if (agilentDeviceType == Agilent4980) {
        [NSThread sleepForTimeInterval:0.2];
        [sysncSocket writeData:[@":FETC?\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
        [NSThread sleepForTimeInterval:0.5];
    }
    else if (agilentDeviceType == Agilent2987) {
         [sysncSocket writeData:[@":MEAS:RES?\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
        [NSThread sleepForTimeInterval:0.5];
    }
    else if (agilentDeviceType == Agilent34461) {
        
        [sysncSocket writeData:[@"Read?\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
        [NSThread sleepForTimeInterval:0.5];
    }
    else{
        
        [sysncSocket writeData:[@"Read?\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
        [NSThread sleepForTimeInterval:0.5];
    }
}




-(BOOL)isCollect
{
    return sysncSocket.isConnected;
}


#pragma mark--------------GCDAsyncSocketDelegate

//连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Socket 已经连接成功");
    self.isCollect = sysncSocket.isConnected;
    
}


//已经断开网络
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"网络已经断开");

}


//读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString  *  str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"socket 读取数据中===================\n:%@===================\n",str);
    
//    //获取数据后，代理回调，将值付给testaction中的对象
//    
//    @try {
//        
//        NSLog(@"self.returnBlock=====================%@",self.returnBlock);
//        
//        if (self.returnBlock) {
//            
//            if (agilentDeviceType == Agilent4980) {
//                
//                self.returnBlock([[str componentsSeparatedByString:@","]objectAtIndex:0], agilentDeviceType);
//            }
//            else{
//                
//               self.returnBlock(str, agilentDeviceType);
//            }
//            
//        }
//
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"exception========%@",exception);
//    } @finally {
//        
//        
//    }
    
    
    @try {
        
        if ([self.delegate respondsToSelector:@selector(getValueFromAgilentValue:AgilentType:)]) {
            
            NSString  * str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (agilentDeviceType == Agilent4980) {
                
                [self.delegate getValueFromAgilentValue:[[str componentsSeparatedByString:@","]objectAtIndex:0] AgilentType:agilentDeviceType];
            }
            else{
                
                [self.delegate getValueFromAgilentValue:str AgilentType:agilentDeviceType];
            }
        }

    } @catch (NSException *exception) {
        
        NSLog(@"NSException:%@",exception);
    } @finally {
         [sysncSocket readDataWithTimeout:-1 tag:tag];
    }
    
   
}


-(void)releaseSocket
{
    if (sysncSocket.isConnected) {
        
        [sysncSocket disconnect];
    }
    sysncSocket = nil;
}


@end
