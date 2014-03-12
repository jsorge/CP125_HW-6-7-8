//
//  JMSPhotoDetailViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/9/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoDetailViewController.h"
#import "JMSPhotoData.h"

@import MapKit;

@interface JMSPhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation JMSPhotoDetailViewController
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
    [self.mapView addAnnotation:self.photo.placemark];
}
@end
