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
#import "JMSAddPhotoTableViewController.h"
#import "JMSSlideUpTransitionAnimator.h"
#import "JMSSlideDownTransitionAnimator.h"
#import "JMSPhotoMapViewController.h"
#import "JMSSettingsController.h"

@import MobileCoreServices;
@import MapKit;

static NSString *const photoCellReuse = @"photoCell";
static NSString *const addNewPhotoSegue = @"addNewPhoto";
static NSString *const photoDetailSegue = @"viewPhotoMap";
NSString *const NOTIFICATION_NUCLEAR = @"nuclearNotificationKey";
NSString *const NOTIFICATION_ADD_FROM_URL = @"addPhotoFromURLNotificationKey";

@interface JMSPhotoListCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, JMSAddPhotoTVCDelegate, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic)JMSPhotoStore *photoStore;
@property (strong, nonatomic)UIImagePickerController *imagePicker;
@property (nonatomic)BOOL hasCamera;
@property (strong, nonatomic)UIActionSheet *nuclearSheet;
@property (strong, nonatomic)UIActionSheet *imagePickerSheet;
@end

@implementation JMSPhotoListCollectionViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteAllPhotoDataNotification)
                                                 name:NOTIFICATION_NUCLEAR
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addPhotoFromURLNotification:)
                                                 name:NOTIFICATION_ADD_FROM_URL
                                               object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:addNewPhotoSegue]) {
        NSAssert([sender isKindOfClass:[UIImage class]], @"The %@ segue must send an image.", addNewPhotoSegue);
        UINavigationController *destination = segue.destinationViewController;
        JMSAddPhotoTableViewController *addViewController = (JMSAddPhotoTableViewController *)destination.topViewController;
        addViewController.delegate = self;
        addViewController.photo = sender;
        destination.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    } else if ([segue.identifier isEqualToString:photoDetailSegue]) {
        NSAssert([sender isKindOfClass:[JMSPhotoData class]], @"%@ segue must send a PhotoData object", photoDetailSegue);
        JMSPhotoMapViewController *destination = (JMSPhotoMapViewController *)segue.destinationViewController;
        destination.photo = sender;
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

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.transitioningDelegate = self;
    }
    return _imagePicker;
}

- (UIActionSheet *)nuclearSheet
{
    if (!_nuclearSheet) {
        _nuclearSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete all photos? This can't be undone"
                                                    delegate:self
                                           cancelButtonTitle:@"No"
                                      destructiveButtonTitle:@"Yes"
                                           otherButtonTitles:nil];
    }
    return _nuclearSheet;
}

- (UIActionSheet *)imagePickerSheet
{
    if (!_imagePickerSheet) {
        _imagePickerSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take Photo", @"Use Existing", nil];
    }
    return _imagePickerSheet;
}

#pragma mark - IBActions
- (IBAction)cameraButtonTapped:(id)sender
{
    if (self.hasCamera) {
        [self.imagePickerSheet showInView:self.view];
    } else {
        [self showImagePickerViewWithType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    JMSPhotoData *photo = self.photoStore.photoArray[indexPath.row];
    [self performSegueWithIdentifier:photoDetailSegue sender:photo];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    if (!pickedImage) {
        pickedImage = info[UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:addNewPhotoSegue sender:pickedImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.imagePickerSheet) {
        if (buttonIndex == 0) {
            //Camera
            [self showImagePickerViewWithType:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 1) {
            //Photo Library
            [self showImagePickerViewWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    } else if (actionSheet == self.nuclearSheet) {
        if (buttonIndex == 0) {
            NSInteger totalPhotos = [[self.photoStore photoArray] count];
            [self.photoStore deleteAllPhotos];
            [self.collectionView performBatchUpdates:^{
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (NSInteger i = 0; i < totalPhotos; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
                [self.collectionView deleteItemsAtIndexPaths:indexPaths];
            } completion:nil];
        }
    }
}

#pragma mark - JMSAddPhotoTVCDelegate
- (void)addPhotoTableViewControllerDidCancel:(JMSAddPhotoTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPhotoTableViewControllerDidSave:(JMSAddPhotoTableViewController *)controller
{
    UIImage *image = controller.photo;
    NSString *title = controller.title;
    MKPlacemark *placemark = controller.placemark;
    NSURL *url = controller.url;
    NSString *phone = controller.phone;
    
    if ([JMSSettingsController autosaveToCameraRoll]) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    JMSPhotoData *newPhoto = [self.photoStore addNewPictureToStoreWithImage:image title:title placemark:placemark url:url phone:phone];
    
    NSInteger index = [self.photoStore.photoArray indexOfObject:newPhoto];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    return [[JMSSlideUpTransitionAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
{
    return [[JMSSlideDownTransitionAnimator alloc] init];
}

#pragma mark - Private
- (void)showImagePickerViewWithType:(UIImagePickerControllerSourceType)sourceType
{
    if ([JMSSettingsController enableEditMode]) {
        self.imagePicker.allowsEditing = YES;
    } else {
        self.imagePicker.allowsEditing = NO;
    }
    self.imagePicker.sourceType = sourceType;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)deleteAllPhotoDataNotification
{
    if (self.navigationController.visibleViewController == self) {
        [self.nuclearSheet showInView:self.view];
    } else {
        if ([self.presentedViewController isKindOfClass:[UIImagePickerController class]] || [self.presentedViewController isKindOfClass:[UINavigationController class]]) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.nuclearSheet showInView:self.view];
            }];
        } else {
            [UIView transitionWithView:self.navigationController.visibleViewController.view
                              duration:0.75
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } completion:^(BOOL finished) {
                                [self.navigationController setViewControllers:@[self]];
                                [self.nuclearSheet showInView:self.view];
                            }];
        }
    }
}

- (void)addPhotoFromURLNotification:(NSNotification *)notification
{
    NSURL *imageURL = notification.userInfo[@"imageURL"];
    if (imageURL) {
        UIImage *imageToUse = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        [self performSegueWithIdentifier:addNewPhotoSegue sender:imageToUse];
    }
}
@end