//
//  JMSAddPhotoTableViewController.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/3/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSAddPhotoTableViewController.h"

@interface JMSAddPhotoTableViewController ()

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
@end
