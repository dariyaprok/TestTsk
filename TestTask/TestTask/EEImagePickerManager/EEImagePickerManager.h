//
//  EEImagePickerManager.h
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EEImagePickerManager : NSObject

+ (instancetype)sharedManager;
- (void)presentAlertControllerWithCompletionBlock:(void(^)(UIImage*, NSURL*))block inViewController:(UIViewController *)viewController;

@end
