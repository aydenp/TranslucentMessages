#import <UIKit/UIKit.h>

@interface DDCustomInteraction : UIPercentDrivenInteractiveTransition
@property BOOL interactionInProgress;
@property BOOL _shouldCompleteTransition;
@property UIViewController *wasViewController;
@property UINavigationController *viewController;
-(void)wireToViewController:(UINavigationController *)viewController;
-(void)prepareGestureRecognizerInView:(UIView *)view;
-(void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
@end
