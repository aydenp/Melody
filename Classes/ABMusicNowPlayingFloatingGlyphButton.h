#import <UIKit/UIKit.h>
#import "../Extensions/UIView+PinToSuperview.h"
#import "../Extensions/UIButton+ExtendHitBox.h"
#import "../Headers.h"

@interface ABMusicNowPlayingFloatingGlyphButton : UIButton
@property (nonatomic,retain) UIImage *glyphImage;
@property (assign,nonatomic) UIOffset glyphImageOffset;

@property (nonatomic,retain) UIImageView *_glyphImageView;
@property (nonatomic,retain) _UIBackdropView *_backdropView;
@property (nonatomic,retain) NSLayoutConstraint *_glyphImageViewTopConstraint;
@property (nonatomic,retain) NSLayoutConstraint *_glyphImageViewLeadingConstraint;

-(id)initWithFrame:(CGRect)frame;

-(void)setGlyphImage:(UIImage *)glyphImage;
-(void)setGlyphImageOffset:(UIOffset)glyphImageOffset;
@end
