//
//  Piao_ZipArchive.m
//  LCR
//
//  Created by mac on 16/11/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import "Piao_ZipArchive.h"

@implementation Piao_ZipArchive

+(void)createZipFile:(NSString *)DirName PreviousFolderPath:(NSString *)Path isRemove:(BOOL)isRemove;
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    
    NSString   * cmd;
    
    if (isRemove) {
        cmd = [NSString stringWithFormat:@"cd %@; zip -rm %@.zip %@",Path,DirName,DirName];
    }else{
        cmd = [NSString stringWithFormat:@"cd %@; zip -r %@.zip %@",Path,DirName,DirName];
    }
    
    NSArray    * argument = [NSArray arrayWithObjects:@"-c", [NSString stringWithFormat:@"%@", cmd], nil];
    [task setArguments: argument];
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    [task launch];
    
    
    //获取压缩文件的具体地址
    NSString *ZIP_path = [NSString stringWithFormat:@"%@/%@.zip",Path,DirName];
    sleep(1);
    int FileCount = 0;
    while (true) {
        if([[NSFileManager defaultManager] fileExistsAtPath:ZIP_path]){
            NSLog(@"file has been existed");
            break;
        }
        else
        {
            NSLog(@"file has been not existed");
            FileCount++;
            sleep(0.5);
            if (FileCount>=3) {
                break;
            }
        }
    }
}

@end
