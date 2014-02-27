//
//  JMSPhotoStore.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoStore.h"
#import "JMSPhotoData.h"

static NSString *const photoArrayKey = @"photoArray";

@implementation JMSPhotoStore

#pragma mark - API
+ (instancetype)sharedStore
{
    static JMSPhotoStore *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[JMSPhotoStore alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.photoArray forKey:photoArrayKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.photoArray = [aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:photoArrayKey];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end