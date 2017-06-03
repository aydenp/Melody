#import "UIImage+Tinting.h"

@implementation UIImage (Tinting)

-(UIImage *)imageWithTintColour:(UIColor *)tintColour {
    UIImage *newImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, newImage.scale);
    [tintColour set];
    [newImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [newImage resizableImageWithCapInsets:self.capInsets resizingMode:self.resizingMode];
}

@end
