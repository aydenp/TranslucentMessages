#import "DDViewControllerTransparency.h"

@implementation UIViewController (DDViewControllerTransparency)

-(void)setDDProperTransparency {
    [self setDDProperTransparencyOnView:self.view];
}

-(void)setDDProperTransparencyOnView:(UIView *)view {
    [self setDDHasProperTransparency:YES];
    [view setBackgroundColor:[DDTMColours viewBackgroundColour]];
    [view setUserInteractionEnabled:YES];
    [view setOpaque:NO];
    
    // Add effect view
    if(![self DDVisualEffectView]) {
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:[DDTMColours backgroundBlurEffectStyle]]];
        [self setDDVisualEffectView:visualEffectView];
        [view addSubview:visualEffectView];
        [view.leadingAnchor constraintEqualToAnchor:visualEffectView.leadingAnchor].active = YES;
        [view.trailingAnchor constraintEqualToAnchor:visualEffectView.trailingAnchor].active = YES;
        [view.topAnchor constraintEqualToAnchor:visualEffectView.topAnchor].active = YES;
        [view.bottomAnchor constraintEqualToAnchor:visualEffectView.bottomAnchor].active = YES;
    }
}

-(BOOL)DDHasProperTransparency {
    NSNumber *previewing = objc_getAssociatedObject(self, @selector(DDHasProperTransparency));
    return [previewing boolValue];
}

-(void)setDDHasProperTransparency:(BOOL)hasProperTransparency {
    objc_setAssociatedObject(self, @selector(DDHasProperTransparency), @(hasProperTransparency), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIVisualEffectView *)DDVisualEffectView {
    return objc_getAssociatedObject(self, @selector(DDVisualEffectView));
}

-(void)setDDVisualEffectView:(UIVisualEffectView *)view {
    objc_setAssociatedObject(self, @selector(DDVisualEffectView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
