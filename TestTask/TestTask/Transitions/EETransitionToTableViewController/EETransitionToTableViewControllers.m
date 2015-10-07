//
//  EETransitionToTableViewControllers.m
//  
//
//  Created by админ on 10/7/15.
//
//

#import "EETransitionToTableViewControllers.h"
#import "EEFullScreenImageViewController.h"
#import "EETableViewController.h"
#import "EECustomTableViewCell.h"

@implementation EETransitionToTableViewControllers
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    EEFullScreenImageViewController* fromViewController = (EEFullScreenImageViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EETableViewController* toViewController = (EETableViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    EECustomTableViewCell* cell = [toViewController cellWithIndex:fromViewController.currentIndex];
    UIView *imageSnapshot = [fromViewController.fullScreenImageView snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:fromViewController.fullScreenImageView.frame fromView:fromViewController.fullScreenImageView.superview];
    
    toViewController.view.alpha = 0.0;
    [cell userImageView].hidden = YES;
    
    CGRect cellRect = [toViewController.tableView rectForRowAtIndexPath:[toViewController.tableView indexPathForCell:cell]];
    cellRect = CGRectOffset(cellRect, -toViewController.tableView.contentOffset.x, -toViewController.tableView.contentOffset.y);
    CGRect frameInSuperView = cellRect;
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];
    
    

    double const xCoordinateOfImage = 7;
    double y = ((fromViewController.fullScreenImageView.image.size.width/[UIScreen mainScreen].bounds.size.width) > (fromViewController.fullScreenImageView.image.size.height/[UIScreen mainScreen].bounds.size.height)) ? (fromViewController.fullScreenImageView.image.size.width/[UIScreen mainScreen].bounds.size.width) : (fromViewController.fullScreenImageView.image.size.height/[UIScreen mainScreen].bounds.size.height);
    CGSize imageSizeInFullScreenImageView = CGSizeMake(fromViewController.fullScreenImageView.image.size.width /y, fromViewController.fullScreenImageView.image.size.height / y);
    
    double toMakePhotoBiggerWidth = imageSizeInFullScreenImageView.width/[cell userImageView].frame.size.width;
    double toMakePhotoBiggerHeight = imageSizeInFullScreenImageView.height/[cell userImageView].frame.size.height;
    
    
    CGRect finalFrame = CGRectMake(xCoordinateOfImage + ([UIScreen mainScreen].bounds.size.width - imageSizeInFullScreenImageView.width)/2/toMakePhotoBiggerWidth, frameInSuperView.origin.y - (([UIScreen mainScreen].bounds.size.height - imageSizeInFullScreenImageView.height)/2/toMakePhotoBiggerHeight), [UIScreen mainScreen].bounds.size.width/imageSizeInFullScreenImageView.width*[cell userImageView].frame.size.width, [UIScreen mainScreen].bounds.size.height/imageSizeInFullScreenImageView.height*[cell userImageView].frame.size.height);
    fromViewController.view.alpha = 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1;
        if (!cell) {
            [imageSnapshot removeFromSuperview];
        }
        else {
            imageSnapshot.frame = finalFrame;
        }
        
    } completion:^(BOOL finished) {
        [imageSnapshot removeFromSuperview];
        fromViewController.fullScreenImageView.hidden = NO;
        [cell userImageView].hidden = NO;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
