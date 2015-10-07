//
//  UIImage+EEAssets.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "UIImage+EEAssets.h"

#import "AssetsLibrary/AssetsLibrary.h"

@implementation UIImage (Assets)

+ (void)imageFromAssetsWithURL:(NSURL*)url andCompletitionBlock:(void (^)(UIImage*))block{
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    
    [assetslibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref)
            block([UIImage imageWithCGImage:iref]);
        else
            block(nil);
        
    } failureBlock:^(NSError *error) {
        block(nil);
    }];
}

- (void)saveImageToAssetsWithCompletitionBlock:(void (^)(NSURL *, NSError *))block{
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library writeImageToSavedPhotosAlbum:[self CGImage] orientation:(ALAssetOrientation)[self imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        block(assetURL, error);
    }];
}

@end