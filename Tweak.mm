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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    [application _setBackgroundStyle:UIBackgroundStyleDarkBlur];
    UIWindow *window = MSHookIvar<UIWindow *>(application, "_window");
    [window setBackgroundColor:[UIColor clearColor]];
    [window setOpaque:NO];
    return result;
}

-(void)_setBackgroundStyle:(UIBackgroundStyle)style {
    %orig(UIBackgroundStyleDarkBlur);
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
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    %orig;
}

%end

%hook CKStarkConversationListViewController

-(UIView *)view {
    UIView *orig = %orig;
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    return orig;
}

-(void)setView:(UIView *)orig {
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    %orig;
}

%end

%hook CKMessagesController

-(UIView *)view {
    UIView *orig = %orig;
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    return orig;
}

-(void)setView:(UIView *)orig {
    [orig setBackgroundColor:[UIColor clearColor]];
    [orig setOpaque:NO];
    %orig;
}

%end
