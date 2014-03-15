//
//  JMSPhotoMapViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/9/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoMapViewController.h"
#import "JMSPhotoDetailViewController.h"
#import "JMSPhotoData.h"

@import MapKit;

static NSString *const viewPhotoDetailSegue = @"viewPhotoDetail";

@interface JMSPhotoMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)MKPointAnnotation *locationPoint;
@end

@implementation JMSPhotoMapViewController
#pragma mark - View Controller Lifecycle
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
    self.mapView.delegate = self;
    
    CLLocation *location = self.photo.placemark.location;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0);
    [self.mapView setRegion:region animated:NO];
    
    self.locationPoint.title = self.photo.title;
    self.locationPoint.coordinate = location.coordinate;
    
    [self.mapView addAnnotation:self.locationPoint];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:viewPhotoDetailSegue]) {
        JMSPhotoDetailViewController *destination = (JMSPhotoDetailViewController *)segue.destinationViewController;
        destination.photo = self.photo;
    }
}

#pragma mark - Properties
- (MKPointAnnotation *)locationPoint
{
    if (!_locationPoint) {
        _locationPoint = [[MKPointAnnotation alloc] init];
    }
    return _locationPoint;
}

#pragma mark - Private
- (void)calloutButtonTapped
{
    [self performSegueWithIdentifier:viewPhotoDetailSegue sender:nil];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *annotationReuse = @"annotationPointReuse";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuse];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self.locationPoint reuseIdentifier:annotationReuse];
            annotationView.canShowCallout = YES;
        }
        
        UIButton *calloutButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [calloutButton addTarget:self
                          action:@selector(calloutButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = calloutButton;
        
        return annotationView;
    }
    return nil;
}
@end
