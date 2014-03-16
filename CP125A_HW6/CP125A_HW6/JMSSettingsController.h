//
//  JMSSettingsController.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/15/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSSettingsController : NSObject
#pragma mark - API
+ (void)registerStandardDefaults;
+ (void)registerUserDefaultListener;
+ (BOOL)autosaveToCameraRoll;
+ (BOOL)enableEditMode;
@end
