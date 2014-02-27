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

static NSString *const photoCellReuse = @"photoCell";

@interface JMSPhotoListCollectionViewController ()
@property (strong, nonatomic)JMSPhotoStore *photoStore;
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
    // Do any additional setup after loading the view.
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

@end
