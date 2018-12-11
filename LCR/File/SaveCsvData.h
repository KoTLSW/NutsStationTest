//
//  SaveCsvData.h
//  LCR
//
//  Created by mac on 11/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveCsvData : NSObject

+(instancetype)shareInstnce;

//创建文件夹，以及文件
-(BOOL)createCsvPath:(NSString *)csvDirPath csvName:(NSString *)fileName csvFileHead:(NSString *)title;


//写入文件内容
-(void)WriteCsvConent:(NSString *)content;


@end
