#import <UIKit/UIKit.h>
#import "DDViewControllerTransparency.h"
#import "UIBackgroundStyle.h"
#import "SMSHeaders.h"

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
    [self setDDProperTransparencyOnView:orig];
    return orig;
}

-(void)setView:(UIView *)orig {
    [self setDDProperTransparencyOnView:orig];
    %orig;
}

%end

%hook CKStarkConversationListViewController

-(UIView *)view {
    UIView *orig = %orig;
    [self setDDProperTransparencyOnView:orig];
    return orig;
}

-(void)setView:(UIView *)orig {
    [self setDDProperTransparencyOnView:orig];
    %orig;
}

%end

%hook CKMessagesController

-(UIView *)view {
    UIView *orig = %orig;
    [self setDDProperTransparencyOnView:orig];
    return orig;
}

-(void)setView:(UIView *)orig {
    [self setDDProperTransparencyOnView:orig];
    %orig;
}

%end
