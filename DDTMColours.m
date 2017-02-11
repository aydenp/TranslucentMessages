#import "DDTMColours.h"

@implementation DDTMColours

+(UIBackgroundStyle)blurStyle {
    return UIBackgroundStyleBlur;
}

+(UIColor *)appTintColour {
    return [UIColor colorWithRed:0.38 green:0.68 blue:0.98 alpha:1];
}

+(UIColor *)viewBackgroundColour {
    return [UIColor colorWithWhite:1 alpha:0.1];
}

+(UIColor *)separatorColour {
    return [UIColor colorWithWhite:0 alpha:0.2];
}

+(UIColor *)cellColour {
    return [UIColor colorWithWhite:1 alpha:0.5];
}

+(UIColor *)selectionColour {
    return [UIColor colorWithWhite:1 alpha:0.25];
}

+(UIColor *)listSubtitleColour {
    return [UIColor colorWithWhite:0 alpha:0.5];
}

+(UIColor *)insideChatViewLabelColour {
    return [UIColor colorWithWhite:1 alpha:0.75];
}

+(UIColor *)insideChatViewLabelSubtleColour {
    return [UIColor colorWithWhite:1 alpha:0.6];
}

@end
