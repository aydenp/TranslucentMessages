//
//  DDCreditService.m
//  CellTest
//
//  Created by AppleBetas on 2017-02-25.
//  Copyright © 2017 AppleBetas. All rights reserved.
//

#import "DDCreditService.h"

@implementation DDCreditService

- (instancetype)initWithUsernameFormatter:(NSString *)usernameFormatter actionTitleFormatter:(NSString *)actionTitleFormatter linkFormatters:(NSArray *)linkFormatters imageName:(NSString *)imageName {
    self = [super init];
    self.usernameFormatter = usernameFormatter;
    self.actionTitleFormatter = actionTitleFormatter;
    self.linkFormatters = linkFormatters;
    self.imageName = imageName;
    return self;
}

- (instancetype)initWithActionTitleFormatter:(NSString *)actionTitleFormatter linkFormatters:(NSArray *)linkFormatters imageName:(NSString *)imageName {
    self = [super init];
    self.usernameFormatter = @"{username}";
    self.actionTitleFormatter = actionTitleFormatter;
    self.linkFormatters = linkFormatters;
    self.imageName = imageName;
    return self;
}

- (NSString *)getFormattedUsernameForOption:(DDCreditOption *)option {
    if (option.forcedFormattedUsername == nil) {
        return [self.usernameFormatter stringByReplacingOccurrencesOfString:@"{username}" withString:option.username];
    }
    return option.forcedFormattedUsername;
}

- (NSString *)getActionTitleForOption:(DDCreditOption *)option {
    return [self.actionTitleFormatter stringByReplacingOccurrencesOfString:@"{username}" withString:[self getFormattedUsernameForOption:option]];
}

- (NSArray *)getLinksForOption:(DDCreditOption *)option {
    NSMutableArray *links = [NSMutableArray array];
    for (NSString *linkFormatter in self.linkFormatters) {
        NSURL *url = [NSURL URLWithString:[linkFormatter stringByReplacingOccurrencesOfString:@"{username}" withString:option.username]];
        if (url) {
            [links addObject:url];
        }
    }
    return links;
}

// Pre-set:

+ (DDCreditService *)serviceWithName:(NSString *)name {
    if ([name isEqualToString:@"website"]) {
        return [[DDCreditService alloc] initWithActionTitleFormatter:@"View website" linkFormatters:@[@"{username}"] imageName:@"Service-Website"];
    } else if ([name isEqualToString:@"twitter"]) {
        return [[DDCreditService alloc] initWithUsernameFormatter:@"@{username}" actionTitleFormatter:@"Follow {username} on Twitter" linkFormatters:@[@"tweetbot:///user_profile/{username}", @"twitterrific:///profile?screen_name={username}", @"tweetings:///user?screen_name={username}", @"twitter://user?screen_name={username}", @"https://mobile.twitter.com/{username}"] imageName:@"Service-Twitter"];
    } else if ([name isEqualToString:@"reddit"]) {
        return [[DDCreditService alloc] initWithUsernameFormatter:@"/u/{username}" actionTitleFormatter:@"View {username} on Reddit" linkFormatters:@[@"https://m.reddit.com/user/{username}"] imageName:@"Service-Reddit"];
    } else if ([name isEqualToString:@"github"]) {
        return [[DDCreditService alloc] initWithActionTitleFormatter:@"View {username} on GitHub" linkFormatters:@[@"https://www.github.com/{username}"] imageName:@"Service-GitHub"];
    } else if ([name isEqualToString:@"googlePlus"]) {
        return [[DDCreditService alloc] initWithActionTitleFormatter:@"Follow {username} on Google Plus" linkFormatters:@[@"https://plus.google.com/{username}"] imageName:@"Service-GooglePlus"];
    } else if ([name isEqualToString:@"instagram"]) {
        return [[DDCreditService alloc] initWithUsernameFormatter:@"@{username}" actionTitleFormatter:@"Follow {username} on Instagram" linkFormatters:@[@"https://www.instagram.com/{username}"] imageName:@"Service-Instagram"];
    } else if ([name isEqualToString:@"youtube"]) {
    return [[DDCreditService alloc] initWithActionTitleFormatter:@"Subscribe to {username} on YouTube" linkFormatters:@[@"https://www.youtube.com/"] imageName:@"Service-YouTube"];
    } else if ([name isEqualToString:@"paypal"]) {
        return [[DDCreditService alloc] initWithActionTitleFormatter:@"Donate to {username} using PayPal" linkFormatters:@[@"https://www.paypal.me/{username}"] imageName:@"Service-PayPal"];
    } else if ([name isEqualToString:@"email"]) {
        return [[DDCreditService alloc] initWithActionTitleFormatter:@"Email {username}" linkFormatters:@[@"mailto:{username}"] imageName:@"Service-Email"];
    }
    return [[DDCreditService alloc] initWithActionTitleFormatter:@"Unknown" linkFormatters:@[] imageName:@"Service-Unknown"];
}

@end
