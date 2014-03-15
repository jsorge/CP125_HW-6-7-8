//
//  JMSCollectionPhotoCell.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSCollectionPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
