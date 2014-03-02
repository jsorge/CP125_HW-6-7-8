//
//  JMSNewPhotoTableViewController.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/1/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JMSNewPhotoTVCDelegate;

@interface JMSNewPhotoTableViewController : UITableViewController

@property (strong, nonatomic)UIImage *photo;
@property (strong, nonatomic)NSString *title;
@property (weak, nonatomic)id<JMSNewPhotoTVCDelegate>delegate;
@property (strong, nonatomic)UIImagePickerController *imagePicker;

@end

@protocol JMSNewPhotoTVCDelegate <NSObject>

- (void)newPhotoViewControllerDidCancel:(JMSNewPhotoTableViewController *)controller;
- (void)newPhotoViewControllerDidSave:(JMSNewPhotoTableViewController *)controller;

@end
