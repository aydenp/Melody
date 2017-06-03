#import "UIView+PinToSuperview.h"

@implementation UIView (PinToSuperview)

-(void)pinToSuperview {
    self.frame = self.superview.bounds;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
    [self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor].active = YES;
}

@end
