//
//  JMSPhotoStore.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMSPhotoData;

@interface JMSPhotoStore : NSObject <NSSecureCoding>

@property (strong, nonatomic)NSMutableArray *photoArray;

@end
