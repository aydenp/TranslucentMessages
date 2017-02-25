//
//  DDCreditService.h
//  CellTest
//
//  Created by AppleBetas on 2017-02-25.
//  Copyright © 2017 AppleBetas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCreditOption.h"

@class DDCreditOption;

@interface DDCreditService : NSObject
@property (strong, nonatomic) NSString *usernameFormatter;
@property (strong, nonatomic) NSString *actionTitleFormatter;
@property (strong, nonatomic) NSArray *linkFormatters;
@property (strong, nonatomic) NSString *imageName;

- (instancetype)initWithUsernameFormatter:(NSString *)usernameFormatter actionTitleFormatter:(NSString *)actionTitleFormatter linkFormatters:(NSArray *)linkFormatters imageName:(NSString *)imageName;
- (instancetype)initWithActionTitleFormatter:(NSString *)actionTitleFormatter linkFormatters:(NSArray *)linkFormatters imageName:(NSString *)imageName;

- (NSString *)getFormattedUsernameForOption:(DDCreditOption *)option;
- (NSString *)getActionTitleForOption:(DDCreditOption *)option;
- (NSArray *)getLinksForOption:(DDCreditOption *)option;

// Pre-set:
+ (DDCreditService *)serviceWithName:(NSString *)name;
@end
