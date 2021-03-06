//
//  JMSLocationSearchTableViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/5/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSLocationSearchTableViewController.h"
@import MapKit;
@import CoreLocation;

static NSString *const locationCellID = @"locationCell";

@interface JMSLocationSearchTableViewController () <UISearchBarDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic)NSArray *searchResults;
@property (strong, nonatomic)MKLocalSearch *localSearch;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)UIActivityIndicatorView *activityIndicator;
@property (nonatomic)BOOL canUseLocation;
@end

@implementation JMSLocationSearchTableViewController
#pragma mark - View Lifecycle
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
    
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.localSearch.isSearching) {
        [self.localSearch cancel];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.canUseLocation) {
        [self showAlertWithMessage:nil];
        [self.delegate locationSelectionDidCancel:self];
    }
}

#pragma mark - Properties
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = 1000.0;
    }
    return _locationManager;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicator;
}

- (BOOL)canUseLocation
{
    if (!_canUseLocation) {
        BOOL locationIsEnabled = [CLLocationManager locationServicesEnabled];
        BOOL locationIsAvailable = (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) ||
                                    ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined));
        _canUseLocation = locationIsEnabled && locationIsAvailable;
    }
    return _canUseLocation;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCellID forIndexPath:indexPath];
    
    MKMapItem *mapItem = self.searchResults[indexPath.row];
    cell.textLabel.text = mapItem.name;
    cell.detailTextLabel.text = mapItem.phoneNumber;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKMapItem *selectedLocation = self.searchResults[indexPath.row];
    [self.delegate locationSelection:self didSelectLocation:selectedLocation];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.tableView.backgroundView = self.activityIndicator;
    [self.activityIndicator startAnimating];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation *mostRecentLocation = [locations lastObject];
    
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    searchRequest.naturalLanguageQuery = self.searchBar.text;
    searchRequest.region = MKCoordinateRegionMakeWithDistance(mostRecentLocation.coordinate, 1000.0, 1000.0);
    
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!response) {
            NSLog(@"Error: %@", error);
            [self showAlertWithMessage:[NSString stringWithFormat:@"There was a search error: %@", error.localizedDescription]];
            return;
        }
        
        self.searchResults = response.mapItems;
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        [self showAlertWithMessage:nil];
        
        if (self.localSearch.searching) {
            [self.activityIndicator stopAnimating];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Private
- (void)showAlertWithMessage:(NSString *)message
{
    if (!message) {
        message = @"Location is not available. Please check to make sure your settings are correct and you have permission to use location features.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    [alert show];
}
@end