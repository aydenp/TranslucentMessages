#import <UIKit/UIKit.h>

@interface UIViewController (DDViewControllerPeekDetection)
-(BOOL)DDPreviewing;
-(void)setDDPreviewing:(BOOL)previewing;
-(void)DDPreviewingDidChangeTo:(BOOL)previewing;
@end
