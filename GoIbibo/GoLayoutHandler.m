//
//  GoLayoutHandler.m
//  GoIbibo
//
//  Created by Sachin Vas on 9/22/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoLayoutHandler.h"
#import "GoHomeViewController.h"
#import "GoSettingsViewController.h"

@implementation GoLayoutHandler

+ (GoLayoutHandler *)sharedInstance {
    static dispatch_once_t onceToken;
    static GoLayoutHandler *goLayoutHandler;
    dispatch_once(&onceToken, ^{
        goLayoutHandler = [[GoLayoutHandler alloc] init];
    });
    return goLayoutHandler;
}

- (RESideMenu *)sideMenu {
    if (!_sideMenu) {
        GoHomeViewController *homeScreen = [[GoHomeViewController alloc] initWithNibName:@"GoHomeViewController" bundle:nil];
        UINavigationController *navigationVC = [[UINavigationController alloc] init];
        GoSettingsViewController *settingsView = [[GoSettingsViewController alloc] initWithNibName:@"GoSettingsViewController" bundle:nil];
        _sideMenu = [[RESideMenu alloc] initWithContentViewController:navigationVC leftMenuViewController:settingsView rightMenuViewController:nil];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"background-blurred"] ofType:@"jpg"];
        UIImage *theImage = [UIImage imageWithContentsOfFile:filePath];
        _sideMenu.backgroundImage = theImage;
        _sideMenu.contentViewInPortraitOffsetCenterX = -50;
        Digits *digits = [Digits sharedInstance];
        [digits authenticateWithNavigationViewController:navigationVC phoneNumber:@"+91" digitsAppearance:nil title:nil completionViewController:homeScreen];
    }
    return _sideMenu;
}

@end
