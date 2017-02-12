#import "DDTMColours.h"

@implementation DDTMColours

+(UIBackgroundStyle)blurStyle {
    return UIBackgroundStyleBlur;
}

+(UIColor *)viewBackgroundColour {
    return [UIColor colorWithWhite:1 alpha:0.05];
}

+(UIColor *)separatorColour {
    return [UIColor colorWithWhite:1 alpha:0.2];
}

+(UIColor *)selectionColour {
    return [UIColor colorWithWhite:1 alpha:0.2];
}

+(UIColor *)listTitleColour {
    return [UIColor whiteColor];
}

+(UIColor *)listSubtitleColour {
    return [UIColor colorWithWhite:1 alpha:0.7];
}

+(UIColor *)insideChatViewLabelColour {
    return [UIColor colorWithWhite:1 alpha:0.75];
}

+(UIColor *)insideChatViewLabelSubtleColour {
    return [UIColor colorWithWhite:1 alpha:0.6];
}

+(UIColor *)entryFieldButtonColor {
    return [UIColor colorWithWhite:1 alpha:0.4];
}

+(UIColor *)entryFieldCoverFillColor {
    return [UIColor colorWithWhite:1 alpha:0.25];
}

+(UIColor *)entryFieldCoverBorderColor {
    return [UIColor colorWithWhite:1 alpha:0.3];
}

@end
