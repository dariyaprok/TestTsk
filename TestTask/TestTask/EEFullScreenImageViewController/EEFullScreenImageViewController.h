//
//  EEFullScreenImageViewController.h
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Person+Methods.h"

@interface EEFullScreenImageViewController : UIViewController <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImageView;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSInteger currentIndex;

@end
