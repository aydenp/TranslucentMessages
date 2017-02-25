//
//  DDCreditOption.m
//  CellTest
//
//  Created by AppleBetas on 2017-02-25.
//  Copyright © 2017 AppleBetas. All rights reserved.
//

#import "DDCreditOption.h"

@implementation DDCreditOption

- (instancetype)initWithUsername:(NSString *)username service:(DDCreditService *)service {
    self = [super init];
    self.username = username;
    self.service = service;
    return self;
}

- (instancetype)initWithUsername:(NSString *)username service:(DDCreditService *)service forcedFormattedUsername:(NSString *)forcedFormattedUsername {
    self = [super init];
    self.username = username;
    self.service = service;
    self.forcedFormattedUsername = forcedFormattedUsername;
    return self;
}

- (NSString *)getActionTitle {
    return [self.service getActionTitleForOption:self];
}

- (NSArray *)getLinks {
    return [self.service getLinksForOption:self];
}

- (void)open {
    for (NSURL *url in [self getLinks]) {
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            break;
        }
    }
}

@end
