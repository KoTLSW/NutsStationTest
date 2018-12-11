//
//  NSString+Extension.h
//  LCR
//
//  Created by mac on 24/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

-(NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

-(NSString *)addDeadLineString:(NSString *)deadlineString;
@end
