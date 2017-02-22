// Tweak.mm
// TranslucentApps
//
// Copyright (c) 2017 Dynastic Development
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DDTMColours.h"
#import "DDViewControllerTransparency.h"
#import "UIBackgroundStyle.h"
#import "SMSHeaders.h"
#import "DDViewControllerPeekDetection.h"
#import "DDCustomAnimator.h"
#import "DDCustomInteraction.h"

static BOOL isEnabled = YES;
static BOOL shouldBlur = YES;
static BOOL hasPromptedAboutReduceTransparency = NO;
CFStringRef kPrefsAppID = CFSTR("applebetas.ios.tweaks.translucentmessages");

static void loadSettings() {
    NSDictionary *settings = nil;
    CFPreferencesAppSynchronize(kPrefsAppID);
    CFArrayRef keyList = CFPreferencesCopyKeyList(kPrefsAppID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (keyList) {
        settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, kPrefsAppID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
        CFRelease(keyList);
    }
    if (settings && settings[@"Enabled"]) {
        isEnabled = [settings[@"Enabled"] boolValue];
    }
    if (settings && settings[@"BlurWallpaper"]) {
        shouldBlur = [settings[@"BlurWallpaper"] boolValue];
    }
    if (settings && settings[@"ReduceTransparencyPrompted"]) {
        hasPromptedAboutReduceTransparency = [settings[@"ReduceTransparencyPrompted"] boolValue];
    }
}

static void settingsChanged(CFNotificationCenterRef center,
                            void *observer,
                            CFStringRef name,
                            const void *object,
                            CFDictionaryRef userInfo) {
    [[UIApplication sharedApplication] terminateWithSuccess];
}

%group Tweak

// MARK: - Main Application

%hook SMSApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL result = %orig;
    [application _setBackgroundStyle:UIBackgroundStyleDefault];
    UIWindow *window = MSHookIvar<UIWindow *>(application, "_window");
    [window setBackgroundColor:[UIColor clearColor]];
    [window setOpaque:NO];
    return result;
}

-(void)_setBackgroundStyle:(UIBackgroundStyle)style {
    if(shouldBlur) {
        %orig([NSClassFromString(@"CKUIBehavior") hasDarkTheme] ? [DDTMColours darkBlurStyle] : [DDTMColours blurStyle]);
    } else {
        %orig([DDTMColours transparentStyle]);
    }
}

%end

// MARK: - Make navigation bar more translucent

%hook CKAvatarNavigationBar

-(void)_commonNavBarInit {
    %orig;
    _UIBarBackground *barBackgroundView = MSHookIvar<_UIBarBackground *>(self, "_barBackgroundView");
    [barBackgroundView setDDIsInAvatarNavigationBar:YES];
}

%end

%hook _UIBarBackground

-(id)_blurWithStyle:(long long)arg1 tint:(id)arg2 {
    if([self DDIsInAvatarNavigationBar] && arg1 == 0) {
        return [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    return %orig;
}

%new
-(BOOL)DDIsInAvatarNavigationBar {
    NSNumber *isInAvatarNavigationBar = objc_getAssociatedObject(self, @selector(DDIsInAvatarNavigationBar));
    return [isInAvatarNavigationBar boolValue];
}

%new
-(void)setDDIsInAvatarNavigationBar:(BOOL)isInAvatarNavigationBar {
    objc_setAssociatedObject(self, @selector(DDIsInAvatarNavigationBar), @(isInAvatarNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

%hook CKMessageEntryView

-(id)initWithFrame:(CGRect)arg1 marginInsets:(UIEdgeInsets)arg2 shouldAllowImpact:(BOOL)arg3 shouldShowSendButton:(BOOL)arg4 shouldShowSubject:(BOOL)arg5 shouldShowPluginButtons:(BOOL)arg6 shouldShowCharacterCount:(BOOL)arg7 {
    self = %orig;
    [self DDInitialize];
    return self;
}

-(id)initForFullscreenAppViewWithFrame:(CGRect)arg1 marginInsets:(UIEdgeInsets)arg2 shouldAllowImpact:(BOOL)arg3 shouldShowSendButton:(BOOL)arg4 shouldShowSubject:(BOOL)arg5 shouldShowBrowserButton:(BOOL)arg6 shouldShowCharacterCount:(BOOL)arg7 {
    self = %orig;
    [self DDInitialize];
    return self;
}

-(id)initWithFrame:(CGRect)arg1 marginInsets:(UIEdgeInsets)arg2 shouldShowSendButton:(BOOL)arg3 shouldShowSubject:(BOOL)arg4 shouldShowPluginButtons:(BOOL)arg5 shouldShowCharacterCount:(BOOL)arg6 {
    self = %orig;
    [self DDInitialize];
    return self;
}

%new
-(void)DDInitialize {
    [[self backdropView] setDDIsMessageEntryView:YES];
    [self setDDSpecialEffectsActive:![self shouldConfigureForFullscreenAppView]];
}

%new
-(BOOL)DDSpecialEffectsActive {
    return [[self backdropView] DDSpecialEffectsActive];
}

%new
-(void)setDDSpecialEffectsActive:(BOOL)active {
    [self.backdropView setDDSpecialEffectsActive:active];
    [self.backdropView setBackgroundColor:(active ? [UIColor clearColor] : [UIColor colorWithWhite:0.3 alpha:0.8])];
}

%end

%hook _UIBackdropView

-(UIView *)colorTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setHidden:YES];
    }
    return arg1;
}

-(void)setColorTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setHidden:YES];
    }
    %orig;
}

