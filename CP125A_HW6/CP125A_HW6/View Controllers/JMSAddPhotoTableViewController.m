//
//  JMSAddPhotoTableViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/3/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSAddPhotoTableViewController.h"
#import "JMSLocationSearchTableViewController.h"

@import MapKit.MKMapItem;

static NSString *const locationSelectSegue = @"selectLocation";
static NSString *const locationSelectTVC = @"locationSearchTVC";

@interface JMSAddPhotoTableViewController () <JMSLocationSelectionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@end

@implementation JMSAddPhotoTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.photo;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.title) {
        self.locationNameLabel.text = self.title;
    }
}

#pragma mark - IBActions
- (IBAction)cancelButtonTapped:(id)sender
{
    [self.delegate addPhotoTableViewControllerDidCancel:self];
}

- (IBAction)doneButtonTapped:(id)sender
{
    [self.delegate addPhotoTableViewControllerDidSave:self];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    if (indexPath.row == 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        JMSLocationSearchTableViewController *destination = [mainStoryboard instantiateViewControllerWithIdentifier:locationSelectTVC];
        destination.delegate = self;
        [self.navigationController pushViewController:destination animated:YES];
    }
}

#pragma mark - JMSLocationSelectionDelegate
- (void)locationSelectionDidCancel:(JMSLocationSearchTableViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationSelection:(JMSLocationSearchTableViewController *)controller didSelectLocation:(MKMapItem *)mapItem
{
    self.placemark = mapItem.placemark;
    self.title = mapItem.name;
    self.url = mapItem.url;
    self.phone = mapItem.phoneNumber;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
