//
//  JMSPhotoData.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoData.h"
@import MapKit.MKMapItem;

static NSString *const photoKey = @"photo";
static NSString *const titleKey = @"title";
static NSString *const placemarkKey = @"placemark";
static NSString *const urlKey = @"url";
static NSString *const phoneKey = @"phone";

@implementation JMSPhotoData

#pragma mark - NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.photo forKey:photoKey];
    [aCoder encodeObject:self.title forKey:titleKey];
    [aCoder encodeObject:self.placemark forKey:placemarkKey];
    [aCoder encodeObject:self.url forKey:urlKey];
    [aCoder encodeObject:self.phone forKey:phoneKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.photo = [aDecoder decodeObjectForKey:photoKey];
        self.title = [aDecoder decodeObjectForKey:titleKey];
        self.placemark = [aDecoder decodeObjectForKey:placemarkKey];
        self.url = [aDecoder decodeObjectForKey:urlKey];
        self.phone = [aDecoder decodeObjectForKey:phoneKey];
    }
    return self;
}

@end
