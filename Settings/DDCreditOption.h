//
//  DDCreditOption.h
//  CellTest
//
//  Created by AppleBetas on 2017-02-25.
//  Copyright © 2017 AppleBetas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCreditService.h"

@class DDCreditService;

@interface DDCreditOption : NSObject
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) DDCreditService *service;
@property (strong, nonatomic) NSString *forcedFormattedUsername;

- (instancetype)initWithUsername:(NSString *)username service:(DDCreditService *)service;
- (instancetype)initWithUsername:(NSString *)username service:(DDCreditService *)service forcedFormattedUsername:(NSString *)forcedFormattedUsername;

- (NSString *)getActionTitle;
- (NSArray *)getLinks;
- (void)open;
@end
