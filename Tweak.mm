#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DDTMColours.h"
#import "DDViewControllerTransparency.h"
#import "UIBackgroundStyle.h"
#import "SMSHeaders.h"
#import "DDViewControllerPeekDetection.h"

UIBackgroundStyle blurStyle = UIBackgroundStyleBlur;

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
    [view setBackgroundColor:[[DDTMColours viewBackgroundColour] colorWithAlphaComponent:([self DDPreviewing] ? 0.55 : 0)]];
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
    return [[DDTMColours viewBackgroundColour] colorWithAlphaComponent:0.35];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([self backgroundColor]);
}

-(UIColor *)separatorColor {
    return [DDTMColours separatorColour];
}

-(void)setSeparatorColor:(UIColor *)color {
    %log;
    %orig([self separatorColor]);
}

%end

%hook CKConversationListCell

-(void)layoutSubviews {
    // Chevron
    UIImageView *chevronImageView = MSHookIvar<UIImageView *>(self, "_chevronImageView");
    [chevronImageView setImage:[chevronImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [chevronImageView setTintColor:[DDTMColours separatorColour]];
    
    // Selection Colour
    UIView *selectionView = [[UIView alloc] init];
    [selectionView setBackgroundColor:[DDTMColours selectionColour]];
    [self setSelectedBackgroundView:selectionView];
    
    // Time & Subtitle Labels
    UILabel *summaryLabel = MSHookIvar<UILabel *>(self, "_summaryLabel");
    UILabel *dateLabel = MSHookIvar<UILabel *>(self, "_dateLabel");
    [summaryLabel setTextColor:[DDTMColours listSubtitleColour]];
    [dateLabel setTextColor:[DDTMColours listSubtitleColour]];
    
    %orig;
}

-(UIColor *)backgroundColor {
    return [UIColor clearColor];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([UIColor clearColor]);
}

%end

// MARK: - DDViewControllerPeekDetection Hooks

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

// MARK: - DDViewControllerTransparency Hooks

%hook UIViewController

%new
-(void)setDDProperTransparencyOnView:(UIView *)view {
    [self setDDHasProperTransparency:YES];
    [view setBackgroundColor:[DDTMColours viewBackgroundColour]];
    [view setOpaque:NO];
}

%new
-(BOOL)DDHasProperTransparency {
    NSNumber *previewing = objc_getAssociatedObject(self, @selector(DDHasProperTransparency));
    return [previewing boolValue];
}

%new
-(void)setDDHasProperTransparency:(BOOL)hasProperTransparency {
    objc_setAssociatedObject(self, @selector(DDHasProperTransparency), @(hasProperTransparency), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end
