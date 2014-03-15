//
//  JMSPhotoStore.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 2/26/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPhotoStore.h"
#import "JMSPhotoData.h"

@import MapKit;

static NSString *const photoArrayKey = @"photoArray";

@implementation JMSPhotoStore
#pragma mark - Properties
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        [self openSavedData];
    }
    return _photoArray;
}

#pragma mark - API
+ (instancetype)sharedStore
{
    static JMSPhotoStore *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[JMSPhotoStore alloc] init];
        [_sharedInstance openSavedData];
    });
    return _sharedInstance;
}

- (JMSPhotoData *)addNewPictureToStoreWithImage:(UIImage *)image title:(NSString *)title placemark:(MKPlacemark *)placemark url:(NSURL *)url phone:(NSString *)phone;
{
    NSAssert(image != nil, @"The image can't be nil");
    
    JMSPhotoData *photoData = [[JMSPhotoData alloc] init];
    photoData.photo = image;
    photoData.title = title;
    photoData.placemark = placemark;
    photoData.url = url;
    photoData.phone = phone;
    
    [[JMSPhotoStore sharedStore].photoArray insertObject:photoData atIndex:0];
    
    [self save];
    
    return photoData;
}

- (void)deletePhotoAtIndex:(NSInteger)index
{
    JMSPhotoStore *sharedStore = [JMSPhotoStore sharedStore];
    [sharedStore.photoArray removeObjectAtIndex:index];
    [sharedStore save];
}

- (void)save
{
    NSMutableArray *photoArray = [JMSPhotoStore sharedStore].photoArray;
    NSMutableData *dataToWrite = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataToWrite];
    [archiver encodeObject:photoArray forKey:photoArrayKey];
    [archiver finishEncoding];
    
    NSString *saveLocation = [self savedFileLocation];
    [dataToWrite writeToFile:saveLocation atomically:YES];
}

- (void)openSavedData
{
    NSData *savedData = [NSData dataWithContentsOfFile:[self savedFileLocation]];
    
    if (savedData) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:savedData];
        NSMutableArray *savedPhotos = [unarchiver decodeObjectForKey:photoArrayKey];
        [unarchiver finishDecoding];
        
        self.photoArray = savedPhotos;
    } else {
        self.photoArray = [NSMutableArray array];
    }
}

#pragma mark - NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.photoArray forKey:photoArrayKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.photoArray = [aDecoder decodeObjectOfClass:[NSMutableArray class] forKey:photoArrayKey];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - Private
- (NSString *)savedFileLocation
{
    NSArray *directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSString *documentDirectory = [(NSURL *)[directories firstObject] path];
    
    NSString *photoArchive = [documentDirectory stringByAppendingPathComponent:@"photos"];
    NSString *documentDirectoryString = [photoArchive stringByAppendingPathExtension:@"plist"];
    return documentDirectoryString;
}

@end
