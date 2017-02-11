#import <UIKit/UIKit.h>
#import "DDViewControllerPeekDetection.h"
#import "DDTMColours.h"
#import <objc/runtime.h>

@interface UIViewController (DDViewControllerTransparency)
-(void)setDDProperTransparencyOnView:(UIView *)view;
-(BOOL)DDHasProperTransparency;
-(void)setDDHasProperTransparency:(BOOL)hasProperTransparency;
@end
