#import <UIKit/UIKit.h>

@interface SMSApplication : UIApplication {
    UIWindow* _window;
}
@property (nonatomic,retain) UIWindow * window;
@end

@interface CKViewController : UIViewController
@end

@interface CKMessagesController : UISplitViewController
@end

@interface CKStarkConversationListViewController : UITableViewController
@end

@interface CKConversationListController : UITableViewController
@end

@interface CKConversationListTableView : UITableView
@end
