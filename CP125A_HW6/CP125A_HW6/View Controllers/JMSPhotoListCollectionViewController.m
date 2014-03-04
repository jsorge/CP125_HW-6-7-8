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

@import MobileCoreServices;

static NSString *const photoCellReuse = @"photoCell";
static NSString *const addNewPhotoSegue = @"addNewPhoto";

@interface JMSPhotoListCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, JMSAddPhotoTVCDelegate>
@property (strong, nonatomic)JMSPhotoStore *photoStore;
@property (strong, nonatomic)UIImagePickerController *imagePicker;
@property (nonatomic)BOOL hasCamera;
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
    if ([segue.identifier isEqualToString:addNewPhotoSegue] && [sender isKindOfClass:[UIImage class]]) {
        UINavigationController *destination = segue.destinationViewController;
        JMSAddPhotoTableViewController *addViewController = (JMSAddPhotoTableViewController *)destination.topViewController;
        addViewController.delegate = self;
        addViewController.photo = sender;
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
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
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
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
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
    if (buttonIndex == 0) {
        //Camera
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        //Photo Library
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
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
    
    JMSPhotoData *newPhoto = [self.photoStore addNewPictureToStoreWithImage:image title:title];
    
    NSInteger index = [self.photoStore.photoArray indexOfObject:newPhoto];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }];
}
@end
