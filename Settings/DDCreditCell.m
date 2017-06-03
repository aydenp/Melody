//
//  DDCreditCell.m
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

#import "DDCreditCell.h"
#define PREFERENCE_BUNDLE_PATH  @"/Library/PreferenceBundles/MelodySettings.bundle"
#define BUTTON_HEIGHT   20
#define BUTTON_SPACING  14

@implementation DDCreditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.creditOptions = [NSArray array];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarImageView setBackgroundColor:[UIColor colorWithWhite:0.847 alpha:1]];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView setClipsToBounds:YES];
        [_avatarImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_avatarImageView];
        [[_avatarImageView.heightAnchor constraintEqualToConstant:64] setActive:YES];
        [[_avatarImageView.widthAnchor constraintEqualToAnchor:_avatarImageView.heightAnchor] setActive:YES];
        [[_avatarImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        [[_avatarImageView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor] setActive:YES];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:contentView];
        [[contentView.leadingAnchor constraintEqualToAnchor:_avatarImageView.trailingAnchor constant:17] setActive:YES];
        [[contentView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor] setActive:YES];
        [[contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView addSubview:_nameLabel];
        [[_nameLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor] setActive:YES];
        [[_nameLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor] setActive:YES];
        [[_nameLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor] setActive:YES];
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_positionLabel setFont:[UIFont systemFontOfSize:14]];
        [_positionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView addSubview:_positionLabel];
        [[_positionLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor] setActive:YES];
        [[_positionLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor] setActive:YES];
        [[_positionLabel.topAnchor constraintEqualToAnchor:_nameLabel.bottomAnchor] setActive:YES];
        
        _optionScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_optionScrollView setAlwaysBounceHorizontal:YES];
        [_optionScrollView setShowsVerticalScrollIndicator:NO];
        [_optionScrollView setShowsHorizontalScrollIndicator:NO];
        [_optionScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView addSubview:_optionScrollView];
        [[_optionScrollView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor] setActive:YES];
        [[_optionScrollView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor] setActive:YES];
        [[_optionScrollView.topAnchor constraintEqualToAnchor:_positionLabel.bottomAnchor constant:5] setActive:YES];
        [[_optionScrollView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor] setActive:YES];
        [[_optionScrollView.heightAnchor constraintEqualToConstant:BUTTON_HEIGHT] setActive:YES];
        
        _optionStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
        [_optionStackView setAlignment:UIStackViewAlignmentLeading];
        [_optionStackView setAxis:UILayoutConstraintAxisHorizontal];
        [_optionStackView setDistribution:UIStackViewDistributionFill];
        [_optionStackView setSpacing:BUTTON_SPACING];
        [_optionStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_optionScrollView addSubview:_optionStackView];
        [[_optionStackView.leadingAnchor constraintEqualToAnchor:_optionScrollView.leadingAnchor] setActive:YES];
        [[_optionStackView.trailingAnchor constraintEqualToAnchor:_optionScrollView.trailingAnchor] setActive:YES];
        [[_optionStackView.topAnchor constraintEqualToAnchor:_optionScrollView.topAnchor] setActive:YES];
        [[_optionStackView.bottomAnchor constraintEqualToAnchor:_optionScrollView.bottomAnchor] setActive:YES];
        [[_optionStackView.heightAnchor constraintEqualToAnchor:_optionScrollView.heightAnchor] setActive:YES];
        
        [self parseSpecifiers:specifier];
    }
    return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SSExampleTableCell" specifier:specifier];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize avatarSize = self.avatarImageView.bounds.size;
    NSLog(@"avatarSize: %f", avatarSize.width);
    [_avatarImageView.layer setCornerRadius:MIN(avatarSize.height, avatarSize.width) / 2];
}

- (void)setName:(NSString *)name {
    [_nameLabel setText:name];
}

- (void)setPosition:(NSString *)position {
    [_positionLabel setText:position];
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    [_avatarImageView setImage:avatarImage];
}

- (void)setCreditOptions:(NSArray *)creditOptions {
    _creditOptions = creditOptions;
    [self _doCreditOptions];
}

- (void)_doCreditOptions {
    for (UIView *subview in _optionStackView.arrangedSubviews) {
        [_optionStackView removeArrangedSubview:subview];
        [subview removeFromSuperview];
    }
    [_creditOptions enumerateObjectsUsingBlock:^(id x, NSUInteger index, BOOL *stop) {
        DDCreditOption *creditOption = x;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setImage:[self imageFromFilename:creditOption.service.imageName] forState:UIControlStateNormal];
        [button setAccessibilityLabel:[creditOption getActionTitle]];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[button.heightAnchor constraintEqualToConstant:BUTTON_HEIGHT] setActive:YES];
        [[button.widthAnchor constraintEqualToAnchor:button.heightAnchor] setActive:YES];
        [button setTag:index];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_optionStackView addArrangedSubview:button];
    }];
}

- (void)buttonTapped:(UIButton *)button {
    [_creditOptions[button.tag] open];
}

- (UIImage *)imageFromFilename:(NSString *)filename {
    return [UIImage imageWithContentsOfFile:[PREFERENCE_BUNDLE_PATH stringByAppendingPathComponent:filename]];
}

- (void)parseSpecifiers:(PSSpecifier *)specifier {
    NSDictionary *properties = specifier.properties;
    if(properties[@"creditName"]) {
        [self setName:properties[@"creditName"]];
    }
    if(properties[@"creditPosition"]) {
        [self setPosition:properties[@"creditPosition"]];
    }
    if(properties[@"avatarImage"]) {
        [self setAvatarImage:[self imageFromFilename:properties[@"avatarImage"]]];
    }
    NSMutableArray *newCreditOptions = [NSMutableArray array];
    if(properties[@"creditOptions"]) {
        NSArray *creditOptions = properties[@"creditOptions"];
        for (NSDictionary *option in creditOptions) {
            NSString *serviceName = option[@"service"];
            NSString *forcedFormattedUsername = option[@"forcedFormattedUsername"];
            NSString *username = option[@"username"];
            DDCreditService *service = [DDCreditService serviceWithName:serviceName];
            DDCreditOption *option = [[DDCreditOption alloc] initWithUsername:username service:service forcedFormattedUsername:forcedFormattedUsername];
            [newCreditOptions addObject:option];
        }
    }
    [self setCreditOptions:newCreditOptions];
}

@end
