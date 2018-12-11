//
//  Calculate.m
//  NewFramework
//
//  Created by mac on 30/08/2018.
//  Copyright © 2018 mac. All rights reserved.
//

#import "Calculate.h"

@implementation Calculate

-(double)addNum
{
    NSLog(@"22222222222222");
    
    return 30;
}





#pragma mark--------根据单位显示各项的值
-(NSString *)calculateTestItem:(Item *)Item TestValue:(double)testNum
{
    NSString * numString = @"";
    
    if ([Item.testName isEqualToString:@"AAAAAAAA"]) {
        
        //根据每项的实际情况去计算
        
        numString = [self showUnit:@"V" withType:VOLTType withValue:testNum];
    }
    else if ([Item.testName isEqualToString:@"BBBBBBBB"])
    {
        //根据每项的实际情况去计算
        
        numString = [self showUnit:@"mΩ" withType:RESISType withValue:testNum];
    }
    else if ([Item.testName isEqualToString:@"CCCCCCCC"])
    {
        //根据每项的实际情况去计算
        
        numString = [self showUnit:@"mA" withType:CURRType withValue:testNum];
    }
    else if([Item.testName isEqualToString:@"DDDDDDDD"])
    {
        //根据每项的实际情况去计算
       
        numString = [self showUnit:@"CP" withType:CAPAType withValue:testNum];
    }
    else
    {
        //根据每项的实际情况去计算
        
        numString = [NSString stringWithFormat:@"%f",testNum];
        
    }
    
    return numString;
}



//单位换算
-(NSString *)showUnit:(NSString *)Unit withType:(enum MyTypeEnum)type  withValue:(double)num
{
    double value = 0.0;
    if (type == CURRType) {
        if ([Unit isEqualToString:@"nA"]) {
            value = num*1E9;
        }
        else if ([Unit isEqualToString:@"uA"]) {
            value = num*1E6;
        }
        else if ([Unit isEqualToString:@"mA"])
        {
            value = num*1E3;
        }
        else
        {
            value = num;
        }
    }
    else if (type == VOLTType) {
        
        if ([Unit isEqualToString:@"mV"]) {
            
            value = num *1E3;
        }
        else
        {
            value = num;
        }
        
    }
    else if (type == RESISType) {
        
        if ([Unit isEqualToString:@"mΩ"]) {
            value = num*1E3;
        }
        else if ([Unit isEqualToString:@"Ω"])
        {
            value = value;
        }
        else if ([Unit isEqualToString:@"kΩ"])
        {
            value = value*1E-3;
        }
        else if ([Unit isEqualToString:@"MΩ"])
        {
            value = value*1E-6;
        }
        else if ([Unit isEqualToString:@"GΩ"])
        {
            value = value*1E-9;
        }
        else
        {
        
        }
    }
    else
    {
        
    }
    

    return [NSString stringWithFormat:@"%.3f",value];
}



//判断结果
-(BOOL)JuageResultupperLimit:(NSString *)upperLimit LowerLimit:(NSString *)lowerLimit TestVaule:(NSString *)testValue
{
    
    if (([testValue floatValue]>[lowerLimit floatValue]&&[testValue floatValue]<=[upperLimit floatValue]) || ([upperLimit isEqualToString:@"--"]&&[testValue floatValue]>=[lowerLimit floatValue]) || ([upperLimit isEqualToString:@"--"] && [lowerLimit isEqualToString:@"--"]) || ([lowerLimit isEqualToString:@"--"]&&[testValue floatValue]<=[upperLimit floatValue])) {
        
        return YES;
    }
    else
    {
        return NO;
    
    }
}


@end

