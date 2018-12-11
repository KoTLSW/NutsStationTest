//
//  Calculate.h
//  NewFramework
//
//  Created by mac on 30/08/2018.
//  Copyright © 2018 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

enum MyTypeEnum{
     CURRType,
     VOLTType,
     RESISType,
     CAPAType
};

@interface Calculate : NSObject

-(double)addNum;

//数据处理
-(NSString *)calculateTestItem:(Item *)Item TestValue:(double)testNum;

//结果判断
-(BOOL)JuageResultupperLimit:(NSString *)upperLimit  LowerLimit:(NSString *)lowerLimit  TestVaule:(NSString *)testValue;



@end
