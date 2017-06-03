#import <UIKit/UIKit.h>

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableViewController;
- (id) traverseResponderChainForViewController;
@end
