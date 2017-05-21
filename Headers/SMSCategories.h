//
//  SMSCategories.h
//  TranslucentMessages
//
//  Copyright (c) 2017 Dynastic Development
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <UIKit/UIKit.h>

@class DDCustomInteraction;

@interface _UIBackdropView (TranslucentMessages)
@property (nonatomic, assign) BOOL DDSpecialEffectsActive;
@property (nonatomic, assign) BOOL DDIsMessageEntryView;

-(void)DDCommonInit;
-(void)DDAppBackgrounding:(NSNotification *)notif;
-(void)DDAppResumed:(NSNotification *)notif;
-(void)DDRemovePreservationView;
@end

@interface CKNavigationController (TranslucentMessages)
-(void)DDCommonInit;
@end

@interface CKMessagesController (TranslucentMessages)
@property (nonatomic, retain) DDCustomInteraction *interactionController;
@property (nonatomic, retain) DDCustomAnimator *pushAnimator;
@property (nonatomic, retain) DDCustomAnimator *popAnimator;
@property (nonatomic, retain) DDCustomAnimator *pushCurvedAnimator;
@property (nonatomic, retain) DDCustomAnimator *popCurvedAnimator;
@end

@interface CKMessageEntryView (TranslucentMessages)
-(void)DDInitialize;
-(BOOL)DDSpecialEffectsActive;
-(void)setDDSpecialEffectsActive:(BOOL)active;
@end

@interface _UIBarBackground (TranslucentMessages)
@property (nonatomic, assign) BOOL DDIsInAvatarNavigationBar;
@end

@interface UISearchBar (DDConvoSearchBar)
@property (nonatomic, assign) BOOL DDConvoSearchBar;
-(void)DDCommonInit;
@end
