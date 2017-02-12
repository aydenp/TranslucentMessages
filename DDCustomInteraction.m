#import "DDCustomInteraction.h"

@implementation DDCustomInteraction

-(void)wireToViewController:(UINavigationController *)viewController {
    NSLog(@"wireToViewController");
    self.viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

-(void)prepareGestureRecognizerInView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [gesture setEdges:UIRectEdgeLeft];
    [view addGestureRecognizer:gesture];
}

-(void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat progress = translation.x / gestureRecognizer.view.superview.frame.size.width;
    progress = (CGFloat)fminf(fmaxf(progress, 0), 1);
    
    switch(gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionInProgress = YES;
            self.wasViewController = self.viewController.visibleViewController;
            [self.viewController popViewControllerAnimated:YES];
        case UIGestureRecognizerStateChanged:
            self._shouldCompleteTransition = progress > 0.5;
            [self updateInteractiveTransition:progress];
        case UIGestureRecognizerStateCancelled:
            self.interactionInProgress = NO;
            if(self.wasViewController) {
                if(self.wasViewController != self.viewController.visibleViewController) {
                    [self.viewController pushViewController:self.wasViewController animated:NO];
                }
            }
            [self cancelInteractiveTransition];
            self.wasViewController = nil;
        case UIGestureRecognizerStateEnded:
            self.interactionInProgress = NO;
            if(self._shouldCompleteTransition) {
                if(self.wasViewController) {
                    if(self.wasViewController != self.viewController.visibleViewController) {
                        [self.viewController pushViewController:self.wasViewController animated:NO];
                    }
                }
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            self.wasViewController = nil;
        default:
            break;
    }
}

@end
