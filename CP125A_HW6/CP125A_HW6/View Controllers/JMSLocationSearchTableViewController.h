//
//  JMSLocationSearchTableViewController.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/5/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKMapItem;

@protocol JMSLocationSelectionDelegate;

@interface JMSLocationSearchTableViewController : UITableViewController
@property (weak, nonatomic)id<JMSLocationSelectionDelegate>delegate;
@end

@protocol JMSLocationSelectionDelegate <NSObject>

- (void)locationSelectionDidCancel:(JMSLocationSearchTableViewController *)controller;
- (void)locationSelection:(JMSLocationSearchTableViewController *)controller didSelectLocation:(MKMapItem *)mapItem;

@end