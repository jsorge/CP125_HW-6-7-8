//
//  JMSAppDelegate.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSAppDelegate.h"
#import "JMSSettingsController.h"
#import "JMSPhotoListCollectionViewController.h"

static NSString *const URL_NUCLEAR = @"nuclear";
static NSString *const URL_ADD_FROM_URL = @"addFromURL";

@implementation JMSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [JMSSettingsController registerStandardDefaults];
    [JMSSettingsController registerUserDefaultListener];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    if ([components.host isEqualToString:URL_NUCLEAR]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NUCLEAR object:nil];
        return YES;
    } else if ([components.host isEqualToString:URL_ADD_FROM_URL]) {
        NSURL *imageURL = [NSURL URLWithString:components.query];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_FROM_URL object:nil userInfo:@{@"imageURL": imageURL}];
        return YES;
    }
    
    return NO;
}
@end
