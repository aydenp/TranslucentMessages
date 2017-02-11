#import "DDViewControllerTransparency.h"

@implementation UIViewController (DDViewControllerTransparency)

-(void)setDDProperTransparency {
    [self setDDProperTransparencyOnView:self.view];
}

-(void)setDDProperTransparencyOnView:(UIView *)view {
    [view setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.25]];
    [view setUserInteractionEnabled:YES];
    [view setOpaque:NO];
}

@end
