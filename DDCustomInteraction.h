#import <UIKit/UIKit.h>
#import "SMSHeaders.h"

@class CKCoreChatController;

@interface DDCustomInteraction : UIPercentDrivenInteractiveTransition <UIGestureRecognizerDelegate>
@property (nonatomic) BOOL interactionInProgress;
@property (nonatomic) BOOL _shouldCompleteTransition;
@property (nonatomic, strong) UIViewController *wasViewController;
@property (nonatomic, strong) UINavigationController *viewController;

-(void)wireToViewController:(UINavigationController *)viewController;
-(void)prepareGestureRecognizerInView:(UIView *)view;
-(void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
@end
