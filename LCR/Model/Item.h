//
//  Item.h
//  MKPlist_Sample
//
//  Created by Michael on 16/11/7.
//  Copyright © 2016年 Michael. All rights reserved.
//


/**
 * table.xib文件 的 column identifier 项
 * 测试项
 */
//=============================================
//与table.xib 的 column identifier 对应
#define TABLE_COLUMN_ID               @"id"
//#define TABLE_COLUMN_RETRYTIMES     @"retryTimes"
#define TABLE_COLUMN_TESTNAME         @"testName"
#define TABLE_COLUMN_UNITS            @"units"
#define TABLE_COLUMN_MIN              @"min"
#define TABLE_COLUMN_MAX              @"max"
#define TABLE_COLUMN_FREQ             @"freq"
#define TABLE_COLUMN_VALUE          @"value"
#define TABLE_COLUMN_RESULT         @"result"




//#define TABLE_COLUMN_ISTEST         @"isTest"
//=============================================

#import <Foundation/Foundation.h>

@interface Item : NSObject

/**
 * table.m文件 的 model项
 * 测试项
 */
//=============================================
//在这里设置 table delegate 方法里边的数据模型
@property(readwrite,copy) NSString *id;
@property(readwrite,copy) NSNumber  * retryTimes;
@property(readwrite,copy) NSString  * testName;
@property(readwrite,copy) NSString  * units;
@property(readwrite,copy) NSString  * min;
@property(readwrite,copy) NSString  * max;
@property(nonatomic,strong)NSString * startTime;
@property(nonatomic,strong)NSString * endTime;
@property(nonatomic,strong)NSString * freq;


@property(nonatomic,strong)NSString * value;
@property(readwrite,copy)  NSString * result;

@property(readwrite)       BOOL        isTest;
@property(readwrite)       BOOL        isShow;
@property(nonatomic,strong)NSString *   messageError;

@property(nonatomic,strong)NSString  *   testFailItems;

@property(readwrite,copy)NSArray     *    testAllCommand;


-(id)initWithItem:(Item *)item;

@end
