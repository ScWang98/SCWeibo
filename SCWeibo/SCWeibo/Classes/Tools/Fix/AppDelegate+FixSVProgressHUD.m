//
//  AppDelegate+FixSVProgressHUD.m
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/23.
//

#import "AppDelegate+FixSVProgressHUD.h"

@implementation AppDelegate (FixSVProgressHUD)

- (UIWindow *)window {
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        if (window.keyWindow) {
            return window;
        }
    }
    return nil;
}

@end
