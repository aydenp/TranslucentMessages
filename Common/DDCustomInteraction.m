//
//  DDCustomInteraction.m
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
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if([self.viewController.visibleViewController isKindOfClass:NSClassFromString(@"CKCoreChatController")]) {
            self.interactionInProgress = YES;
            self.wasViewController = self.viewController.visibleViewController;
            if([self.wasViewController isKindOfClass:NSClassFromString(@"CKCoreChatController")]) {
                [[((CKCoreChatController *)self.wasViewController) scrollView] setScrollEnabled:NO];
            }
            self.transitionStartTime = CACurrentMediaTime();
            [self.wasViewController.view setUserInteractionEnabled:NO];
            [self.viewController popViewControllerAnimated:YES];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self._shouldCompleteTransition = progress > 0.5;
        self._couldPossiblyCompleteTransition = progress > 0.05;
        [self updateInteractiveTransition:progress];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.interactionInProgress = NO;
        [self cancelInteractiveTransition];
        if([self.wasViewController isKindOfClass:NSClassFromString(@"CKCoreChatController")]) {
            [[((CKCoreChatController *)self.wasViewController) scrollView] setScrollEnabled:YES];
        }
        [self.wasViewController.view setUserInteractionEnabled:YES];
        self.wasViewController = nil;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.interactionInProgress = NO;
        CFTimeInterval timeInterval = CACurrentMediaTime() - self.transitionStartTime;
        if(self._shouldCompleteTransition || (self._couldPossiblyCompleteTransition && timeInterval < 0.15)) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
            if([self.wasViewController isKindOfClass:NSClassFromString(@"CKCoreChatController")]) {
                [[((CKCoreChatController *)self.wasViewController) scrollView] setScrollEnabled:YES];
            }
            [self.wasViewController.view setUserInteractionEnabled:YES];
        }
        self.wasViewController = nil;
    }
}

@end
