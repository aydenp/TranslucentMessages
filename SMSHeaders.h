#import <UIKit/UIKit.h>
#import "DDCustomAnimator.h"
#import "DDCustomInteraction.h"

@class DDCustomInteraction;

@interface SMSApplication : UIApplication {
    UIWindow* _window;
}
@property (nonatomic,retain) UIWindow * window;
@end

@interface CKViewController : UIViewController <UINavigationControllerDelegate>
-(void)handleBG:(UIView *)view;
@end

@interface CKScrollViewController : CKViewController
@end

@interface CKNavigationController : UINavigationController
-(void)DDCommonInit;
@end

@interface CKMessagesController : UISplitViewController
-(CKNavigationController *)chatNavigationController;
-(CKNavigationController *)conversationListNavigationController;
-(DDCustomInteraction *)interactionController;
-(void)setInteractionController:(DDCustomInteraction *)obj;
-(DDCustomAnimator *)pushAnimator;
-(void)setPushAnimator:(DDCustomAnimator *)obj;
-(DDCustomAnimator *)popAnimator;
-(void)setPopAnimator:(DDCustomAnimator *)obj;
-(DDCustomAnimator *)pushCurvedAnimator;
-(void)setPushCurvedAnimator:(DDCustomAnimator *)obj;
-(DDCustomAnimator *)popCurvedAnimator;
-(void)setPopCurvedAnimator:(DDCustomAnimator *)obj;
@end

@interface CKStarkConversationListViewController : UITableViewController
@end

@interface CKConversationListController : UITableViewController
-(UISearchController *)searchController;
-(void)setSearchController:(UISearchController *)arg1;
@end

@interface CKConversationListTableView : UITableView
@end

@interface CKConversationListCell : UITableViewCell
@end

@interface _UIBackdropViewSettings : NSObject
-(void)setGrayscaleTintAlpha:(double)arg1;
-(void)setFilterMaskAlpha:(double)arg1;
-(void)setDarkeningTintAlpha:(double)arg1;
-(void)setColorOffsetAlpha:(double)arg1;
-(void)setColorBurnTintAlpha:(double)arg1;
-(void)setFilterMaskAlpha:(double)arg1;
-(void)setColorTintMaskAlpha:(double)arg1;
-(void)setGrayscaleTintMaskAlpha:(double)arg1;
-(void)setColorTint:(UIColor *)arg1 ;
-(void)setColorTintAlpha:(double)arg1 ;
@end

@interface UIVisualEffect (EffectSettings)
-(_UIBackdropViewSettings *)effectSettings;
@end

@interface CKAvatarNavigationBar : UINavigationBar
@end

@interface _UIBackdropView : UIView
-(UIView *)colorTintView;
-(void)setColorTintView:(UIView *)arg1;
-(UIView *)colorBurnTintView;
-(void)setColorBurnTintView:(UIView *)arg1;
-(UIView *)grayscaleTintView;
-(void)setGrayscaleTintView:(UIView *)arg1;

-(BOOL)DDSpecialEffectsActive;
-(void)setDDSpecialEffectsActive:(BOOL)active;

-(BOOL)DDIsMessageEntryView;
-(void)setDDIsMessageEntryView:(BOOL)isMessageEntryView;
@end

@interface CKMessageEntryView : UIView {
    _UIBackdropView * _backdropView;
}
-(void)DDInitialize;
-(BOOL)shouldConfigureForFullscreenAppView;
-(_UIBackdropView *)backdropView;

-(BOOL)DDSpecialEffectsActive;
-(void)setDDSpecialEffectsActive:(BOOL)active;
@end

@interface _UIBackdropEffectView : UIView
@end

@interface _UIBarBackground : UIView
-(BOOL)DDIsInAvatarNavigationBar;
-(void)setDDIsInAvatarNavigationBar:(BOOL)isInAvatarNavigationBar;
@end

@interface CKMessageEntryTextView : UITextView
@end

@interface CKMessageEntryRichTextView : CKMessageEntryTextView
@end

@interface CKMessageEntryContentView : UIScrollView
@end

@interface CKEntryViewButton : UIButton
-(void)setCkTintColor:(UIColor *)arg1;
-(UIColor *)ckTintColor;
@end

@interface UISearchBar (DDConvoSearchBar)
-(BOOL)DDConvoSearchBar;
-(void)setDDConvoSearchBar:(BOOL)convoSearchBar;
-(void)DDCommonInit;
@end

@interface CKUITheme : NSObject
- (id)entryFieldHighlightedButtonColor;
@end

@interface CKUIBehavior : NSObject
+(id)sharedBehaviors;
+(CKUITheme *)currentTheme;
+(BOOL)hasDarkTheme;
-(CKUITheme *)theme;
@end

@interface CKUIBehaviorPhone : CKUIBehavior
@end

@interface CKUIBehaviorPad : CKUIBehavior
@end

@interface CKCoreChatController : CKScrollViewController
-(UIScrollView *)scrollView;
@end

@interface CKChatController : CKCoreChatController
-(CKMessageEntryView *)entryView;
-(void)setEntryView:(CKMessageEntryView *)arg1;
@end

@interface UIApplication (Private)
- (void)terminateWithSuccess;
@end
