//
//  DDCreditCell.h
//  CellTest
//
//  Created by AppleBetas on 2017-02-24.
//  Copyright © 2017 AppleBetas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import "DDCreditService.h"
#import "DDCreditOption.h"

@class DDCreditOption, DDCreditService;

@interface DDCreditCell : PSTableCell
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *positionLabel;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIScrollView *optionScrollView;
@property (strong, nonatomic) UIStackView *optionStackView;
@property (strong, nonatomic) NSArray *creditOptions;

- (void)setName:(NSString *)name;
- (void)setPosition:(NSString *)position;
- (void)setAvatarImage:(UIImage *)avatarImage;
- (void)setCreditOptions:(NSArray *)creditOptions;
@end
