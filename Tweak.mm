#import <UIKit/UIKit.h>

@interface UIApplication (Private)
- (void)terminateWithSuccess;
@end

typedef NS_ENUM(NSUInteger, UIBackgroundStyle) {
    UIBackgroundStyleDefault,
    UIBackgroundStyleTransparent,
    UIBackgroundStyleLightBlur,
    UIBackgroundStyleDarkBlur,
    UIBackgroundStyleDarkTranslucent
};

@interface UIApplication (UIBackgroundStyle)
-(void)_setBackgroundStyle:(UIBackgroundStyle)style;
@end

@interface SMSApplication : UIApplication {
    UIWindow* _window;
}
@property (nonatomic,retain) UIWindow * window;
@end

%hook SMSApplication

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    %log;
    [self.window setBackgroundColor:[UIColor clearColor]];
    [self.window setOpaque:NO];
    [[UIApplication sharedApplication] _setBackgroundStyle:UIBackgroundStyleDarkBlur];
}

%end

%hook CKViewController

-(UIView *)view {
    %log;
    UIView *orig = %orig;
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    return orig;
}

-(void)setView:(UIView *)orig {
    %log;
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    %orig;
}

%end
