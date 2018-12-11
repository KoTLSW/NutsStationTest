//
//  NSString+Extension.m
//  LCR
//
//  Created by mac on 24/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    
    NSString *str;
    
    @try {
        
        startString = [NSString stringWithFormat:@"%@%@",startString,@" "];
        NSRange startRange = [self rangeOfString:startString];
        NSRange endRange = [self rangeOfString:endString];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        str = [self substringWithRange:range];
        [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        
    } @catch (NSException *exception) {
        
        NSLog(@"NSException==%@",exception);
        
    } @finally {
        
         return str;
    }
}


-(NSString *)addDeadLineString:(NSString *)deadlineString
{
    return [NSString stringWithFormat:@"%@%@",self,deadlineString];
}

@end
