//
//  JMSNewPhotoTableViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/1/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSNewPhotoTableViewController.h"

@import MobileCoreServices;

@interface JMSNewPhotoTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic)BOOL showingImagePicker;
@end

@implementation JMSNewPhotoTableViewController
#pragma mark - View Lifecycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (self.showingImagePicker) {
//        self.showingImagePicker = NO;
//    } else {
//        self.showingImagePicker = YES;
//        [self presentViewController:self.imagePicker animated:YES completion:nil];
//    }
}

#pragma mark - Properties
- (void)setPhoto:(UIImage *)photo
{
    _photo = photo;
    self.imageView.image = photo;
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

#pragma mark - IBActions
- (IBAction)cancelButtonTapped:(id)sender
{
    [self.delegate newPhotoViewControllerDidCancel:self];
}

- (IBAction)doneButtonTapped:(id)sender
{
    self.title = self.titleTextField.text;
    [self.delegate newPhotoViewControllerDidSave:self];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    if (!pickedImage) {
        pickedImage = info[UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.photo = pickedImage;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate newPhotoViewControllerDidCancel:self];
    }];
}
@end
