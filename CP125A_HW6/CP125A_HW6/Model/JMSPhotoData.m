//
//  JMSPhotoData.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoData.h"
@import MapKit.MKPlacemark;

static NSString *const photoKey = @"photo";
static NSString *const titleKey = @"title";
static NSString *const placemarkKey = @"placemark";

@implementation JMSPhotoData

#pragma mark - NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.photo forKey:photoKey];
    [aCoder encodeObject:self.title forKey:titleKey];
    [aCoder encodeObject:self.placemark forKey:placemarkKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.photo = [aDecoder decodeObjectOfClass:[UIImage class] forKey:photoKey];
        self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:titleKey];
        self.placemark = [aDecoder decodeObjectOfClass:[MKPlacemark class] forKey:placemarkKey];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
