#import "ABMusicNowPlayingFloatingGlyphButton.h"

@implementation ABMusicNowPlayingFloatingGlyphButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.glyphImageOffset = UIOffsetZero;
    
    self._backdropView = [[_UIBackdropView alloc] initWithStyle:2010];
    self._backdropView.userInteractionEnabled = NO;
    [self._backdropView.layer setMasksToBounds:YES];
    [self addSubview:self._backdropView];
    [self._backdropView pinToSuperview];
    
    self._glyphImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self._glyphImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self._glyphImageView.userInteractionEnabled = NO;
    self._glyphImageView.tintColor = [UIColor colorWithWhite:0.22 alpha:1];
    [self addSubview:self._glyphImageView];
    self._glyphImageViewLeadingConstraint = [self._glyphImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:self.glyphImageOffset.vertical];
    self._glyphImageViewTopConstraint = [self._glyphImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:self.glyphImageOffset.horizontal];
    self._glyphImageViewLeadingConstraint.active = YES;
    self._glyphImageViewTopConstraint.active = YES;
    
    [self.layer setShadowRadius:3];
    [self.layer setShadowOffset:CGSizeZero];
    [self _doShadow];
    
    return self;
}

-(CGSize)sizeThatFits:(CGSize)arg1 {
    return CGSizeMake(24, 24);
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self _doShadow];
}

-(void)setGlyphImage:(UIImage *)glyphImage {
    if(_glyphImage == glyphImage) return;
    _glyphImage = glyphImage;
    [self._glyphImageView setImage:glyphImage];
}

-(void)setGlyphImageOffset:(UIOffset)glyphImageOffset {
    _glyphImageOffset = glyphImageOffset;
    self._glyphImageViewTopConstraint.constant = self.glyphImageOffset.vertical;
    self._glyphImageViewLeadingConstraint.constant = self.glyphImageOffset.horizontal;
}

-(void)_doShadow {
    CGFloat corner = fmin(self.bounds.size.width, self.bounds.size.height) / 2;
    [self._backdropView.layer setCornerRadius:corner];
    [self.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:corner].CGPath];
    [self.layer setShadowOpacity:0.3];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self._glyphImageView setAlpha:highlighted ? 0.5 : 1];
}

@end

