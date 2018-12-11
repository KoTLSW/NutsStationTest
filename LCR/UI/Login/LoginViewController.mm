//
//  LoginViewController.m
//  HowToWorks
//
//  Created by h on 17/3/28.
//  Copyright © 2017年 bill. All rights reserved.
//
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import "WindowController.h"

/*
    登陆的账户密码情况说明
    1.账号op，密码op123，  默认为PDCA和SFC均为上传模式
    2.admin,admin123     默认PDCA和SFC是可以进行选择的
    3.test,test123       设置为PDCA和SFC均不用上传
 
 
*/

@interface LoginViewController()<NSTextFieldDelegate>
{
    AppDelegate *appdelegate;
}

@property(weak) IBOutlet NSImageView *headImageView;

@end

@implementation LoginViewController
-(void)viewDidLoad{
    //隐藏菜单
    [NSMenu setMenuBarVisible:NO];
    [super viewDidLoad];
    [self initview];
    [ErrorMsg setStringValue:@""];
}
#pragma mark - 初始化视图
-(void)initview{
    
    //设置背景颜色
    UserName.delegate = self;
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    //头像圆边
    self.headImageView.wantsLayer = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width / 2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderWidth = 2;
    self.headImageView.layer.borderColor = [NSColor lightGrayColor].CGColor;
    
}


#pragma mark -  点击了登录Button
-(IBAction)loginButtonClicked:(NSButton *)sender{
   
    
    BOOL isLogin = NO;
    
    if ([[PassWord.stringValue lowercaseString] isEqualToString:@"op123"]&&
        [UserName.stringValue isEqualToString:@"op"]) {
    
        [[NSUserDefaults standardUserDefaults] setObject:@"PDCA_SFC" forKey:kPDCAandSFCNotification];
        isLogin = YES;
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    if ([[PassWord.stringValue lowercaseString] isEqualToString:@"min"]&&
        [UserName.stringValue isEqualToString:@"op"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"PDCA_SFC_MIN" forKey:kPDCAandSFCNotification];
        isLogin = YES;
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    if ([[PassWord.stringValue lowercaseString] isEqualToString:@"max"]&&
        [UserName.stringValue isEqualToString:@"op"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"PDCA_SFC_MAX" forKey:kPDCAandSFCNotification];
        isLogin = YES;
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    if ([[PassWord.stringValue lowercaseString] isEqualToString:@"all"]&&
        [UserName.stringValue isEqualToString:@"op"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"PDCA_SFC_ALL" forKey:kPDCAandSFCNotification];
        isLogin = YES;
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    else if ([[PassWord.stringValue lowercaseString] isEqualToString:@"admin123"]&&
              [UserName.stringValue isEqualToString:@"admin"])
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:[Choose_State_PopButton titleOfSelectedItem] forKey:kPDCAandSFCNotification];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isLogin = YES;
        
        
    }else if ([[PassWord.stringValue lowercaseString] isEqualToString:@"test123"]&&
              [[UserName.stringValue lowercaseString] isEqualToString:@"test"])
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NULL" forKey:kPDCAandSFCNotification];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isLogin = YES;
        
    }else{
        
        NSLog(@"输入有误，请重新输入");
        [ErrorMsg setStringValue:@"账号或者密码输入有误，请重新输入"];
    }

    
    if (isLogin) {
        
        //1.创建聊天界面窗口控制器
        WindowController * UIwinController = [WindowController windowController];
        //2.强应用这个Window,不然这个Window会在跳转之后ide瞬间被销毁
        appdelegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
        appdelegate.mainWindowController = UIwinController;
        //3.设为KeyWindow并前置
        [UIwinController.window makeKeyAndOrderFront:self];
        //4.关闭现在的登录窗口
        [self.view.window orderOut:self];
    }
}



#pragma mark-------------弹出选择框
-(void)controlTextDidChange:(NSNotification *)obj
{

     NSTextField *tf = (NSTextField *)obj.object;
    
    if ([tf.stringValue isEqualToString:@"admin"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            Choose_State_PopButton.hidden = NO;
        });
        
    }
    else{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            Choose_State_PopButton.hidden = YES;
        });
    }
    
}


#pragma mark - 关闭窗口
-(IBAction)closeWindow:(id)sender{
    exit(1);
}



@end
