//
//  Piao_ZipArchive.h
//  LCR
//
//  Created by mac on 16/11/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Piao_ZipArchive : NSObject

/*
       DirName : 文件夹的名称（不包括路径）
       Path    : 前面文件夹的路径
       isMove  : 生成ZIP文件时，源文件是否删除   
                 是---> 源文件删除
                 否---> 源文件不删除
 */
+(void)createZipFile:(NSString *)DirName PreviousFolderPath:(NSString *)Path isRemove:(BOOL)isRemove;

@end
