//
//  JMSAddPhotoTableViewController.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/3/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKPlacemark;

@protocol JMSAddPhotoTVCDelegate;

@interface JMSAddPhotoTableViewController : UITableViewController
@property (strong, nonatomic)UIImage *photo;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)MKPlacemark *placemark;
@property (strong, nonatomic)NSURL *url;
@property (strong, nonatomic)NSString *phone;
@property (weak, nonatomic)id<JMSAddPhotoTVCDelegate>delegate;
@end

@protocol JMSAddPhotoTVCDelegate <NSObject>

- (void)addPhotoTableViewControllerDidCancel:(JMSAddPhotoTableViewController *)controller;
- (void)addPhotoTableViewControllerDidSave:(JMSAddPhotoTableViewController *)controller;

@end