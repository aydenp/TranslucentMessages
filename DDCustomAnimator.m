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
    return 0.4;
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
