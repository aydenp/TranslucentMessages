#import "DDCustomInteraction.h"

@implementation DDCustomInteraction

-(void)wireToViewController:(UINavigationController *)viewController {
    self.viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

-(void)prepareGestureRecognizerInView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [gesture setDelegate:self];
    [gesture setEdges:UIRectEdgeLeft];
    [view addGestureRecognizer:gesture];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat progress = translation.x / gestureRecognizer.view.superview.frame.size.width;
    progress = (CGFloat)fminf(fmaxf(progress, 0), 1);
    
    NSLog(@"%ld", (long)gestureRecognizer.state);
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.interactionInProgress = YES;
        self.wasViewController = self.viewController.visibleViewController;
        [self.viewController popViewControllerAnimated:YES];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self._shouldCompleteTransition = progress > 0.5;
        [self updateInteractiveTransition:progress];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.interactionInProgress = NO;
        /*if(self.wasViewController && self.wasViewController != self.viewController.visibleViewController) {
            [self.viewController pushViewController:self.wasViewController animated:NO];
        }*/
        [self cancelInteractiveTransition];
        self.wasViewController = nil;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.interactionInProgress = NO;
        if(!self._shouldCompleteTransition) {
            /*if(self.wasViewController && self.wasViewController != self.viewController.visibleViewController) {
                [self.viewController pushViewController:self.wasViewController animated:NO];
            }*/
            [self cancelInteractiveTransition];
        } else {
            [self finishInteractiveTransition];
        }
        self.wasViewController = nil;
    }
}

@end
