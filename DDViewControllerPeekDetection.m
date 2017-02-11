#import "DDViewControllerPeekDetection.h"

@implementation UIViewController (DDViewControllerPeekDetection)

-(BOOL)DDPreviewing {
    return objc_getAssociatedObject(self, @selector(DDPreviewing));
}

-(void)setDDPreviewing:(BOOL)previewing {
    objc_setAssociatedObject(self, @selector(DDPreviewing), previewing, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
