//
//  JMSPhotoStore.h
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMSPhotoData;

@interface JMSPhotoStore : NSObject <NSSecureCoding>

@property (strong, nonatomic)NSMutableArray *photoArray;

#pragma mark - API
/**
 *  A singleton instance of the PhotoStore class
 *
 */
+ (instancetype)sharedStore;

/**
 *  Creates a new PhotoData object and adds it to the photoArray
 *
 *  @param image The photo image. Can't be nil
 *  @param title The title of the image. Can be ni
 *
 *  @return The instance of the new photo
 */
- (JMSPhotoData *)addNewPictureToStoreWithImage:(UIImage *)image title:(NSString *)title;

/**
 *  Saves the current photoArray to disk.
 */
- (void)save;

/**
 *  Opens data saved to disk if it exists, and populates the photoArray.
 */
- (void)openSavedData;

@end
