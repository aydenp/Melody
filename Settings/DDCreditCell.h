//
//  DDCreditCell.h
//  DDCreditCell
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
