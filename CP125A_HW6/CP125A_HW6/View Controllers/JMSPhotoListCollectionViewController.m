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
@import MobileCoreServices;

static NSString *const photoCellReuse = @"photoCell";

@interface JMSPhotoListCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
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
    
    JMSPhotoData *newPhoto = [self.photoStore addNewPictureToStoreWithImage:pickedImage title:nil];
    
    NSInteger index = [self.photoStore.photoArray indexOfObject:newPhoto];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
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
@end
