//
//  MelodySettings.mm
//  Melody
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

#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>
#import "DDCreditService.h"
#import "DDCreditOption.h"
#import "DDCreditCell.h"

#define HEADER_HEIGHT 150.0f

@interface MelodySettingsController : PSListController
@end

@implementation MelodySettingsController
- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Melody" target:self];
	}
	return _specifiers;
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return HEADER_HEIGHT;
	} else {
		return [super tableView:tableView heightForHeaderInSection:section];
	}
}
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		// add table header
        CGFloat width = self.view.frame.size.width - 40;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)];
        
        // Title Label
        UIFont *titleFont = [UIFont systemFontOfSize:32 weight:UIFontWeightThin];
        NSString *title = @"Melody";
        CGSize labelSize = [title boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, width, labelSize.height)];
        label.text = title;
        label.font = titleFont;
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 10.0f/12.0f;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [headerView addSubview:label];
        
        // Subtitle label
        UIFont *subtitleFont = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
        NSString *subtitle = @"by betas";
        CGSize subtitleLabelSize = [subtitle boundingRectWithSize:CGSizeMake(width, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:subtitleFont} context:nil].size;
        UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, width, subtitleLabelSize.height)];
        sublabel.text = subtitle;
        sublabel.font = subtitleFont;
        sublabel.numberOfLines = 1;
        sublabel.adjustsFontSizeToFitWidth = YES;
        sublabel.minimumScaleFactor = 10.0f/12.0f;
        sublabel.clipsToBounds = YES;
        sublabel.textAlignment = NSTextAlignmentCenter;
        sublabel.textColor = [UIColor darkGrayColor];
        [headerView addSubview:sublabel];
        
		return headerView;
	} else {
		return [super tableView:tableView viewForHeaderInSection:section];
	}
}

- (void)openDonate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/AppleBetasPay"]];
}

@end
