#import <UIKit/UIKit.h>

@interface UIApplication (Private)
- (void)terminateWithSuccess;
@end

@interface CKUITheme : NSObject
@end

@interface CKUIThemeDark : CKUITheme
@end

static CKUIThemeDark *darkTheme = [[%c(CKUIThemeDark) alloc] init];

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

/*%hook CKUIBehaviorPhone
- (id)theme {
	// return isEnabled ? darkTheme : %orig;
	return darkTheme;
}
%end

%hook CKUIBehaviorPad
- (id)theme {
	// return isEnabled ? darkTheme : %orig;
	return darkTheme;
}
%end*/

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
    UIView *orig = %orig;
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    return orig;
}

-(void)setView:(UIView *)orig {
    %log;
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:YES];
    %orig;
}

%end
