//
//  SaveDataTool.h
//  BedDitTest
//
//  Created by linanlin on 2017/8/11.
//  Copyright © 2017年 nanlin_li. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SaveLoginfo(str,sn,path) [[[SaveDataTool alloc]init] saveTestInfoIntoTxt:str SN:sn Path:path];  //save in txt;

@protocol SaveDataToolDelegate <NSObject>
@optional

/*
 代理方法用于刷新界面的 log tableview
 
 */

-(void)reloadLogViewWithLogList:(NSString*)logStr Collect:(BOOL)isCollect;

@end

@interface SaveDataTool : NSObject


+(instancetype)shareInstnce;


@property(nonatomic,weak) id<SaveDataToolDelegate> delegate;

/*
   save test log.
   @param testInfo 需要保存的测试log信息。
   @param sn  当前的Log信息对应的哪个SN。

*/
-(void)saveTestInfoIntoTxt:(NSString *)testInfo SN:(NSString *)sn Path:(NSString *)path Collect:(BOOL)isCollect;

/*
  清除上一个测试物品的 log 信息
 
 */

-(void)clearPreviousDutLoginfo;

@end
