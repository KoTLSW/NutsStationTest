//
//  Item.m
//  MKPlist_Sample
//
//  Created by Michael on 16/11/7.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)initWithItem:(Item *)item
{
    
    if (self == [super init])
    {
        self.id = item.id;
        self.retryTimes = item.retryTimes;
        self.testName = item.testName;
        self.testFailItems =item.testFailItems;
        self.max = item.max;
        self.min = item.min;
        self.isTest = item.isTest;
        self.isShow = item.isShow;
        self.messageError = item.messageError;
        self.value  = item.value ;
        self.result = item.result;
        self.testAllCommand = item.testAllCommand;
        self.units = item.units;
        self.freq = item.freq;
        
    }


    return [super init];
}

@end
