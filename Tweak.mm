#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DDTMColours.h"
#import "DDViewControllerTransparency.h"
#import "UIBackgroundStyle.h"
#import "SMSHeaders.h"
#import "DDViewControllerPeekDetection.h"
#import "DDCustomAnimator.h"
#import "DDCustomInteraction.h"

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
    %orig([NSClassFromString(@"CKUIBehavior") hasDarkTheme] ? [DDTMColours darkBlurStyle] : [DDTMColours blurStyle]);
}

%end

// MARK: - Theme Changes

%hook CKUIBehavior

%new
+(CKUIBehavior *)currentBehavior {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [NSClassFromString(@"CKUIBehaviorPad") sharedBehaviors];
    } else {
        return [NSClassFromString(@"CKUIBehaviorPhone") sharedBehaviors];
    }
}

%new
+(BOOL)hasDarkTheme {
    CKUIBehavior *behavior = [NSClassFromString(@"CKUIBehavior") currentBehavior];
    if([[behavior theme] isKindOfClass:NSClassFromString(@"CKUIThemeDark")]) {
        return YES;
    }
    return NO;
}

%end

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
    return [DDTMColours entryFieldCoverFillColor];
}

-(UIColor *)entryFieldCoverBorderColor {
    return [DDTMColours entryFieldCoverBorderColor];
}

-(UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceDark;
}

-(UIColor *)entryFieldBackgroundColor {
    return [UIColor clearColor];
}

%end


%hook CKUIThemeDark

-(UIColor *)messagesControllerBackgroundColor {
    return [DDTMColours darkViewBackgroundColour];
}

-(UIColor *)conversationListBackgroundColor {
    return [DDTMColours darkViewBackgroundColour];
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
    return [DDTMColours darkEntryFieldCoverFillColor];
}

-(UIColor *)entryFieldCoverBorderColor {
    return [DDTMColours darkEntryFieldCoverBorderColor];
}

-(UIColor *)entryFieldBackgroundColor {
    return [UIColor clearColor];
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
}

%end

%hook _UIBackdropView

-(UIView *)colorTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setColorTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    %orig;
}

-(UIView *)effectView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setEffectView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    %orig;
}

-(UIView *)colorBurnTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setColorBurnTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    %orig;
}

-(UIView *)grayscaleTintView {
    UIView *arg1 = %orig;
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
    }
    return arg1;
}

-(void)setGrayscaleTintView:(UIView *)arg1 {
    if([self DDIsMessageEntryView]) {
        [arg1 setAlpha:0];
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

%end

%hook CKEntryViewButton

-(UIColor *)ckTintColor {
    if([self.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")] || [self.superview.superview.superview isKindOfClass:NSClassFromString(@"CKMessageEntryView")]) {
        return [DDTMColours entryFieldButtonColor];
    }
    return %orig;
}

-(void)setCkTintColor:(UIColor *)tintColor {
    %orig([self ckTintColor]);
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
    [view setBackgroundColor:[([NSClassFromString(@"CKUIBehavior") hasDarkTheme] ? [DDTMColours darkViewBackgroundColour] : [DDTMColours viewBackgroundColour]) colorWithAlphaComponent:([self DDPreviewing] ? 0.5 : 0)]];
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
    UITextField *searchField = MSHookIvar<UITextField *>(self, "_searchField");
    [searchField setBackgroundColor:[DDTMColours searchBarFieldTintColour]];
}


-(UIColor *)barTintColor {
    if([self DDConvoSearchBar]) {
        return [DDTMColours searchBarTintColour];
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

// MARK: - Navigation animation & interaction

%hook CKMessagesController

-(void)viewDidLoad {
    %orig;
    
    [[self chatNavigationController] setDelegate:(id<UINavigationControllerDelegate>)self];
    [[self conversationListNavigationController] setDelegate:(id<UINavigationControllerDelegate>)self];
    
    [self setInteractionController:[[DDCustomInteraction alloc] init]];
    [[self interactionController] wireToViewController:(UINavigationController *)self];
    [self setPushAnimator:[[DDCustomAnimator alloc] init]];
    [self setPopAnimator:[[DDCustomAnimator alloc] initWithReverse:YES]];
    [self setPushCurvedAnimator:[[DDCustomAnimator alloc] initWithCurved:YES]];
    [self setPopCurvedAnimator:[[DDCustomAnimator alloc] initWithReverse:YES andCurved:YES]];
}

%new
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if(operation == UINavigationControllerOperationPush) {
        return [self interactionController].interactionInProgress ? [self pushAnimator] : [self pushCurvedAnimator];
    } else if(operation == UINavigationControllerOperationPop) {
        return [self interactionController].interactionInProgress ? [self popAnimator] : [self popCurvedAnimator];
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
