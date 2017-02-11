#import "DDViewControllerTransparency.h"

@implementation UIViewController (DDViewControllerTransparency)

-(void)setDDProperTransparency {
    [self setDDProperTransparencyOnView:self.view];
}

-(void)setDDProperTransparencyOnView:(UIView *)view {
    [view setBackgroundColor:[UIColor clearColor]];
    [view setOpaque:NO];
}

@end
