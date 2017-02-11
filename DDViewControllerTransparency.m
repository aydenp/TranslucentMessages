#import <objc/runtime.h>
#import "DDViewControllerTransparency.h"

@implementation UIViewController (DDViewControllerTransparency)

-(void)setDDProperTransparency {
    [self setDDProperTransparencyOnView:self.view];
}

-(void)setDDProperTransparencyOnView:(UIView *)view {
    [self setDDHasProperTransparency:YES];
    [view setBackgroundColor:[UIViewController getProperBackgroundColorForPeeking:[self DDPreviewing]]];
    [view setUserInteractionEnabled:YES];
    [view setOpaque:NO];
}

-(BOOL)DDHasProperTransparency {
    NSNumber *previewing = objc_getAssociatedObject(self, @selector(DDHasProperTransparency));
    return [previewing boolValue];
}

-(void)setDDHasProperTransparency:(BOOL)hasProperTransparency {
    objc_setAssociatedObject(self, @selector(DDHasProperTransparency), @(hasProperTransparency), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(UIColor *)getProperBackgroundColorForPeeking:(BOOL)peeking {
    return [UIColor colorWithWhite:1 alpha:peeking ? 0.75 : 0.25];
}

@end
