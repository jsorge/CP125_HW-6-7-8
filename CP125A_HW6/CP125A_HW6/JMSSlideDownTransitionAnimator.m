//
//  JMSSlideDownTransitionAnimator.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/4/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSSlideDownTransitionAnimator.h"

@implementation JMSSlideDownTransitionAnimator
static NSTimeInterval duration = 0.5;

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *source = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *sourceView = source.view;
    UIView *sourceSnapshot = [sourceView snapshotViewAfterScreenUpdates:NO];
    
    UIViewController *destination = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *destinationView = destination.view;
    UIView *destinationSnapshot = [destinationView snapshotViewAfterScreenUpdates:YES];
    CGRect destinationFinalFrame = [transitionContext finalFrameForViewController:destination];
    
    UIView *containerView = [transitionContext containerView];
    
    [UIView performWithoutAnimation:^{
        destinationSnapshot.frame = (CGRect){
            .size.height = destinationSnapshot.frame.size.height * 0.8f,
            .size.width = destinationSnapshot.frame.size.width * 0.8f
        };
        
        destinationSnapshot.center = (CGPoint){
            .x = [[UIScreen mainScreen] bounds].size.width / 2,
            .y = [[UIScreen mainScreen] bounds].size.height/ 2,
        };
        
        [containerView addSubview:destinationSnapshot];
        [containerView bringSubviewToFront:destinationSnapshot];
        
        [containerView addSubview:sourceSnapshot];
        [sourceView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:duration animations:^{
        CGAffineTransform sourceScaleTransform = CGAffineTransformScale(sourceSnapshot.transform, 1.0, 1.0);
        sourceSnapshot.transform = sourceScaleTransform;
        
        sourceSnapshot.frame = (CGRect) {
            .origin.y = sourceSnapshot.frame.size.height,
            .origin.x = 0,
            .size.height = sourceSnapshot.frame.size.height,
            .size.width = sourceSnapshot.frame.size.width
        };
        
        destinationSnapshot.frame = destinationFinalFrame;
    } completion:^(BOOL finished) {
        [destinationSnapshot removeFromSuperview];
        
        destinationView.frame = destinationFinalFrame;
        [containerView addSubview:destinationView];
        
        [transitionContext completeTransition:YES];
    }];
}
@end
