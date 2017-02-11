#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIBackgroundStyle) {
    UIBackgroundStyleDefault,
    UIBackgroundStyleTransparent,
    UIBackgroundStyleLightBlur,
    UIBackgroundStyleDarkBlur,
    UIBackgroundStyleDarkTranslucent,
    UIBackgroundStyleExtraDarkBlur,
    UIBackgroundStyleBlur
};

@interface UIApplication (UIBackgroundStyle)
-(void)_setBackgroundStyle:(UIBackgroundStyle)style;
@end
