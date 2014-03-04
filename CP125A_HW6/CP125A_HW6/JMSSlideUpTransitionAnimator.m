//
//  JMSSlideUpTransitionAnimator.m
//  CP125A_HW6
//
//  Created by Jared Sorge on 3/2/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSSlideUpTransitionAnimator.h"

@implementation JMSSlideUpTransitionAnimator
static NSTimeInterval duration = 1.0;

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
            .origin.y = -destinationSnapshot.frame.size.height
        };
        [containerView addSubview:destinationSnapshot];
        
        [containerView addSubview:sourceSnapshot];
        [sourceView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:duration animations:^{
        CGAffineTransform sourceScaleTransform = CGAffineTransformScale(sourceSnapshot.transform, 0.8, 0.8);
        sourceSnapshot.transform = sourceScaleTransform;
        
        destinationSnapshot.frame = destinationFinalFrame;
    } completion:^(BOOL finished) {
        [destinationSnapshot removeFromSuperview];
        
        destinationView.frame = destinationFinalFrame;
        [containerView addSubview:destinationView];
        
        [transitionContext completeTransition:YES];
    }];
}

@end
