#import "DDTMColours.h"

@implementation DDTMColours

+(UIBlurEffectStyle)backgroundBlurEffectStyle {
    return UIBlurEffectStyleDark;
}

+(UIColor *)viewBackgroundColour {
    return [UIColor colorWithWhite:1 alpha:0.01];
}

+(UIColor *)separatorColour {
    return [UIColor colorWithWhite:0 alpha:0.2];
}

+(UIColor *)selectionColour {
    return [UIColor colorWithWhite:1 alpha:0.25];
}

@end
