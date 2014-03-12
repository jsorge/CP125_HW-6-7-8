//
//  JMSPhotoDetailTableViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoDetailTableViewController.h"
#import "JMSPhotoData.h"

@import AddressBookUI;
@import MapKit.MKPlacemark;

@interface JMSPhotoDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end

@implementation JMSPhotoDetailTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addressLabel.numberOfLines = 4;
    
    self.urlLabel.text = [NSString stringWithFormat:@"%@", self.photo.url];
    self.phoneLabel.text = self.photo.phone;
    self.addressLabel.text = ABCreateStringWithAddressDictionary(self.photo.placemark.addressDictionary, NO);
}
@end
