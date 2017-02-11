#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DDTMColours.h"
#import "DDViewControllerTransparency.h"
#import "UIBackgroundStyle.h"
#import "SMSHeaders.h"
#import "DDViewControllerPeekDetection.h"

// MARK: - Main Application

%hook SMSApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    [application _setBackgroundStyle:[DDTMColours blurStyle]];
    UIWindow *window = MSHookIvar<UIWindow *>(application, "_window");
    [window setBackgroundColor:[UIColor clearColor]];
    [window setOpaque:NO];
    return result;
}

-(void)_setBackgroundStyle:(UIBackgroundStyle)style {
    %orig([DDTMColours blurStyle]);
}

%end

// MARK: - Theme Changes

%hook CKUIThemeLight

-(UIColor *)messagesControllerBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)conversationListBackgroundColor {
    return [[DDTMColours viewBackgroundColour] colorWithAlphaComponent:0.55];
}

-(UIColor *)conversationListSummaryColor {
    return [DDTMColours listSubtitleColour];
}

-(UIColor *)conversationListDateColor {
    return [DDTMColours listSubtitleColour];
}

-(id)gray_balloonColors {
    return @[[UIColor colorWithWhite:1 alpha:0.65], [UIColor colorWithWhite:1 alpha:0.5]];
}

-(UIColor *)stickerDetailsSubheaderTextColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptTextColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptDeemphasizedTextColor {
    return [DDTMColours insideChatViewLabelSubtleColour];
}

-(UIColor *)appTintColor {
    return [DDTMColours appTintColour];
}

%end

// MARK: - Fix balloon mask

%hook CKBalloonView

-(UIColor *)overlayColor {
    return [UIColor yellowColor];
}

-(void)setOverlayColor:(UIColor *)color {
    %orig([UIColor yellowColor]);
}

-(BOOL)canUseOpaqueMask {
    return NO;
}

-(void)setCanUseOpaqueMask:(BOOL)arg1 {
    %orig(NO);
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
    [self handleBG:self.view];
}

%new
-(void)handleBG:(UIView *)view {
    [view setOpaque:NO];
    [view setBackgroundColor:[[DDTMColours viewBackgroundColour] colorWithAlphaComponent:([self DDPreviewing] ? 0.7 : 0)]];
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

-(UIColor *)separatorColor {
    return [DDTMColours separatorColour];
}

-(void)setSeparatorColor:(UIColor *)color {
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
    
    %orig;
}

-(UIColor *)backgroundColor {
    return [DDTMColours cellColour];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([DDTMColours cellColour]);
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
