//
//  JMSPhotoData.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoData.h"

static NSString *const photoKey = @"photo";
static NSString *const titleKey = @"title";

@implementation JMSPhotoData

#pragma mark - NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.photo forKey:photoKey];
    [aCoder encodeObject:self.title forKey:titleKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.photo = [aDecoder decodeObjectOfClass:[UIImage class] forKey:photoKey];
        self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:titleKey];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
