//
//  JMSAddPhotoTableViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/3/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSAddPhotoTableViewController.h"
#import "JMSLocationSearchTableViewController.h"

@import MapKit.MKPlacemark;

static NSString *const locationSelectSegue = @"selectLocation";

@interface JMSAddPhotoTableViewController () <JMSLocationSelectionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@end

@implementation JMSAddPhotoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.photo;
}

#pragma mark - IBActions
- (IBAction)cancelButtonTapped:(id)sender
{
    [self.delegate addPhotoTableViewControllerDidCancel:self];
}

- (IBAction)doneButtonTapped:(id)sender
{
    self.title = self.titleTextField.text;
    [self.delegate addPhotoTableViewControllerDidSave:self];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    if (indexPath.row == 0) {
        [self.titleTextField becomeFirstResponder];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:locationSelectSegue sender:nil];
    }
}

#pragma mark - JMSLocationSelectionDelegate
- (void)locationSelectionDidCancel:(JMSLocationSearchTableViewController *)controller
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)locationSelection:(JMSLocationSearchTableViewController *)controller didSelectLocation:(MKPlacemark *)placemark
{
    self.placemark = placemark;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
