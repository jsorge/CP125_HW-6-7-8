//
//  JMSSettingsController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/15/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSSettingsController.h"

NSString *const SETTING_ADD_TO_CAMERA_ROLL = @"addToCameraRoll";
NSString *const SETTING_ENABLE_EDIT_MODE = @"enableEditMode";

@implementation JMSSettingsController
#pragma mark - API
+ (void)registerStandardDefaults;
{
    NSDictionary *standardDefaults = @{SETTING_ADD_TO_CAMERA_ROLL: @(YES), SETTING_ENABLE_EDIT_MODE: @(NO)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:standardDefaults];
}

+ (void)registerUserDefaultListener
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserverForName:NSUserDefaultsDidChangeNotification
                                    object:[NSUserDefaults standardUserDefaults]
                                     queue:[NSOperationQueue mainQueue]
                                usingBlock:^(NSNotification *note) {
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    NSLog(@"User Defaults changed to: %@", [NSUserDefaults standardUserDefaults]);
                                }];
}

+ (BOOL)autosaveToCameraRoll
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_ADD_TO_CAMERA_ROLL];
}

+ (BOOL)enableEditMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_ENABLE_EDIT_MODE];
}

@end
