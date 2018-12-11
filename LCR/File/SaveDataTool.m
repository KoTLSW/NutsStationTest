//
//  SaveDataTool.m
//  BedDitTest
//
//  Created by linanlin  on 2017/8/11.
//  Copyright © 2017年 nanlin_li. All rights reserved.
//

#import "SaveDataTool.h"

static NSString *logString=@"";
static SaveDataTool *dataTool = nil;
@interface SaveDataTool(){
    
     
}

@property(nonatomic,strong) NSMutableArray * logList;


@end
@implementation SaveDataTool

+(instancetype)shareInstnce{
     
     if (dataTool == nil) {
          dataTool = [[self alloc]init];
     }
     
     return dataTool;
}

-(instancetype)init{
     if ([super init]) {
          
     }
     return self;
}


-(NSMutableArray*)logList{
     
     if(_logList == nil){
          _logList = [NSMutableArray array];
          
     }
     return _logList;
}


-(NSString *)getTestInfoTxtPath{
     
     
     
     
     NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
     
     
     
     NSString *path  =[NSString stringWithFormat:@"%@/SW_log/%@",documentsDirectory,[self getCurrentYEAR_Month_Day]] ;
     
     return path ;
     
}



-(void)saveTestInfoIntoTxt:(NSString *)testInfo SN:(NSString *)sn Path:(NSString *)path Collect:(BOOL)isCollect{
     
    testInfo=[NSString stringWithFormat:@"%@\n",testInfo];
    
    NSLog(@"打印Log日志的值:%@",testInfo);
    
    
     dispatch_async(dispatch_get_main_queue(), ^{
          //刷新界面，放在内存
          [self.logList addObject:testInfo];
         if ([self.delegate respondsToSelector:@selector(reloadLogViewWithLogList:Collect:)]) {
             [self.delegate reloadLogViewWithLogList:testInfo Collect:isCollect];
          }
          
     });
     
     
     //保存到硬盘->创建文件夹
     if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
          
          [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
     }
    
      NSString* FileStr=[NSString stringWithFormat:@"%@/%@.txt",path,sn];
      if (![[NSFileManager defaultManager] fileExistsAtPath:FileStr]) {
           [[NSFileManager defaultManager] createFileAtPath: FileStr contents:nil attributes:nil];
      }
      NSData *data;
      if ([testInfo isEqualToString:@""]) {
           
           data=[testInfo dataUsingEncoding:NSUTF8StringEncoding];
           
      }
      else
      {
           testInfo=[testInfo stringByAppendingString:testInfo];
           data=[testInfo dataUsingEncoding:NSUTF8StringEncoding];
           testInfo=@"";
      }
      //Write to the file
      NSFileHandle *fileWrite=[NSFileHandle fileHandleForUpdatingAtPath:FileStr];
      [fileWrite seekToEndOfFile];
      [fileWrite writeData:data];
      [fileWrite closeFile];
}



-(NSString *)getCurrentYEAR_Month_Day{
     NSDate *date=[NSDate date];
     NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
     [formatter setDateFormat:@"yyyy-MM-dd"];
     return  [formatter stringFromDate:date];
     
}

-(NSString *)getCurrentNow{
     NSDate *date=[NSDate date];
     NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
     [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     return  [formatter stringFromDate:date];
     
}


-(void)clearPreviousDutLoginfo{
     [self.logList removeAllObjects];
}


@end
