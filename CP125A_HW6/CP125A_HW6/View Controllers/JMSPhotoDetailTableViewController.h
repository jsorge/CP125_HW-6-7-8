//
//  JMSPhotoDetailTableViewController.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSPhotoData;

@interface JMSPhotoDetailTableViewController : UITableViewController
@property (strong, nonatomic)JMSPhotoData *photo;
@end
