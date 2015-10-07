//
//  EETransitionToFullScreenImageViewController.m
//  TestTask
//
//  Created by админ on 10/6/15.
//  Copyright (c) 2015 Dariya. All rights reserved.
//

#import "EETransitionToFullScreenImageViewController.h"
#import "EEFullScreenImageViewController.h"
#import "EETableViewController.h"
#import "EECustomTableViewCell.h"

@implementation EETransitionToFullScreenImageViewController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    EETableViewController* fromViewController = (EETableViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EEFullScreenImageViewController* toViewController = (EEFullScreenImageViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    EECustomTableViewCell* cell = [fromViewController cellWithIndex:toViewController.currentIndex];
    UIView* cellImageSnapshot = [[cell userImageView] snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.frame = [containerView convertRect:[cell userImageView].frame fromView:[cell userImageView].superview];
    [cell userImageView].hidden = YES;
    toViewController.view.alpha = 0;
    
    double toMakePhotoBigger = ([UIScreen mainScreen].bounds.size.width/[cell userImageView].image.size.width > [UIScreen mainScreen].bounds.size.height/[cell userImageView].image.size.height) ? [UIScreen mainScreen].bounds.size.height/[cell userImageView].image.size.height : [UIScreen mainScreen].bounds.size.width/[cell userImageView].image.size.width;

    [containerView addSubview:cellImageSnapshot];
    [containerView addSubview:toViewController.view];

    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.alpha = 0;
        CGRect frame = CGRectMake((fromViewController.view.frame.size.width - [cell userImageView].image.size.width*toMakePhotoBigger)/2, (fromViewController.view.frame.size.height - [cell userImageView].image.size.height*toMakePhotoBigger)/2, [cell userImageView].image.size.width*toMakePhotoBigger, [cell userImageView].image.size.height*toMakePhotoBigger);
            cellImageSnapshot.frame = frame;
                

    } completion:^(BOOL finished) {
        toViewController.view.alpha = 1.0;
        toViewController.fullScreenImageView.alpha = 1.0;
        fromViewController.view.alpha = 1.0;
        [cell userImageView].hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];

    }];
    
}
@end
