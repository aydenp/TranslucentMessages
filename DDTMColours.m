// DDTMColours.m
// TranslucentApps
//
// Copyright (c) 2017 Dynastic Development
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "DDTMColours.h"

@implementation DDTMColours

+(UIBackgroundStyle)blurStyle {
    return UIBackgroundStyleBlur;
}

+(UIBackgroundStyle)darkBlurStyle {
    return UIBackgroundStyleExtraDarkBlur;
}

+(UIColor *)viewBackgroundColour {
    return [UIColor colorWithWhite:1 alpha:0.05];
}

+(UIColor *)darkViewBackgroundColour {
    return [UIColor colorWithWhite:0 alpha:0.05];
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

+(UIColor *)entryFieldPlaceholderColor {
    return [UIColor colorWithWhite:1 alpha:0.65];
}

+(UIColor *)entryFieldTextColor {
    return [UIColor whiteColor];
}

+(UIColor *)entryFieldCoverFillColor {
    return [UIColor colorWithWhite:1 alpha:0.25];
}

+(UIColor *)entryFieldCoverBorderColor {
    return [UIColor colorWithWhite:1 alpha:0.3];
}

+(UIColor *)darkEntryFieldCoverFillColor {
    return [UIColor colorWithWhite:1 alpha:0.1];
}

+(UIColor *)darkEntryFieldCoverBorderColor {
    return [UIColor colorWithWhite:1 alpha:0.15];
}

+(UIColor *)searchBarTintColour {
    return [UIColor colorWithWhite:1 alpha:0.2];
}

+(UIColor *)searchBarFieldTintColour {
    return [UIColor colorWithWhite:1 alpha:0.4];
}

+(UIColor *)darkSearchBarTintColour {
    return [UIColor colorWithWhite:0 alpha:0.2];
}

+(UIColor *)darkSearchBarFieldTintColour {
    return [UIColor colorWithWhite:1 alpha:0.1];
}

@end
