//
//  UIImage+EEAssets.h
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <UIKit//UIImage.h>

@interface UIImage (Assets)

+ (void)imageFromAssetsWithURL:(NSURL*)url andCompletitionBlock:(void (^)(UIImage*))block;
- (void)saveImageToAssetsWithCompletitionBlock:(void (^)(NSURL *, NSError *))block;
@end
