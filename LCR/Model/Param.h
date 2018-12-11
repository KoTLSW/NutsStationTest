//
//  Param.h
//  BT_MIC_SPK
//
//  Created by h on 16/5/29.
//  Copyright © 2016年 h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Param : NSObject
//=============================================
@property(nonatomic,strong)NSDictionary  * Fix1;
@property(nonatomic,strong)NSDictionary  * Fix2;
@property(nonatomic,strong)NSDictionary  * Fix3;
@property(nonatomic,strong)NSDictionary  * Fix4;
@property(nonatomic,strong)NSDictionary  * ServerFC;
@property(nonatomic,strong)NSDictionary  * Global;


//接收的公共属性
@property(nonatomic,strong)NSString      * Freq;
@property(nonatomic,strong)NSString      * contollerBoard_uart_name;
@property(nonatomic,strong)NSString      * led_uart_name;
@property(nonatomic,strong)NSString      * humiture_uart_port_name;
@property(nonatomic,strong)NSString      * sw_name;
@property(nonatomic,strong)NSString      * sw_ver;
@property(nonatomic,strong)NSString      * station;
@property(nonatomic,strong)NSString      * stationID;
@property(nonatomic,strong)NSString      * fixtureID;
@property(nonatomic,assign)BOOL            isDebug;

//=============================================
- (void)ParamRead:(NSString*)filename;
-(void)ParamWrite:(NSString *)filename Content:(NSString *)content Key:(NSString *)key;
-(void)ParamWrite:(NSString *)filename Content:(NSString *)content Key:(NSString *)key SubKey:(NSString *)subkey;
//- (void)TmConfigWrite:(NSString *)filename Content:(NSString *)content Key:(NSString *)key;
//=============================================
@end
