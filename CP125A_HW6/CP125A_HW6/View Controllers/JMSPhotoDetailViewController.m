//
//  JMSPhotoDetailViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoDetailViewController.h"
#import "JMSPhotoDetailTableViewController.h"
#import "JMSPhotoData.h"

static NSString *const embedTableSegue = @"embedTableDetails";

@interface JMSPhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation JMSPhotoDetailViewController
#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = self.photo.photo;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:embedTableSegue]) {
        JMSPhotoDetailTableViewController *destination = (JMSPhotoDetailTableViewController *)segue.destinationViewController;
        destination.photo = self.photo;
    }
}

@end