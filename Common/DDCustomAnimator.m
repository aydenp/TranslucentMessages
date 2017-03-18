//
//  DDCustomAnimator.m
//  TranslucentMessages
//
//  Copyright (c) 2017 Dynastic Development
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "DDCustomAnimator.h"

@implementation DDCustomAnimator

- (id)init {
    return [self initWithReverse:NO andCurved:NO];
}

- (id)initWithReverse:(BOOL)reverse {
    return [self initWithReverse:reverse andCurved:NO];
}

- (id)initWithCurved:(BOOL)curved {
    return [self initWithReverse:NO andCurved:curved];
}

- (id)initWithReverse:(BOOL)reverse andCurved:(BOOL)curved {
    self = [super init];
    self.reverse = reverse;
    self.curved = curved;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.32;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect fromVCFrame = fromViewController.view.frame;
    CGFloat width = toViewController.view.frame.size.width;
    
    [transitionContext.containerView addSubview:toViewController.view];
    [toViewController.view setFrame:CGRectOffset(fromVCFrame, width * (self.reverse ? -1 : 1), 0)];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:(self.curved ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveLinear) animations:^ {
        [fromViewController.view setFrame:CGRectOffset(fromVCFrame, width * (self.reverse ? 1 : -1), 0)];
        [toViewController.view setFrame:fromVCFrame];
    } completion:^(BOOL finished) {
        [fromViewController.view setFrame:fromVCFrame];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
     }];
}

@end
