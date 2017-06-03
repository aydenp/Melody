//
//  DDCreditOption.m
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