-(UIView *)colorBurnTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setHidden:YES];
    }
    return arg1;
}

-(void)setColorBurnTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setHidden:YES];
    }
    %orig;
}

-(UIView *)grayscaleTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setHidden:YES];
    }
    return arg1;
}

-(void)setGrayscaleTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setHidden:YES];
    }
    %orig;
}

%new
-(BOOL)DDIsMessageEntryView {
    NSNumber *isMessageEntryView = objc_getAssociatedObject(self, @selector(DDIsMessageEntryView));
    return [isMessageEntryView boolValue];
}

%new
-(void)setDDIsMessageEntryView:(BOOL)isMessageEntryView {
    objc_setAssociatedObject(self, @selector(DDIsMessageEntryView), @(isMessageEntryView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(BOOL)DDSpecialEffectsActive {
    NSNumber *active = objc_getAssociatedObject(self, @selector(DDSpecialEffectsActive));
    return [active boolValue];
}

%new
-(void)setDDSpecialEffectsActive:(BOOL)active {
    objc_setAssociatedObject(self, @selector(DDSpecialEffectsActive), @(active), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end

// MARK: - Fix balloon mask

%hook CKBalloonView

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
    if([self DDPreviewing]) {
        [view setBackgroundColor:([NSClassFromString(@"CKUIBehavior") hasDarkTheme] ? [DDTMColours darkViewPreviewingBackgroundColour] : [DDTMColours viewPreviewingBackgroundColour])];
    } else {
        [view setBackgroundColor:[UIColor clearColor]];
    }
}

%end

// MARK: - Conversation List

%hook CKConversationListController

-(void)loadView {
    %orig;
    [self.searchController.searchBar setDDConvoSearchBar:YES];
}

-(void)setSearchController:(UISearchController *)arg1 {
    [arg1.searchBar setDDConvoSearchBar:YES];
    %orig;
}

-(UIViewController *)previewingContext:(id)previewingContext viewControllerForLocation:(CGPoint)location {
    UIViewController *vc = %orig;
    if(vc) {
        [vc setDDPreviewing:YES];
    }
    return vc;
}

-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
commitViewController:(UIViewController *)viewControllerToCommit {
    %orig;
    [viewControllerToCommit setDDPreviewing:NO];
}

-(void)searcherDidComplete:(id)arg1 {
    %orig;
    UITableView *tableView = MSHookIvar<UITableView *>(self, "_table");
    [tableView setHidden:YES];
}

-(void)willDismissSearchController:(UISearchController *)searchController {
    %orig;
    UITableView *tableView = MSHookIvar<UITableView *>(self, "_table");
    [tableView setHidden:NO];
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
    return [UIColor clearColor];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([UIColor clearColor]);
}

%end

%hook UISearchBar

%new
-(void)DDCommonInit {
    [self setBarTintColor:[self barTintColor]];
    if([self DDConvoSearchBar]) {
        UITextField *searchField = MSHookIvar<UITextField *>(self, "_searchField");
        [searchField setBackgroundColor:[NSClassFromString(@"CKUIBehavior") hasDarkTheme] ? [DDTMColours darkSearchBarFieldTintColour] : [DDTMColours searchBarFieldTintColour]];
    }
}


-(UIColor *)barTintColor {
    if([self DDConvoSearchBar]) {
        return [NSClassFromString(@"CKUIBehavior") hasDarkTheme] ? [DDTMColours darkSearchBarTintColour] : [DDTMColours searchBarTintColour];
    }
    return %orig;
}

-(void)setBarTintColor:(UIColor *)barTintColor {
    %orig([self barTintColor]);
}

%new
-(BOOL)DDConvoSearchBar {
    NSNumber *previewing = objc_getAssociatedObject(self, @selector(DDConvoSearchBar));
    return [previewing boolValue];
}

%new
-(void)setDDConvoSearchBar:(BOOL)convoSearchBar {
    objc_setAssociatedObject(self, @selector(DDConvoSearchBar), @(convoSearchBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self DDCommonInit];
}

%end

%hook CKBrowserFooterTransitionView

-(void)setEntryView:(CKMessageEntryView *)arg1 {
    [arg1 setDDSpecialEffectsActive:NO];
    %orig;
}

%end

// MARK: - Navigation animation & interaction

%hook CKMessagesController

-(void)viewDidLoad {
    %orig;

    if(!hasPromptedAboutReduceTransparency && UIAccessibilityIsReduceTransparencyEnabled()) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TranslucentMessages" message:@"We noticed that you have Reduce Transparency turned on in Settings (General > Accessibility > Increase Contrast). This may cause the transparency not to be applied to your messages app properly and recommend that you disable it.\nWe won't tell you again." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@(YES) forKey:@"ReduceTransparencyPrompted"];
            CFPreferencesSetMultiple((__bridge CFDictionaryRef)dict, nil, kPrefsAppID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
            CFPreferencesAppSynchronize(kPrefsAppID);
        });
    }
    
    [[self conversationListNavigationController] setDelegate:(id<UINavigationControllerDelegate>)self];
    
    [self setInteractionController:[[DDCustomInteraction alloc] init]];
    [[self interactionController] wireToViewController:[self conversationListNavigationController]];
    [self setPushAnimator:[[DDCustomAnimator alloc] init]];
    [self setPopAnimator:[[DDCustomAnimator alloc] initWithReverse:YES]];
    [self setPushCurvedAnimator:[[DDCustomAnimator alloc] initWithCurved:YES]];
    [self setPopCurvedAnimator:[[DDCustomAnimator alloc] initWithReverse:YES andCurved:YES]];
    
    [self.view setBackgroundColor:[[NSClassFromString(@"CKUIBehavior") currentTheme] messagesControllerBackgroundColor]];
}

%new
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    BOOL canDoIt = false;
    if([fromVC isKindOfClass:NSClassFromString(@"CKNavigationController")]) {
        if([((CKNavigationController *)fromVC).visibleViewController isKindOfClass:NSClassFromString(@"CKCoreChatController")] || [((CKNavigationController *)fromVC).visibleViewController isKindOfClass:NSClassFromString(@"CKConversationListController")]) {
            canDoIt = true;
        }
    }
    if([fromVC isKindOfClass:NSClassFromString(@"CKConversationListController")]) {
        canDoIt = true;
    }
    if(canDoIt) {
        if(operation == UINavigationControllerOperationPush) {
            return [self interactionController].interactionInProgress ? [self pushAnimator] : [self pushCurvedAnimator];
        } else if(operation == UINavigationControllerOperationPop) {
            return [self interactionController].interactionInProgress ? [self popAnimator] : [self popCurvedAnimator];
        }
    }
    return nil;
}

%new
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if((DDCustomAnimator *)animationController) {
        if(((DDCustomAnimator *)animationController).reverse) {
            return self.interactionController.interactionInProgress ? self.interactionController : nil;
        }
    }
    return nil;
}

%new
-(DDCustomInteraction *)interactionController {
    return objc_getAssociatedObject(self, @selector(interactionController));
}

%new
-(void)setInteractionController:(DDCustomInteraction *)obj {
    objc_setAssociatedObject(self, @selector(interactionController), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(DDCustomAnimator *)pushAnimator {
    return objc_getAssociatedObject(self, @selector(pushAnimator));
}

%new
-(void)setPushAnimator:(DDCustomAnimator *)obj {
    objc_setAssociatedObject(self, @selector(pushAnimator), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(DDCustomAnimator *)popAnimator {
    return objc_getAssociatedObject(self, @selector(popAnimator));
}

%new
-(void)setPopAnimator:(DDCustomAnimator *)obj {
    objc_setAssociatedObject(self, @selector(popAnimator), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(DDCustomAnimator *)pushCurvedAnimator {
    return objc_getAssociatedObject(self, @selector(pushCurvedAnimator));
}

%new
-(void)setPushCurvedAnimator:(DDCustomAnimator *)obj {
    objc_setAssociatedObject(self, @selector(pushCurvedAnimator), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
-(DDCustomAnimator *)popCurvedAnimator {
    return objc_getAssociatedObject(self, @selector(popCurvedAnimator));
}

%new
-(void)setPopCurvedAnimator:(DDCustomAnimator *)obj {
    objc_setAssociatedObject(self, @selector(popCurvedAnimator), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

// MARK: - GroupMe support

%hook GMEmptyView

-(void)setLabel:(UILabel *)arg1 {
    [arg1 setTextColor:[UIColor whiteColor]];
    %orig;
}

-(void)setImageView:(UIImageView *)arg1 {
    [arg1 setTintColor:[UIColor whiteColor]];
    %orig;
}

-(UIColor *)backgroundColor {
    return [UIColor clearColor];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([self backgroundColor]);
}

%end

%end

%group PreiOS10

%hook CKUIBehavior

%new
+(CKUITheme *)currentTheme {
    return nil;
}

%new
+(BOOL)hasDarkTheme {
    return NO;
}

-(UIColor *)messagesControllerBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)transcriptBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)detailsBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)conversationListSenderColor {
    return [DDTMColours listTitleColour];
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

-(UIColor *)transcriptTextColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptDeemphasizedTextColor {
    return [DDTMColours insideChatViewLabelSubtleColour];
}

-(UIColor *)entryFieldCoverFillColor {
    return [DDTMColours entryFieldCoverFillColour];
}

-(UIColor *)entryFieldCoverBorderColor {
    return [DDTMColours entryFieldCoverBorderColour];
}

-(UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceDark;
}

-(UIColor *)entryFieldBackgroundColor {
    return [UIColor clearColor];
}

-(UIColor *)entryFieldTextColor {
    return [DDTMColours entryFieldTextColour];
}

-(UIColor *)entryFieldGrayColor {
    return [DDTMColours entryFieldPlaceholderColour];
}

-(long long)toFieldBackdropStyle {
    return 10100;
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

%hook CKConversationListController

-(void)viewDidLayoutSubviews {
    %orig;
    UITableView *table = MSHookIvar<UITableView *>(self, "_table");
    [table setBackgroundColor:[UIColor clearColor]];
    [table setSeparatorColor:[DDTMColours separatorColour]];
}

%end

%end

%group PostiOS10

%hook CKUIBehavior

%new
+(CKUITheme *)currentTheme {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [[NSClassFromString(@"CKUIBehaviorPad") sharedBehaviors] theme];
    } else {
        return [[NSClassFromString(@"CKUIBehaviorPhone") sharedBehaviors] theme];
    }
}

%new
+(BOOL)hasDarkTheme {
    CKUITheme *theme = [NSClassFromString(@"CKUIBehavior") currentTheme];
    if([theme isKindOfClass:NSClassFromString(@"CKUIThemeDark")]) {
        return YES;
    }
    return NO;
}

%end

// MARK: - Theme Changes

%hook CKUIThemeLight

-(UIColor *)messagesControllerBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)conversationListBackgroundColor {
    return [DDTMColours viewBackgroundColour];
}

-(UIColor *)conversationListCellColor {
    return [UIColor clearColor];
}

-(UIColor *)conversationListSenderColor {
    return [DDTMColours listTitleColour];
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

-(UIColor *)transcriptBigEmojiColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptDeemphasizedTextColor {
    return [DDTMColours insideChatViewLabelSubtleColour];
}

-(UIColor *)entryFieldCoverFillColor {
    return [DDTMColours entryFieldCoverFillColour];
}

-(UIColor *)entryFieldCoverBorderColor {
    return [DDTMColours entryFieldCoverBorderColour];
}

-(UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceDark;
}

-(UIColor *)entryFieldBackgroundColor {
    return [UIColor clearColor];
}

-(UIColor *)entryFieldTextColor {
    return [DDTMColours entryFieldTextColour];
}

-(UIColor *)entryFieldGrayColor {
    return [DDTMColours entryFieldPlaceholderColour];
}

-(long long)toFieldBackdropStyle {
    return 10100;
}

%end

%hook CKUIThemeDark

-(UIColor *)messagesControllerBackgroundColor {
    return shouldBlur ? [DDTMColours darkViewBackgroundColour] : [DDTMColours darkViewTransparentBackgroundColour];
}

-(UIColor *)conversationListBackgroundColor {
    return shouldBlur ? [DDTMColours darkViewBackgroundColour] : [DDTMColours darkViewTransparentBackgroundColour];
}

-(UIColor *)conversationListCellColor {
    return [UIColor clearColor];
}

-(UIColor *)conversationListSenderColor {
    return [DDTMColours listTitleColour];
}

-(UIColor *)conversationListSummaryColor {
    return [DDTMColours listSubtitleColour];
}

-(UIColor *)conversationListDateColor {
    return [DDTMColours listSubtitleColour];
}

-(id)gray_balloonColors {
    return @[[UIColor colorWithWhite:0.3 alpha:0.45], [UIColor colorWithWhite:0.3 alpha:0.3]];
}

-(UIColor *)stickerDetailsSubheaderTextColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptTextColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptBigEmojiColor {
    return [DDTMColours insideChatViewLabelColour];
}

-(UIColor *)transcriptDeemphasizedTextColor {
    return [DDTMColours insideChatViewLabelSubtleColour];
}

-(UIColor *)entryFieldCoverFillColor {
    return [DDTMColours darkEntryFieldCoverFillColour];
}

-(UIColor *)entryFieldCoverBorderColor {
    return [DDTMColours darkEntryFieldCoverBorderColour];
}

-(UIColor *)entryFieldBackgroundColor {
    return [UIColor clearColor];
}

-(UIColor *)entryFieldTextColor {
    return [DDTMColours entryFieldTextColour];
}

-(UIColor *)entryFieldGrayColor {
    return [DDTMColours entryFieldPlaceholderColour];
}

%end

%hook CKEntryViewButton

-(UIColor *)ckTintColor {
    UIColor *tintColor = %orig;
    if(([self.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")]) && (tintColor != [[NSClassFromString(@"CKUIBehavior") currentTheme] entryFieldHighlightedButtonColor]) && [self entryViewButtonType] != 4) {
        return [DDTMColours entryFieldButtonColour];
    }
    return tintColor;
}

-(void)setCkTintColor:(UIColor *)tintColor {
    if(([self.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")]) && (tintColor != [[NSClassFromString(@"CKUIBehavior") currentTheme] entryFieldHighlightedButtonColor]) && [self entryViewButtonType] != 4) {
        %orig([DDTMColours entryFieldButtonColour]);
    } else {
        %orig;
    }
}

%end

// MARK: - iMessage app fix

%hook CKChatController

-(void)chatInputControllerWillPresentModalBrowserViewController:(id)arg1 {
    %orig;
    [[self entryView] setDDSpecialEffectsActive:NO];
}

-(void)chatInputControllerWillDismissModalBrowserViewController:(id)arg1 {
    %orig;
    [[self entryView] setDDSpecialEffectsActive:YES];
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

-(UIColor *)backgroundColor {
    return [UIColor clearColor];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([self backgroundColor]);
}

%end

%end

// MARK: - Loading

%ctor {
    @autoreleasepool {
        loadSettings();
        
        if (isEnabled) {
            %init(Tweak);
            if([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10,0,0}]) {
                %init(PostiOS10);
            } else {
                %init(PreiOS10);
            }
        }
        
        // listen for notifications from settings
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        NULL,
                                        (CFNotificationCallback)settingsChanged,
                                        CFSTR("applebetas.ios.tweaks.translucentmessages.changed"),
                                        NULL,
                                        CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}
