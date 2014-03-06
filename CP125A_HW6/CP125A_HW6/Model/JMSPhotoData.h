//
//  JMSPhotoData.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MKPlacemark;

@interface JMSPhotoData : NSObject <NSSecureCoding>

@property (strong, nonatomic)UIImage *photo;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)MKPlacemark *placemark;

@end
