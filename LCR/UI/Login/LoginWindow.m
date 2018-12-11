//
//  LoginWindow.m
//  HowToWorks
//
//  Created by h on 17/3/28.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "LoginWindow.h"

@interface LoginWindow()<NSWindowDelegate>

@end
@implementation LoginWindow

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if (self) {
        //有阴影
        [self setHasShadow:YES];
        //设置窗口为透明
        [self setOpaque:NO];
        //设置背景无色
        [self setBackgroundColor:[NSColor clearColor]];
        //设置点击背景可以移动窗口
        [self setMovableByWindowBackground:YES];
        
        self.delegate = self;
    }
    return self;
}

-(void)setContentView:(__kindof NSView *)contentView{
    //需要layer
    contentView.wantsLayer = YES;
    contentView.layer.frame = contentView.frame;
    contentView.layer.cornerRadius = 5.0;
    contentView.layer.masksToBounds = YES;
    
    [super setContentView:contentView];
}

//不加上这段代码，窗口无法响应
-(BOOL)canBecomeKeyWindow{
    return YES;
}
-(BOOL)canBecomeMainWindow{
    return YES;
}

-(void)windowShouldClose{
    
    NSLog(@"fkdjkafjjakfjkldklajfa");
}
//
//
//@protocol NSWindowDelegate <NSObject>
//@optional
//- (BOOL)windowShouldClose:(id)sender;
//- (nullable id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(nullable id)client;
//- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize;
//- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame;
//- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame;
//- (nullable NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window;


@end
