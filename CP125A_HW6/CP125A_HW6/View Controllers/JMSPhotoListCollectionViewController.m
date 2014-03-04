//
//  JMSPhotoListCollectionViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoListCollectionViewController.h"
#import "JMSCollectionPhotoCell.h"
#import "JMSPhotoStore.h"
#import "JMSPhotoData.h"
#import "JMSNewPhotoTableViewController.h"
#import "JMSSlideUpTransitionAnimator.h"

@import MobileCoreServices;

static NSString *const photoCellReuse = @"photoCell";
static NSString *const addNewPhotoSegue = @"addNewPhoto";

@interface JMSPhotoListCollectionViewController () <UIActionSheetDelegate, JMSNewPhotoTVCDelegate, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic)JMSPhotoStore *photoStore;
@property (nonatomic)BOOL hasCamera;
@property (nonatomic)UIImagePickerControllerSourceType pickerSourceType;
@end

@implementation JMSPhotoListCollectionViewController
#pragma mark - Lifecycle
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
    
    self.hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:addNewPhotoSegue]) {
        UINavigationController *destinationNavigation = segue.destinationViewController;
        JMSNewPhotoTableViewController *destination = (JMSNewPhotoTableViewController *)destinationNavigation.topViewController;
        destination.imagePicker.sourceType = self.pickerSourceType;
        destination.delegate = self;
    }
}

#pragma mark - Properties
- (JMSPhotoStore *)photoStore
{
    if (!_photoStore) {
        _photoStore = [JMSPhotoStore sharedStore];
    }
    return _photoStore;
}

#pragma mark - IBActions
- (IBAction)cameraButtonTapped:(id)sender
{
    if (self.hasCamera) {
        UIActionSheet *whichCameraSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancel"
                                                        destructiveButtonTitle:nil
                                                             otherButtonTitles:@"Take Photo", @"Use Existing", nil];
        [whichCameraSheet showInView:self.view];
    } else {
        self.pickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self launchPhotoPicker];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoStore.photoArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMSCollectionPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellReuse forIndexPath:indexPath];
    
    JMSPhotoData *photo = [self.photoStore.photoArray objectAtIndex:indexPath.item];
    
    cell.imageView.image = photo.photo;
    cell.photoLabel.text = photo.title;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.pickerSourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.pickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self launchPhotoPicker];
}

#pragma mark - JMSNewPhotoTVCDelegate
- (void)newPhotoViewControllerDidCancel:(JMSNewPhotoTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newPhotoViewControllerDidSave:(JMSNewPhotoTableViewController *)controller
{
    JMSPhotoData *newPhoto = [self.photoStore addNewPictureToStoreWithImage:controller.photo title:controller.title];
    NSInteger index = [self.photoStore.photoArray indexOfObject:newPhoto];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[JMSSlideUpTransitionAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[JMSSlideUpTransitionAnimator alloc] init];
}


#pragma mark - Private
- (void)launchPhotoPicker
{
    JMSNewPhotoTableViewController *newPhotoTVC = [[JMSNewPhotoTableViewController alloc] init];
    newPhotoTVC.delegate = self;
    newPhotoTVC.imagePicker.sourceType = self.pickerSourceType;

    newPhotoTVC.imagePicker.navigationController.transitioningDelegate = self;
    
    [self presentViewController:newPhotoTVC.imagePicker.navigationController animated:YES completion:nil];
}

@end
