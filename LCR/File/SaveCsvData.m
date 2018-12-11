//
//  SaveCsvData.m
//  LCR
//
//  Created by mac on 11/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import "SaveCsvData.h"


static SaveCsvData *csvTool = nil;
@interface SaveCsvData()
{
    NSString  *  dirPath;
    NSString  *  filePath;
}
@end

@implementation SaveCsvData



+(instancetype)shareInstnce{
    
    if (csvTool == nil) {
        csvTool = [[self alloc]init];
    }
    
    return csvTool;
}

-(BOOL)createCsvPath:(NSString *)csvDirPath csvName:(NSString *)fileName csvFileHead:(NSString *)title
{
    
    NSFileManager  * fileManger = [[NSFileManager alloc]init];
    
    NSError  * error ;
    //判断文件夹
    if (![fileManger fileExistsAtPath:csvDirPath]) {
        
        if (![fileManger createDirectoryAtPath:csvDirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"文件夹:%@ 创建失败",csvDirPath);
            return NO;
        };
    }
    //判断文件
    filePath = [NSString stringWithFormat:@"%@/%@.csv",csvDirPath,fileName];
    
    
    if (![fileManger fileExistsAtPath:filePath]) {
        
        if (![fileManger createFileAtPath:filePath contents:[title dataUsingEncoding:NSUTF8StringEncoding] attributes:nil])
        {
            NSLog(@"文件:%@ 创建失败",filePath);
            return NO;
        }
    }

    
    return YES;

}


-(void)WriteCsvConent:(NSString *)content
{
    
    NSLog(@"打印当前的文件:%@",filePath);
    
    NSFileHandle *fileWrite=[NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileWrite seekToEndOfFile];
    [fileWrite writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [fileWrite closeFile];
}


@end
