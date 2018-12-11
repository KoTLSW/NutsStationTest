//
//  AppDelegate.m
//  LCR
//
//  Created by mac on 04/10/2018.
//  Copyright © 2018 piaoxu. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
    
    
    
    NSLog(@"jfdkdjkafklklaljkfjlkdajklflkjajklfjklalkfjlkajklflk");
}


- (void)applicationDidChangeScreenParameters:(NSNotification *)notification
{
    //NSApplicationDidChangeScreenParametersNotification


    NSLog(@"打印当前的值notification=%@",notification.userInfo);

}



@end
