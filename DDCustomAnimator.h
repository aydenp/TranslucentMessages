#import <UIKit/UIKit.h>

@interface DDCustomAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property BOOL reverse;
@property BOOL curved;
- (id)init;
- (id)initWithReverse:(BOOL)reverse;
- (id)initWithCurved:(BOOL)curved;
- (id)initWithReverse:(BOOL)reverse andCurved:(BOOL)curved;
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
@end
