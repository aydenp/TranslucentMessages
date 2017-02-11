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
@end

@interface UIVisualEffect (EffectSettings)
-(_UIBackdropViewSettings *)effectSettings;
@end

@interface CKAvatarNavigationBar : UINavigationBar
@end
