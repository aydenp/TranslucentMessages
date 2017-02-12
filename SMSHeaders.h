#import <UIKit/UIKit.h>

@interface SMSApplication : UIApplication {
    UIWindow* _window;
}
@property (nonatomic,retain) UIWindow * window;
@end

@interface CKViewController : UIViewController
// Our methods:
-(void)handleBG:(UIView *)view;
@end

@interface CKMessagesController : UISplitViewController
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
-(void)setColorTintAlpha:(double)arg1;
-(void)setFilterMaskAlpha:(double)arg1;
-(void)setDarkeningTintAlpha:(double)arg1;
-(void)setColorOffsetAlpha:(double)arg1;
-(void)setColorBurnTintAlpha:(double)arg1;
-(void)setFilterMaskAlpha:(double)arg1;
-(void)setColorTintMaskAlpha:(double)arg1;
-(void)setGrayscaleTintMaskAlpha:(double)arg1;
@end

@interface UIVisualEffect (EffectSettings)
-(_UIBackdropViewSettings *)effectSettings;
@end

@interface CKAvatarNavigationBar : UINavigationBar
@end

@interface _UIBackdropView : UIView
-(void)setColorTintView:(UIView *)arg1;
-(BOOL)DDIsMessageEntryView;
-(void)setDDIsMessageEntryView:(BOOL)isMessageEntryView;
@end

@interface CKMessageEntryView : UIView {
    _UIBackdropView * _backdropView;
}
-(void)DDInitialize;
-(id)backdropView;
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
@end

@interface CKUIBehavior : NSObject
+(id)sharedBehaviors;
+(CKUIBehavior *)currentBehavior;
+(BOOL)hasDarkTheme;
-(CKUITheme *)theme;
@end

@interface CKUIBehaviorPhone : CKUIBehavior
@end

@interface CKUIBehaviorPad : CKUIBehavior
@end
