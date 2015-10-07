//
//  EEFullScreenImageViewController.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EEFullScreenImageViewController.h"
#import "UIImage+EEAssets.h"
#import "EETransitionToTableViewControllers.h"
#import "EETableViewController.h"

@implementation EEFullScreenImageViewController


#pragma mark - lifeCycle methods
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    self.fullScreenImageView.image = self.image;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark - UIViewNavigationControllerDelegate methods
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[EETableViewController class]]) {
        return [[EETransitionToTableViewControllers alloc] init];
    }
    else {
        return nil;
    }
}
@end
