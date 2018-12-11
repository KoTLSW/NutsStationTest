//
//  Param.m
//  BT_MIC_SPK
//
//  Created by h on 16/5/29.
//  Copyright © 2016年 h. All rights reserved.
//

#import "Param.h"

//=============================================
@implementation Param
//=============================================


- (void)ParamRead:(NSString*)filename
{
    //首先读取plist中的数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    self.station                = [dictionary objectForKey:@"station"];
    self.sw_name                = [dictionary objectForKey:@"sw_name"];
    self.sw_ver                 = [dictionary objectForKey:@"sw_ver"];
    
    
    //治具字典
    self.Fix1                  =[dictionary objectForKey:@"Fix1"];
    self.Fix2                  =[dictionary objectForKey:@"Fix2"];
    self.Fix3                  =[dictionary objectForKey:@"Fix3"];
    self.Fix4                  =[dictionary objectForKey:@"Fix4"];
    self.ServerFC              =[dictionary objectForKey:@"ServerFC"];
    self.Global                =[dictionary objectForKey:@"Global"];
    
    
    //Global 区域内容
    self.contollerBoard_uart_name = [self.Global objectForKey:@"contollerBoard_uart_name"];
    self.humiture_uart_port_name  = [self.Global objectForKey:@"humiture_uart_port_name"];
    self.led_uart_name            = [self.Global objectForKey:@"led_uart_name"];
    self.sw_ver  = [self.Global objectForKey:@"sw_ver"];
    self.sw_name = [self.Global objectForKey:@"sw_name"];
    self.isDebug = [[self.Global objectForKey:@"isDebug"] boolValue];
    
    

    
    
    NSLog(@"self.contollerBoard_uart_name=%@,self.isDebug=%hhd\n",self.contollerBoard_uart_name,self.isDebug);
    
}



//=============================================更改plist文件中的内容
-(void)ParamWrite:(NSString *)filename Content:(NSString *)content Key:(NSString *)key
{
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:filename ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    //添加内容
    [dictionary setObject:content forKey:key];
    [dictionary writeToFile:plistPath atomically:YES];
    
}


//=============================================更改plist文件中的内容
-(void)ParamWrite:(NSString *)filename Content:(NSString *)content Key:(NSString *)key SubKey:(NSString *)subkey
{
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:filename ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *subDic = [dictionary objectForKey:key];
    
    [subDic setObject:content forKey:subkey];
    [dictionary setObject:subDic forKey:key];
    [dictionary writeToFile:plistPath atomically:YES];
}

@end
//=============================================





