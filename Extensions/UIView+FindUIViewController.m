#import "UIView+FindUIViewController.h"

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForViewController];
}

- (id) traverseResponderChainForViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForViewController];
    } else {
        return nil;
    }
}
@end
