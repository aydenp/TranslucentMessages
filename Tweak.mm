#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DDViewControllerTransparency.h"
#import "UIBackgroundStyle.h"
#import "SMSHeaders.h"
#import "DDViewControllerPeekDetection.h"

UIBackgroundStyle blurStyle = UIBackgroundStyleDarkBlur;

// MARK: - Main Application

%hook SMSApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    [application _setBackgroundStyle:blurStyle];
    UIWindow *window = MSHookIvar<UIWindow *>(application, "_window");
    [window setBackgroundColor:[UIColor clearColor]];
    [window setOpaque:NO];
    return result;
}

-(void)_setBackgroundStyle:(UIBackgroundStyle)style {
    %orig(blurStyle);
}

%end

// MARK: - Nav Controller?

%hook CKViewController

-(UIView *)view {
    UIView *orig = %orig;
    [self handleBG:orig];
    return orig;
}

-(void)setView:(UIView *)orig {
    [self handleBG:orig];
    %orig;
}

-(void)setDDPreviewing:(BOOL)previewing {
    %orig;
    %log;
    [self handleBG:self.view];
}

%new
-(void)handleBG:(UIView *)view {
    [view setOpaque:NO];
    [view setBackgroundColor:[[UIViewController getProperBackgroundColor] colorWithAlphaComponent:([self DDPreviewing] ? 0.75 : 0)]];
}

%end

// MARK: - Chat View Controller

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

// MARK: - Conversation List

%hook CKConversationListController

-(UIView *)view {
    UIView *orig = %orig;
    [self setDDProperTransparencyOnView:orig];
    return orig;
}

-(void)setView:(UIView *)orig {
    [self setDDProperTransparencyOnView:orig];
    %orig;
}

- (UIViewController *)previewingContext:(id)previewingContext viewControllerForLocation:(CGPoint)location {
    UIViewController *vc = %orig;
    if(vc) {
        [vc setDDPreviewing:YES];
    }
    return vc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
commitViewController:(UIViewController *)viewControllerToCommit {
    %orig;
    [viewControllerToCommit setDDPreviewing:NO];
}

%end

%hook CKConversationListTableView

-(void)layoutSubviews {
    %orig;
    [self setSeparatorColor:[self separatorColor]];
}

-(UIColor *)backgroundColor {
    return [[UIViewController getProperBackgroundColor] colorWithAlphaComponent:0.25];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([self backgroundColor]);
}

-(UIColor *)separatorColor {
    return [UIColor colorWithWhite:0 alpha:0.2];
}

-(void)setSeparatorColor:(UIColor *)color {
    %log;
    %orig([self separatorColor]);
}

%end

%hook CKConversationListCell

-(UIColor *)backgroundColor {
    return [UIColor clearColor];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([UIColor clearColor]);
}

%end

// MARK: - DDViewControllerPeekDetection

%hook UIViewController

%new
-(BOOL)DDPreviewing {
    NSNumber *previewing = objc_getAssociatedObject(self, @selector(DDPreviewing));
    return [previewing boolValue];
}

%new
-(void)setDDPreviewing:(BOOL)previewing {
    objc_setAssociatedObject(self, @selector(DDPreviewing), @(previewing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end
