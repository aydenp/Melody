//
//  DDCreditService.m
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
