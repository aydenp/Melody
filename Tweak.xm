#import <UIKit/UIKit.h>
#import "Headers.h"
#import <MobileGestalt/MobileGestalt.h>
#import "Extensions/UIImage+Tinting.h"
#import "Extensions/UIView+FindUIViewController.h"
#import "Classes/ABMusicNowPlayingFloatingGlyphButton.h"
#import "Classes/MelodyMusicTabBarController.h"
#import "Classes/MelodyApplicationControllerDelegate.h"
#import "Classes/MelodyEntityPlayabilityController.h"

#define kFuseUIBundlePath @"/System/Library/PrivateFrameworks/FuseUI.framework"
#define FuseTableLocalizedString(key, tableName) [[NSBundle bundleWithPath:kFuseUIBundlePath] localizedStringForKey:(key) value:@"" table:(tableName)]
#define FuseLocalizedString(key) FuseTableLocalizedString(key, nil)

#define kBundlePath @"/var/mobile/Library/Application Support/ClassicMusic"
static NSURL *bundleURL = [NSURL fileURLWithPath:kBundlePath];
static NSBundle *resourceBundle = [NSBundle bundleWithPath:kBundlePath];
#define MelodyImage(name, ext) [UIImage imageWithContentsOfFile:[bundleURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", (name), (ext)]].path]

static int tapIndex = 0;

static void *FuseUI;
typedef void (*FuseUIFunction)(void);
FuseUIFunction _MusicDOMFeatureFactoryInitialize;
FuseUIFunction _MusicViewElementFactoryInitialize;
FuseUIFunction MusicRegisterResourceImages;

static SKUITabBarItem *createMusicUITabBarItem(NSString *identifier, NSString *localizedStringKey, NSString *localizedStringTable, UIImage *image, UIImage *selectedImage) {
    SKUITabBarItem *tabBarItem = [[%c(SKUITabBarItem) alloc] initWithTabIdentifier:identifier];
    tabBarItem.underlyingTabBarItem = [[UITabBarItem alloc] initWithTitle:FuseTableLocalizedString(localizedStringKey, localizedStringTable) image:image selectedImage:selectedImage];
    return tabBarItem;
}

static SKUITabBarItem *createMusicUITabBarItemWithMelodyImage(NSString *identifier, NSString *localizedStringKey, NSString *localizedStringTable, NSString *melodyImageName) {
    return createMusicUITabBarItem(identifier, localizedStringKey, localizedStringTable, MelodyImage(melodyImageName, @"png"), MelodyImage([melodyImageName stringByAppendingString:@"Selected"], @"png"));
}

static SKUITabBarItem *transformUITabBarItemForRootViewController(SKUITabBarItem *tabBarItem, Class rootViewControllerClass) {
    tabBarItem.rootViewControllerClass = rootViewControllerClass;
    tabBarItem.alwaysCreatesRootViewController = YES;
    return tabBarItem;
}

static MPCMediaPlayerLegacyPlayer *getRealPlayer() {
    MusicApplicationDelegate *delegate = (MusicApplicationDelegate *)[UIApplication sharedApplication].delegate;
    return (MPCMediaPlayerLegacyPlayer *)delegate.player;
}

static NSUInteger _MusicPlayButtonActionForPlaybackStatus(MusicEntityPlaybackStatus *arg0) {
    if (arg0 != 0x0) return ([arg0 shouldDisplayPlaying] & 0xff) + 0x1;
    return 0x3;
};

// MARK: - Loading Settings

static BOOL isEnabled = YES;
#define kPrefsPlistPath 		@"/var/mobile/Library/Preferences/applebetas.ios.tweak.melody.plist"
static void loadSettings() {
    // Thanks Sticktron for this line <3
    NSDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:kPrefsPlistPath];
    if (settings && settings[@"Enabled"]) isEnabled = [settings[@"Enabled"] boolValue];
}

static void settingsChanged(CFNotificationCenterRef center,
                            void *observer,
                            CFStringRef name,
                            const void *object,
                            CFDictionaryRef userInfo) {
    [[UIApplication sharedApplication] terminateWithSuccess];
}

// MARK: - Static Methods

static _UIBackdropViewSettings *getNowPlayingBlurEffect(BOOL forVibrancy) {
    _UIBackdropViewSettings *settings = [%c(_UIBackdropViewSettings) settingsForPrivateStyle:2010];
    settings.grayscaleTintAlpha = forVibrancy ? 0 : 0.62;
    settings.blurRadius = 60;
    return settings;
}

// MARK: - Tweak

%hook MusicNowPlayingChevronView

-(void)layoutSubviews {
    %log;
    [((UIView *)self) removeFromSuperview];
}

%end

%hook MusicArtworkComponentImageView

-(void)layoutSubviews {
    %orig;
    UIView *immaview = (UIView *)self;
    if([NSStringFromClass([immaview.superview class]) isEqualToString:@"Music.NowPlayingContentView"]) [immaview.layer setCornerRadius:0];
}

-(void)setFrame:(CGRect)frame {
    UIView *immaview = (UIView *)self;
    if([NSStringFromClass([immaview.superview class]) isEqualToString:@"Music.NowPlayingContentView"]) return %orig(immaview.superview.bounds);
    %orig;
}

%end

%hook UIView

%property (nonatomic, assign) BOOL continuousCornerRadiusShouldDie;

-(void)_setContinuousCornerRadius:(double)arg1 {
    if([self continuousCornerRadiusShouldDie]) arg1 = 0;
    %orig;
}

-(double)_continuousCornerRadius {
    return [self continuousCornerRadiusShouldDie] ? 0 : %orig;
}

%end

%hook MusicNowPlayingCollectionViewSecondaryBackground

-(UIColor *)backgroundColor {
    return [UIColor clearColor];
}

-(void)setBackgroundColor:(UIColor *)color {
    %orig([UIColor clearColor]);
}

%end

%hook MusicTitleSectionHeaderView

-(void)layoutSubviews {
    %orig;
    if([NSStringFromClass([((MusicTitleSectionHeaderView *)self).superview class]) isEqualToString:@"Music.NowPlayingCollectionView"]) {
        [(MusicTitleSectionHeaderView *)self setIsTopHairlineVisible:NO];
        [(MusicTitleSectionHeaderView *)self setIsBottomHairlineVisible:NO];
        [((MusicTitleSectionHeaderView *)self).layer setBackgroundColor:[UIColor clearColor].CGColor];
    }
}

-(UIColor *)backgroundColor {
    if([NSStringFromClass([((MusicTitleSectionHeaderView *)self).superview class]) isEqualToString:@"Music.NowPlayingCollectionView"]) return [UIColor clearColor];
    return %orig;
}

-(void)setBackgroundColor:(UIColor *)color {
    if([NSStringFromClass([((MusicTitleSectionHeaderView *)self).superview class]) isEqualToString:@"Music.NowPlayingCollectionView"]) return %orig([UIColor clearColor]);
        %orig;
}

%end

%hook MusicSongCell

-(UIColor *)backgroundColor {
    if([NSStringFromClass([((MusicTitleSectionHeaderView *)self).firstAvailableViewController class]) isEqualToString:@"Music.NowPlayingViewController"]) return [UIColor clearColor];
    return %orig;
}

-(void)setBackgroundColor:(UIColor *)color {
    if([NSStringFromClass([((MusicTitleSectionHeaderView *)self).firstAvailableViewController class]) isEqualToString:@"Music.NowPlayingViewController"]) return %orig([UIColor clearColor]);
        %orig;
}

%end

%hook MusicNowPlayingViewController

%property (nonatomic, retain) MPUBlurEffectView *blurryAlbumArtView;
%property (nonatomic, retain) NSArray *vibrancyViews;
%property (nonatomic, assign) BOOL hasSetObserver;
%property (nonatomic, assign) BOOL needsNewFrame;

-(void)viewDidLoad {
    %log;
    %orig;
    
    MusicNowPlayingViewController *vc = (MusicNowPlayingViewController *)self;
    [self doAlbumArtView];
    [vc.view setContinuousCornerRadiusShouldDie:YES];
    [vc.view _setContinuousCornerRadius:0];
    
    MPUGradientView *statusBarLegibilityView = [[%c(MPUGradientView) alloc] init];
    statusBarLegibilityView.userInteractionEnabled = NO;
    statusBarLegibilityView.gradientLayer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.24].CGColor, (id)[UIColor clearColor].CGColor];
    statusBarLegibilityView.gradientLayer.startPoint = CGPointZero;
    statusBarLegibilityView.gradientLayer.endPoint = CGPointMake(0, 1);
    statusBarLegibilityView.translatesAutoresizingMaskIntoConstraints = NO;
    [vc.collectionView addSubview:statusBarLegibilityView];
    [statusBarLegibilityView.heightAnchor constraintEqualToConstant:96].active = YES;
    [statusBarLegibilityView.widthAnchor constraintEqualToAnchor:vc.collectionView.widthAnchor].active = YES;
    [statusBarLegibilityView.topAnchor constraintEqualToAnchor:vc.collectionView.topAnchor].active = YES;
    [statusBarLegibilityView.leftAnchor constraintEqualToAnchor:vc.collectionView.leftAnchor].active = YES;
    [statusBarLegibilityView.rightAnchor constraintEqualToAnchor:vc.collectionView.rightAnchor].active = YES;
    
    ABMusicNowPlayingFloatingGlyphButton *dismissButton = [[ABMusicNowPlayingFloatingGlyphButton alloc] initWithFrame:CGRectMake(12, 28, 24, 24)];
    [dismissButton setGlyphImage:[[UIImage imageNamed:@"NowPlayingCollapseChevronMask" inBundle:resourceBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [dismissButton setGlyphImageOffset:UIOffsetMake(0, 1)];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    [dismissButton addTarget:[vc.controlsViewController.dismissButton.allTargets allObjects][0] action:@selector(handleActionFromControl:) forControlEvents:UIControlEventTouchUpInside];
    [vc.collectionView addSubview:dismissButton];
    [dismissButton.widthAnchor constraintEqualToConstant:24].active = YES;
    [dismissButton.heightAnchor constraintEqualToConstant:24].active = YES;
    [dismissButton.topAnchor constraintEqualToAnchor:vc.collectionView.topAnchor constant:28].active = YES;
    [dismissButton.leftAnchor constraintEqualToAnchor:vc.collectionView.leftAnchor constant:12].active = YES;
}

%new
-(void)doAlbumArtView {
    if(![self blurryAlbumArtView]) {
        %log;
        MusicNowPlayingViewController *vc = (MusicNowPlayingViewController *)self;
        // Create blurry view if not existing
        MPUBlurEffectView *blurryAlbumArtView = [[%c(MPUBlurEffectView) alloc] init];
        [vc.backgroundView.contentView addSubview:blurryAlbumArtView];
        [blurryAlbumArtView pinToSuperview];
        
        // Set it
        [vc setBlurryAlbumArtView:blurryAlbumArtView];
    }
}

-(void)dealloc {
    if([self hasSetObserver]) {
        %log;
        [[(MusicNowPlayingViewController *)self albumArtworkImageView] removeObserver:self forKeyPath:@"image"];
        [self setHasSetObserver:NO];
    }
    %orig;
}

%new
-(void)handleImageViewChangeWithImage:(UIImage *)newImage {
    %log;
    [(MusicNowPlayingViewController *)self doAlbumArtView];
    if (newImage && ![newImage isKindOfClass:[NSNull class]]) {
        [[(MusicNowPlayingViewController *)self blurryAlbumArtView] setEffectImage:newImage];
        for(MPUVibrantContentEffectView *vibrancyView in [self vibrancyViews]) {
            [vibrancyView setEffectImage:newImage];
        }
    }
}

%new
-(void)observeValueForKeyPath:(NSString *)path ofObject:(id) object change:(NSDictionary *) change context:(void *)context {
    %log;
    if ([object class] == [[(MusicNowPlayingViewController *)self albumArtworkImageView] class] && [path isEqualToString:@"image"]) {
        [(MusicNowPlayingViewController *)self handleImageViewChangeWithImage:[change objectForKey:NSKeyValueChangeNewKey]];
    }
}

%new
-(void)viewWillDisappear:(BOOL)arg1 {
    if([self hasSetObserver]) {
        %log;
        [[(MusicNowPlayingViewController *)self albumArtworkImageView] removeObserver:self forKeyPath:@"image"];
        [self setHasSetObserver:NO];
    }
}

-(void)viewDidAppear:(BOOL)arg1 {
    %orig;
    if(![self hasSetObserver]) {
        [self handleImageViewChangeWithImage:[(MusicNowPlayingViewController *)self albumArtworkImageView].image];
        [[(MusicNowPlayingViewController *)self blurryAlbumArtView] setEffectSettings:getNowPlayingBlurEffect(false)];
        [[(MusicNowPlayingViewController *)self albumArtworkImageView] addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:NULL];
        [self setHasSetObserver:YES];
    }
}

%new
-(UIImageView *)albumArtworkImageView {
    %log;
    return [[[(MusicNowPlayingViewController *)self controlsViewController] artworkView] myImageView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    %orig;
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(void)viewWillLayoutSubviews {
    %orig;
    if([self needsNewFrame]) [((MusicNowPlayingViewController *)self).view setFrame:[[((MusicNowPlayingViewController *)self) _transitionPresentationController] frameOfPresentedViewInContainerView]];
}

%new
-(void)addVibrancyView:(MPUVibrantContentEffectView *)vibrancyView {
    NSArray *arr = [self vibrancyViews];
    if(!arr) arr = [NSArray array];
    [self setVibrancyViews:[arr arrayByAddingObject:vibrancyView]];
}

%new
-(void)removeVibrancyView:(MPUVibrantContentEffectView *)vibrancyView {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self vibrancyViews]];
    [arr removeObject:vibrancyView];
    [self setVibrancyViews:[NSArray arrayWithArray:arr]];
}

%new
-(BOOL)prefersStatusBarHidden {
    return ((MusicNowPlayingViewController *)self).collectionView.contentOffset.y > 14;
}

%new
-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

%end

%hook MusicNowPlayingPresentationController

-(NSArray *)viewsToApplyCornerRadius {
    %log;
    return @[];
}

-(CGRect)frameOfPresentedViewInContainerView {
    %log;
    return ((MusicNowPlayingPresentationController *)self).rootViewController.view.bounds;
}
    
    
-(void)dismissalTransitionWillBegin {
    [(MusicNowPlayingViewController *)[self nowPlayingViewController] setNeedsNewFrame:NO];
    %orig;
}
    
-(void)presentationTransitionWillBegin {
    [(MusicNowPlayingViewController *)[self nowPlayingViewController] setNeedsNewFrame:YES];
    %orig;
}

%end
    
%hook MusicNowPlayingControlsHeader

%property (nonatomic, retain) MPUVibrantContentEffectView *vibrantView;
    
-(void)layoutSubviews {
    %orig;
    if([self controlsView]) {
        MPUVibrantContentEffectView *vibrant = [[%c(MPUVibrantContentEffectView) alloc] initWithFrame:((UIView *)self).frame];
        [self setVibrantView:vibrant];
        [(MusicNowPlayingViewController *)[self firstAvailableViewController] addVibrancyView:vibrant];
        [vibrant setEffectSettings:getNowPlayingBlurEffect(true)];
        [vibrant setEffectImage:[(MusicNowPlayingViewController *)[self firstAvailableViewController] albumArtworkImageView].image];
        [self addSubview:vibrant];
        [vibrant pinToSuperview];
        [((MusicNowPlayingControlsHeader *)self).controlsView removeFromSuperview];
        [vibrant.contentView addSubview:((MusicNowPlayingControlsHeader *)self).controlsView];
    }
}
    
-(void)dealloc {
    [(MusicNowPlayingViewController *)[((UIView *)self) firstAvailableViewController] removeVibrancyView:[self vibrantView]];
    %orig;
}
    
%end

%hook MusicNowPlayingControlsViewController
    
-(void)viewDidLoad {
    %orig;
    
    MusicNowPlayingControlsViewController *vc = (MusicNowPlayingControlsViewController *)self;
    
    // Layout setup
    UILayoutGuide *originalLayoutGuide = [vc artworkLayoutGuide];
    UILayoutGuide *newLayoutGuide = [[UILayoutGuide alloc] init];
    newLayoutGuide.identifier = originalLayoutGuide.identifier;
    [vc.view addLayoutGuide:newLayoutGuide];
    [vc setArtworkLayoutGuide:newLayoutGuide];
    
    // New artwork view constraints
    [newLayoutGuide.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [newLayoutGuide.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [newLayoutGuide.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [newLayoutGuide.heightAnchor constraintEqualToAnchor:newLayoutGuide.widthAnchor].active = YES;
    
    // Fix time control
    [newLayoutGuide.bottomAnchor constraintEqualToAnchor:vc.timeControl.topAnchor constant:16].active = YES;
    [vc.timeControl.heightAnchor constraintEqualToConstant:30 + 7].active = YES;
    for(NSLayoutConstraint *c in [vc.timeControl constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]) {
        if(c.firstItem == vc.timeControl && c.secondItem == originalLayoutGuide && c.firstAttribute == NSLayoutAttributeWidth) { c.active = NO; break; }
    }
    [vc.view.widthAnchor constraintEqualToAnchor:vc.timeControl.widthAnchor].active = YES;
}
    
%new
-(void)viewWillAppear:(BOOL)animated {
    [self setupForVibrancy];
}
    
%new
-(void)viewWillLayoutSubviews {
    %log;
    
    // Fix song info labels
    [self.titleLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
    [self.subtitleButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.subtitleButton setTintColor:[UIColor colorWithWhite:0 alpha:0.72]];
    [self.titlesStackView setSpacing:21];
    
    [self setupForVibrancy];
}
    
%new
-(void)setupForVibrancy {
    // Remove vibrancy from album art and sliders
    for (MPUVibrantContentEffectView *effectView in [(MusicNowPlayingViewController *)[self.view.superview firstAvailableViewController] vibrancyViews]) {
        [effectView disableVibrancyForLayer:[self artworkView].layer];
        [effectView disableVibrancyForLayer:[[self timeControl] _abKnobDisplayView].layer];
        [[self timeControl] _abKnobDisplayView].backgroundColor = self.view.tintColor;
        UIImageView *volumeSliderThumb = MSHookIvar<UIImageView *>([self volumeSlider], "_thumbImageView");
        [effectView disableVibrancyForLayer:volumeSliderThumb.layer];
    }
}
    
%end

%hook MusicNowPlayingDimmingView

-(void)layoutSubviews {
    %orig;
    [((UIView *)self) removeFromSuperview];
}

%end

%hook MusicNowPlayingContentView

-(void)layoutSubviews {
    %orig;
    [((UIView *)self).layer setShadowOpacity:0];
    for(UIView *subview in [((UIView *)self) subviews]) {
        if([subview isKindOfClass:[UIImageView class]] && ![NSStringFromClass([subview class]) isEqualToString:@"Music.ArtworkComponentImageView"]) [subview removeFromSuperview];
    }
}
    
%new
-(UIImageView *)myImageView {
    for(UIView *subview in [((UIView *)self) subviews]) {
        if([subview isKindOfClass:[UIImageView class]] && [NSStringFromClass([subview class]) isEqualToString:@"Music.ArtworkComponentImageView"]) return (UIImageView *)subview;
    }
    return nil;
}

%end

%hook MPVolumeSlider

-(CGRect)thumbRectForBounds:(CGRect)arg1 trackRect:(CGRect)arg2 value:(float)arg3 {
    CGRect rect = %orig;
    CGFloat diffWidth = rect.size.width - 21;
    CGFloat diffHeight = rect.size.height - 24;
    rect.size.width -= diffWidth;
    rect.size.height -= diffHeight;
    rect.origin.x += diffWidth / 2;
    rect.origin.y += diffHeight / 2;
    return rect;
}

-(void)setThumbImage:(id)arg1 forState:(unsigned long long)arg2 {
    %orig([self _thumbImageForStyle:1], arg2);
}

-(id)_minTrackImageForStyle:(long long)style {
    return [%orig imageWithTintColour:[UIColor colorWithWhite:0 alpha:0.5]];
}

-(id)_maxTrackImageForStyle:(long long)style {
    return [%orig imageWithTintColour:[UIColor colorWithWhite:0 alpha:0.2]];
}

-(void)setMaximumTrackImage:(UIImage *)image forState:(NSUInteger)state {
    %orig([self _maxTrackImageForStyle:1], state);
}

-(void)setMaximumTrackImage:(UIImage *)image forStates:(NSUInteger)states {
    %orig([self _maxTrackImageForStyle:1], states);
}

-(void)setMinimumTrackImage:(UIImage *)image forState:(NSUInteger)state {
    %orig([self _minTrackImageForStyle:1], state);
}

-(void)setMinimumTrackImage:(UIImage *)image forStates:(NSUInteger)states {
    %orig([self _minTrackImageForStyle:1], states);
}

-(void)setMinimumValueImage:(UIImage *)arg1 {
    %orig([arg1 imageWithTintColour:[UIColor colorWithWhite:0 alpha:0.5]]);
}

-(void)setMaximumValueImage:(UIImage *)arg1 {
    %orig([arg1 imageWithTintColour:[UIColor colorWithWhite:0 alpha:0.5]]);
}

%end

%hook MusicNowPlayingTransportButton

-(void)setHighlighted:(BOOL)highlighted {
    if(highlighted) {
        ((UIView *)self).alpha = 0.5f;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            ((UIView *)self).alpha = 1.0f;
        }];
    }
}

%end

%hook MusicPlayerTimeControl

%property (nonatomic, retain) UIView *_abKnobDisplayView;

-(void)didMoveToWindow {
    %orig;
    MusicPlayerTimeControl *control = (MusicPlayerTimeControl *)self;
    
    // Add knob display proxy view
    if([control _abKnobDisplayView]) [[control _abKnobDisplayView] removeFromSuperview];
    UIView *knobDisplayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 16)];
    [self set_abKnobDisplayView:knobDisplayView];
    [knobDisplayView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:knobDisplayView];
    [[self knobView] setHidden:YES];
    [[self knobView] setAlpha:0];
    
    // Configure track appearance
    [[control knobKnockoutView] removeFromSuperview];
    [[control remainingTrack] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    
    // Label appearance
    UIColor *labelColour = [UIColor colorWithWhite:0 alpha:0.72];
    UIFont *labelFont = [UIFont systemFontOfSize:11];
    [[control elapsedTimeLabel] setTextColor:labelColour];
    [[control remainingTimeLabel] setTextColor:labelColour];
    [[control elapsedTimeLabel] setFont:labelFont];
    [[control remainingTimeLabel] setFont:labelFont];
    for(NSLayoutConstraint *c in [[control elapsedTimeLabel] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]) {
        if(c.firstItem == [control elapsedTimeLabel] && c.secondItem == control && c.firstAttribute == NSLayoutAttributeLeading) { [c setConstant:12]; break; }
    }
    for(NSLayoutConstraint *c in [[control remainingTimeLabel] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]) {
        if(c.firstItem == [control remainingTimeLabel] && c.secondItem == control && c.firstAttribute == NSLayoutAttributeTrailing) { [c setConstant:-12]; break; }
    }
    for(NSLayoutConstraint *c in [[control elapsedTimeLabel] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]) {
        if(c.firstItem == [control elapsedTimeLabel] && c.secondItem == control && c.firstAttribute == NSLayoutAttributeBottom) { [c setConstant:9]; break; }
    }
    for(NSLayoutConstraint *c in [[control remainingTimeLabel] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]) {
        if(c.firstItem == [control remainingTimeLabel] && c.secondItem == control && c.firstAttribute == NSLayoutAttributeBottom) { [c setConstant:9]; break; }
    }
    
    
    // Modifying constraints at runtime fucking sucks
    for(NSLayoutConstraint *c in [[control remainingTrack] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]) {
        if(c.firstItem == [control remainingTrack] && c.secondItem == nil && c.firstAttribute == NSLayoutAttributeHeight) { [c setConstant:4]; break; }
    }
    for(NSLayoutConstraint *c in [[control elapsedTrack] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]) {
        if(c.firstItem == [control elapsedTrack] && c.secondItem == nil && c.firstAttribute == NSLayoutAttributeHeight) [c setConstant:4];
        if(c.secondItem == [control superview] && c.constant == 0 && c.firstAttribute == NSLayoutAttributeTop && c.secondAttribute == NSLayoutAttributeTop) [c setActive:NO];
    }
    //[[[control remainingTrack].heightAnchor constraintEqualToAnchor:[control elapsedTrack].heightAnchor] setActive:YES];
    for(NSLayoutConstraint *c in [[control knobView] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]) {
        if(c.firstItem == [control knobView] && c.secondItem == control && c.firstAttribute == NSLayoutAttributeCenterY && c.secondAttribute == NSLayoutAttributeCenterY) { c.active = NO; break; }
    }
    [[control knobView].topAnchor constraintEqualToAnchor:[control remainingTrack].topAnchor].active = YES;
    for(NSLayoutConstraint *c in [[control knobView] constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]) {
        if(c.firstItem == [control knobView] && c.secondItem == nil && c.firstAttribute == NSLayoutAttributeWidth) { [c setConstant:2]; break; }
    }
}

-(void)setTintColor:(UIColor *)arg1 {
    // Tints the elapsed portion of the track
    %orig([UIColor colorWithWhite:0 alpha:0.5]);
}

-(void)layoutSubviews {
    %orig;
    MusicPlayerTimeControl *control = (MusicPlayerTimeControl *)self;
    
    [[control remainingTrack].layer setCornerRadius:0];
    [[control elapsedTrack].layer setCornerRadius:0];
    
    CGRect knobFrame = [self knobView].frame;
    [[control _abKnobDisplayView] setFrame:CGRectMake(knobFrame.origin.x + (knobFrame.size.width != 0 ? knobFrame.size.width / 2 : 0), knobFrame.origin.y, 2, 16)];
}

%end

// MARK: - Tab Bar Controller

/*@interface MusicAccountBarButtonItem : UIBarButtonItem
+(id)accountBarButtonItemWithTarget:(id)arg1 action:(SEL)arg2 ;
-(void)dealloc;
-(id)init;
-(void)_updateEnabledState;
-(void)_allowsAccountModificationDidChangeNotification:(id)arg1 ;
@end

@implementation MusicAccountBarButtonItem

+(id)accountBarButtonItemWithTarget:(id)arg1 action:(SEL)arg2 {
    return [[UIBarButtonItem alloc] initWithImage:SKUIImageWithResourceName(@"account") style:0x0 target:arg1 action:arg2];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_MPRestrictionsMonitorAllowsAccountModificationDidChangeNotification" object:[%c(MPRestrictionsMonitor) sharedRestrictionsMonitor]];
}

-(id)init {
    self = [super init];
    if(self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_allowsAccountModificationDidChangeNotification:) name:@"_MPRestrictionsMonitorAllowsAccountModificationDidChangeNotification" object:[%c(MPRestrictionsMonitor) sharedRestrictionsMonitor]];
    }
    return self;
}

-(void)_updateEnabledState {
    [self setEnabled:[[%c(MPRestrictionsMonitor) sharedRestrictionsMonitor] allowsAccountModification]];
}

-(void)_allowsAccountModificationDidChangeNotification:(id)arg1 {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _updateEnabledState];
    });
}

@end

%hook MusicNavigationController

-(void)_installBarButtonsOnViewController:(id)arg1 isRootViewController:(BOOL)arg2 {
    if(arg2 && [[self class] automaticallyInstallAccountBarButtonItem]) {
        // add account button
    }
    %orig;
}

%end*/

%hook MusicContextualActionsHeaderViewController

-(void)contextualActionsHeaderLockupViewWasSelected:(id)arg1 {
    self.selectionHandler();
}

%end

@interface MelodyMiniPlayerViewController : UIViewController
@property (nonatomic,retain) MusicClientContext * clientContext;

@end

@implementation MelodyMiniPlayerViewController

@end

%subclass MelodyMusicTabBarController: SKUIScrollingTabBarController

%property (nonatomic,retain) MPAVController *player;
%property (assign,getter=isMiniPlayerVisible,nonatomic) BOOL miniPlayerVisible;
%property (nonatomic,retain) MelodyMiniPlayerViewController *miniPlayerViewController;
%property (nonatomic,assign) BOOL _shouldIgnorePresentations;
%property (assign,nonatomic) BOOL _miniPlayerVisible;
%property (assign,nonatomic) BOOL _isMiniPlayerPresented;

-(void)viewDidLoad {
    %orig;
    [self setChargeEnabledOnTabBarButtonsContainer:NO];
    self.miniPlayerViewController = [[MelodyMiniPlayerViewController alloc] init];
}

-(void)dealloc {
    if([self player] != nil) [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_MPAVControllerContentsChangedNotification" object:nil]; // TODO: Doubt this is the right notification name
}

-(void)viewDidLayoutSubviews {
    %orig;
    SKUIScrollingTabBarPalette *existingTabBarPalette = [self existingTabBarPalette];
    if(existingTabBarPalette != nil) {
        UIViewController *miniPlayerViewController = [self miniPlayerViewController];
        CGRect miniPlayerFrame = CGRectZero;
        if([existingTabBarPalette contentView] != nil) {
            miniPlayerFrame = [existingTabBarPalette contentView].bounds;
        }
        [[miniPlayerViewController view] setFrame:miniPlayerFrame];
    }
}

-(void)presentViewController:(id)vc animated:(BOOL)animated completion:(id)completion {
    BOOL _shouldIgnorePresentationsAfter = self._shouldIgnorePresentations;
    self._shouldIgnorePresentations = YES;
    
    UIViewController *furthestVC = [self music_furthestPresentingViewController];
    if(furthestVC != self) {
        [furthestVC presentViewController:vc animated:animated completion:completion];
    } else {
        %orig;
    }
    self._shouldIgnorePresentations = _shouldIgnorePresentationsAfter;
}

-(void)setTransientViewController:(id)vc animated:(BOOL)animated {
    %orig;
    if(vc != nil) {
        //MusicNowPlayingViewController *npVC = get now playing vc;
        //[self music_dismissViewController:npVC animated:animated];
    }
}

-(void)setClientContext:(id)arg1 {
    %orig;
    [[self miniPlayerViewController] setClientContext:arg1];
}

%new
-(void)presentNowPlayingViewControllerWithCompletion:(/*^block*/id)arg1 {
    // present now playing view controller and then run block
}

%new
-(void)presentMiniPlayerViewController {
    self._isMiniPlayerPresented = YES;
    SKUIScrollingTabBarPalette *paletteView;
    UIView *miniPlayerView = [self miniPlayerViewController].view;
    if([self existingTabBarPalette] != nil) {
        if([miniPlayerView superview] != [[self existingTabBarPalette] contentView]) {
            //BOOL whatTheFuckDoesThisDoLmao = [[self traitCollection] horizontalSizeClass] == 0x1;
            paletteView = [self tabBarPaletteWithHeight:miniPlayerView.bounds.size.height];
        }
    } else {
        paletteView = [self tabBarPaletteWithHeight:miniPlayerView.bounds.size.height];
    }
    CGRect miniPlayerFrame = CGRectZero;
    if([paletteView contentView] != nil) miniPlayerFrame = [paletteView bounds];
    [miniPlayerView setFrame:miniPlayerFrame];
    [paletteView addSubview:[self miniPlayerViewController].view];
    [self attachTabBarPalette:paletteView animated:[UIView areAnimationsEnabled] completion:^{
        [miniPlayerView setNeedsLayout];
    }];
}

%new
-(void)dismissMiniPlayerViewController {
    [self setAdditionalTabBarPalettePositionOffset:UIOffsetZero];
    [self detachTabBarPalette:[self existingTabBarPalette] animated:[UIView areAnimationsEnabled] completion:^{
        [[self miniPlayerViewController].view setNeedsLayout];
    }];
}

%new
-(void)_playerContentsChangedNotification:(id)arg1 {
    if([NSThread isMainThread]) {
        [self _updateMiniPlayerVisiblity];
    } else {
        [self performSelectorOnMainThread:@selector(_updateMiniPlayerVisiblity) withObject:nil waitUntilDone:YES];
    }
}

%new
-(void)_updateMiniPlayerVisiblity {
    [self setMiniPlayerVisible:[[self player] feeder] != nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self isMiniPlayerVisible] && [UIView areAnimationsEnabled]) {
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"nowPlayingWasPresentedForFirstPlay"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nowPlayingWasPresentedForFirstPlay"];
                [self presentNowPlayingViewController];
            }
        }
    });
}

%new
-(void)presentNowPlayingViewController {
    [self presentNowPlayingViewControllerWithCompletion:nil];
}

%new
-(void)setIsMiniPlayerVisible:(BOOL)arg1 {
    if(self._miniPlayerVisible != arg1) {
        self._miniPlayerVisible = arg1;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(arg1) [self presentNowPlayingViewController];
            else [self dismissMiniPlayerViewController];
        });
    }
}

%new
-(BOOL)isMiniPlayerVisible {
    return self._miniPlayerVisible;
}

%end

// MARK: - Setup

%hook MusicApplicationController

-(Class)_scrollingTabBarControllerClass {
    return %c(MelodyMusicTabBarController);
}

%end

%hook MusicApplicationDelegate

%property (nonatomic, retain) MusicApplicationController *_abAppController;
%property (nonatomic, retain) MelodyApplicationControllerDelegate *_abAppControllerDelegate;

%property (nonatomic, retain) MPUReportingController *reportingController;
%property (nonatomic, retain) MPUJinglePlayActivityReportingController *jinglePlayActivityReportingController;
%property (nonatomic, retain) MPUReportingPlaybackObserver *reportingPlaybackObserver;

%property (nonatomic, assign) BOOL shouldRelayoutIcons;

-(id)init {
    self = %orig;
    
    MelodyApplicationControllerDelegate *appControllerDelegate = [[MelodyApplicationControllerDelegate alloc] init];
    [self set_abAppControllerDelegate:appControllerDelegate];
    
    // Create status controller
    MusicUserInterfaceStatusController *sharedUserInterfaceStatusController = [%c(MusicUserInterfaceStatusController) sharedUserInterfaceStatusController];
    [sharedUserInterfaceStatusController beginObservingAllowedUserInterfaceComponents];
    
    // Add notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_supportedTabIdentifiersDidChangeNotification:) name:@"_MusicUserInterfaceSupportedTabIdentifiersDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_supportedTabIdentifiersDidChangeNotification:) name:@"MusicApplicationCapabilitiesControllerSupportedTabIdentifiersDidChangeNotification" object:nil];
    
    // Get cloud service status controller
    MPCloudServiceStatusController *cloudServiceStatusController = [%c(MPCloudServiceStatusController) sharedController];
    [cloudServiceStatusController beginObservingSubscriptionLease];
    [cloudServiceStatusController beginObservingSubscriptionStatus];
    [cloudServiceStatusController beginObservingCloudLibraryEnabled];
    [%c(MPMediaQuery) setFilteringDisabled:YES];
    
    // Do weird library filter shit
    MPMediaLibrary *library1 = [%c(MPMediaLibrary) defaultMediaLibrary];
    [library1 setCloudFilteringType:0x4];
    MPMediaLibrary *library2 = [%c(MPMediaLibrary) defaultMediaLibrary];
    MPMediaPropertyPredicate *libraryPredicate = [%c(MPMediaPropertyPredicate) predicateWithValue:@(0x801) forProperty:MPMediaItemPropertyMediaType];
    [library2 addLibraryFilterPredicate:libraryPredicate];
    
    // Do some shit with the player
    MusicAVPlayer *player = [%c(MusicAVPlayer) sharedAVPlayer];
    [player setBanningCurrentItemShouldSkipToNextItem:YES];
    
    MPPlayerPlaybackLeaseController *leaseController = [%c(MPPlayerPlaybackLeaseController) sharedController];
    [leaseController registerPlayer:player];
    
    //MusicPlaybackObserver *playbackObserver = [%c(MusicPlaybackObserver) playbackObserverForPlayer:player];
    
    FuseUI = dlopen("/System/Library/PrivateFrameworks/FuseUI.framework/FuseUI", RTLD_LAZY);
    
    _MusicDOMFeatureFactoryInitialize = (void (*)())dlsym(FuseUI, "MusicDOMFeatureFactoryInitialize");
    (*_MusicDOMFeatureFactoryInitialize)();
    
    _MusicViewElementFactoryInitialize = (void (*)())dlsym(FuseUI, "MusicViewElementFactoryInitialize");
    (*_MusicViewElementFactoryInitialize)();
    
    MusicGenreResourceImagesCatalog *genreCatalog = [%c(MusicGenreResourceImagesCatalog) sharedGenreResourceImagesCatalog];
    [genreCatalog registerGenreResouceImages];
    MusicRegisterResourceImages = (void (*)())dlsym(FuseUI, "MusicRegisterResourceImages");
    (*MusicRegisterResourceImages)();
    
    dlclose(FuseUI);
    
    // Radio shit. I've skipped it just bc
    
    SKUIMutableApplicationControllerOptions *appOptions = [[%c(SKUIMutableApplicationControllerOptions) alloc] init];
    appOptions.requiresLocalBootstrapScript = YES;
    appOptions.supportsFullApplicationReload = YES;
    appOptions.tabBarControllerStyle = 1;
    MusicApplicationController *appController = [[%c(MusicApplicationController) alloc] initWithClientContextClass:%c(MusicClientContext) options:appOptions];
    
    [appController setDelegate:appControllerDelegate];
    [appController evaluateBlockWhenLoaded:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"_MusicClientDidLoadNotification" object:nil];
    }];
    
    MusicClientContext *context = [appController clientContext];
    [%c(MusicStorePlaybackContext) setDefaultClientContext:context];
    
    MusicModalNavigationStackRegistry *navStackRegistry = [%c(MusicModalNavigationStackRegistry) sharedModalNavigationStackRegistry];
    [navStackRegistry setClientContext:context];
    
    id playableContentDelegate = [[%c(MusicPlayableContentDelegate) alloc] initWithPlayer:player];
    
    MPPlayableContentManager *playableContentManager = [%c(MPPlayableContentManager) sharedContentManager];
    [playableContentManager setDelegate:playableContentDelegate];
    
    [(MusicApplicationDelegate *)self set_abAppController:appController];
    
    [self _updateTabBarItemsAnimated:NO];
    
    return self;
}

-(BOOL)application:(id)arg1 willFinishLaunchingWithOptions:(id)arg2 {
    BOOL res = %orig;
    
    MusicApplicationDelegate *belf = (MusicApplicationDelegate *)self;
    
    // Setup our custom view controller
    [belf window].rootViewController = [belf _abAppController].rootViewController;
    [belf window].backgroundColor = [UIColor whiteColor];
    
    belf.reportingController = [[%c(MPUReportingController) alloc] init];
    belf.jinglePlayActivityReportingController = [[%c(MPUJinglePlayActivityReportingController) alloc] initWithWritingStyle:0x0];
    [belf.jinglePlayActivityReportingController setShouldReportPlayActivityEvents:YES];
    // r2 = MPUJinglePlayActivityReportingControllerHasProperAccountStatusForAggregateTimePlayActivityEventReporting();
    // [self.jinglePlayActivityReportingController setShouldReportAggregateTimePlayActivityEvents:r2];
    if(belf.jinglePlayActivityReportingController != nil) [belf.reportingController addChildReportingController:belf.jinglePlayActivityReportingController];
    RURTCReportingController *rtcReportingController = [[%c(RURTCReportingController) alloc] init];
    if(rtcReportingController != nil) [belf.reportingController addChildReportingController:rtcReportingController];
    
    belf.reportingPlaybackObserver = [[%c(MPUReportingPlaybackObserver) alloc] initWithPlayer:[%c(MusicAVPlayer) sharedAVPlayer] reportingController:belf.reportingController];
    [belf.reportingPlaybackObserver setOffline:[belf._abAppControllerDelegate _isOfflineForReporting]];
    [belf.reportingPlaybackObserver setStoreAccountID:[belf._abAppControllerDelegate _storeAccountIdentifierForReporting]];
    [belf.reportingPlaybackObserver setStoreFrontID:[[%c(MusicUserInterfaceStatusController) sharedUserInterfaceStatusController] storeFrontID]];
    
    MusicApplicationController *appController = [belf _abAppController];
    [appController.scrollingTabBarController setClientContext:[appController clientContext]];
    [appController.scrollingTabBarController setRestorationIdentifier:@"tabBarController"];
    
    // Radio & ad shit here?
    
    [[%c(MPUbiquitousPlaybackPositionController) sharedUbiquitousPlaybackPositionController] beginUsingPlaybackPositionMetadata];
    [[%c(MPMediaLibrary) defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
    
    return res;
}

-(BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    BOOL res = %orig;
    
    id launchOptions = [%c(MusicApplicationController) applicationOptionsWithLaunchOptions:arg2];
    [[(MusicApplicationDelegate *)self _abAppController] loadApplicationWithOptions:launchOptions];
    
    long long networkType = [[%c(ISNetworkObserver) sharedInstance] networkType];
    BOOL cellularNetworkAllowed = [[%c(MPNetworkObserver) sharedNetworkObserver] isMusicCellularDownloadingAllowed];
    if(([%c(MelodyEntityPlayabilityController) isCellularNetworkType:networkType] && !cellularNetworkAllowed) || networkType == 0) {
        // We're offline
        MusicUserInterfaceStatusController *statusController = [%c(MusicUserInterfaceStatusController) sharedUserInterfaceStatusController];
        if([statusController tabState] == 2) {
            // In subscription tab mode (Show Apple Music = on)
            UITraitCollection *traitCollection = [[UIScreen mainScreen] traitCollection];
            NSArray *supportedTabIDs = [statusController supportedTabIdentifiersForTraitCollection:traitCollection];
            NSString *tabToFocus = @"my_music";
            if([supportedTabIDs containsObject:@"library"]) tabToFocus = @"library";
            [[self _abAppController] selectTabWithIdentifier:tabToFocus];
        }
    }
    
    return res;
}

-(void)applicationWillEnterForeground:(id)arg1 {
    %orig;
    
    if(((MusicApplicationDelegate *)self).shouldRelayoutIcons) [self _updateTabBarItemsAnimated:YES];
    ((MusicApplicationDelegate *)self).shouldRelayoutIcons = NO;
}

%new
-(void)_updateTabBarItemsAnimated:(BOOL)animated {
    MusicUserInterfaceStatusController *uiStatusController = [%c(MusicUserInterfaceStatusController) sharedUserInterfaceStatusController];
    UITraitCollection *traitCollection = [[UIScreen mainScreen] traitCollection];
    NSArray *supportedTabIDs = [uiStatusController supportedTabIdentifiersForTraitCollection:traitCollection];
    NSMutableArray *tabs = [NSMutableArray new];
    NSArray *knownIDs = @[@"for_you", @"my_music", @"playlists", @"connect", @"new", @"radio", @"library"];
    for(NSString *tabID in supportedTabIDs) {
        if([knownIDs indexOfObject:tabID] != NSNotFound) {
            if([tabID isEqualToString:@"for_you"]) [tabs addObject:createMusicUITabBarItemWithMelodyImage(@"for_you", @"FOR_YOU", @"Subscription", @"UITabBarForYou")];
            else if([tabID isEqualToString:@"new"]) [tabs addObject:createMusicUITabBarItemWithMelodyImage(@"new", @"NEW", @"Subscription", @"UITabBarFeatured")];
            else if([tabID isEqualToString:@"radio"]) [tabs addObject:createMusicUITabBarItemWithMelodyImage(@"radio", @"RADIO", @"TabBar", @"UITabBarRadio")];
            else if([tabID isEqualToString:@"connect"]) [tabs addObject:createMusicUITabBarItemWithMelodyImage(@"connect", @"CONNECT", @"Subscription", @"UITabBarConnect")];
            else if([tabID isEqualToString:@"my_music"] || [tabID isEqualToString:@"library"]) [tabs addObject:transformUITabBarItemForRootViewController(createMusicUITabBarItemWithMelodyImage(@"my_music", @"MY_MUSIC", @"TabBar", @"UITabBarMusic"), [supportedTabIDs indexOfObject:@"playlists"] != NSNotFound ? %c(MusicLibrarySplitViewController) : %c(MusicMyMusicViewController))];
            else if([tabID isEqualToString:@"playlists"]) [tabs addObject:transformUITabBarItemForRootViewController(createMusicUITabBarItemWithMelodyImage(@"playlists", @"PLAYLISTS", @"TabBar", @"UITabBarPlaylists"), %c(MusicLibraryPlaylistsOverviewViewController))];
        }
    }
    if([self _abAppController].tabBarItems != nil) {
        [[self _abAppController] updateTabBarWithItems:[tabs copy] animated:animated];
    } else {
        [[self _abAppController] setTabBarItems:[tabs copy]];
    }
}

%new
-(void)_supportedTabIdentifiersDidChangeNotification:(NSNotification *)notification {
    ((MusicApplicationDelegate *)self).shouldRelayoutIcons = YES;
}

-(id)rootViewController {
    return nil;
}

%end

%hook UIStatusBar

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    tapIndex++;
    if(tapIndex >= 2) {
        tapIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"_MelodyStatusBarDoubleTapped" object:nil];
    } else {
        NSTimeInterval interval = 1; // one second wait for the second tap
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(tapIndex == 1) tapIndex = 0;
        });
    }
    %orig;
}

%end

%hook SKUIScrollingTabBarController

-(void)viewDidLoad {
    %orig;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_melodyStatusBarDoubleTapped:) name:@"_MelodyStatusBarDoubleTapped" object:nil];
    
}

%new
-(void)_melodyStatusBarDoubleTapped:(NSNotification *)notification {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Trigger Melody Crash?" message:@"To make getting system and crash logs easier, Melody has a built-in crash trigger function. It can be accessed any time by double-tapping the status bar.\nIf you would like to crash the Music app, tap \"Crash\" below. Afterwards, there should be a log in CrashReporter." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Crash" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSException* myException = [NSException
                                    exceptionWithName:@"MelodyFuckingSucksException"
                                    reason:@"Melody killed itself because it realized how terrible it really was."
                                    userInfo:nil];
        [myException raise];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Don't Crash" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%end

%group OtherStuff

// MARK: - Make playback work

%hook MusicAVPlayer

-(void)reloadWithPlaybackContext:(id)arg1 {
    [getRealPlayer() _reloadPlayerWithPlaybackContext:arg1 completionHandler:nil];
}

-(void)reloadWithPlaybackContext:(id)arg1 completionHandler:(/*^block*/id)arg2 {
    [getRealPlayer() _reloadPlayerWithPlaybackContext:arg1 completionHandler:arg2];
}

-(void)_connectAVPlayer {
    [getRealPlayer().player _connectAVPlayer];
}

-(id)_expectedAssetTypesForPlaybackMode:(long long)arg1 {
    return [getRealPlayer().player _expectedAssetTypesForPlaybackMode:arg1];
}

-(BOOL)hasVolumeControl {
    return [getRealPlayer().player hasVolumeControl];
}

-(id)contentItemForOffset:(long long)arg1 {
    return [getRealPlayer() contentItemForOffset:arg1];
}

-(id)contentItemIdentifierForOffset:(long long)arg1 {
    return [getRealPlayer() contentItemIdentifierForOffset:arg1];
}

-(BOOL)_shouldVendContentItemForOffset:(long long)arg1 {
    return [getRealPlayer() _shouldVendContentItemForOffset:arg1];
}

-(id)_fallbackMusicPlaybackContext {
    return [getRealPlayer().player fallbackPlaybackContext];
}

-(void)beginPlayback {
    [getRealPlayer().player play];
}

-(void)beginOrTogglePlayback {
    [getRealPlayer().player togglePlayback];
}

%end

// MARK: - Terrible fix for crash on selecitng view with hidden navigation bar

%hook _UIBarBackground

-(void)setCustomBackgroundView:(UIView *)subview {
    if(self == (_UIBarBackground *)subview) subview = nil;
    %orig;
}

%end

static void handleUnplayableEntityValueContext(MusicEntityValueContext *entityValueContext, NSUInteger playabilityResult, UIViewController *viewController) {
    UIAlertController *alert;
    BOOL canCellularData = MGGetBoolAnswer(CFSTR("cellular-data"));
    if(playabilityResult <= 4) {
        switch(playabilityResult) {
            case 1:
                alert = [%c(MPUPlaybackAlertController) contentRestrictedPlaybackAlertControllerForContentType:0x0 dismissalBlock:0x0];
                [viewController presentViewController:alert animated:YES completion:nil];
                break;
            case 2:
                alert = [UIAlertController alertControllerWithTitle:FuseTableLocalizedString(canCellularData ? @"PLAYBACK_DISABLED_NO_NETWORK_WIFI_CELLULAR_TITLE" : @"PLAYBACK_DISABLED_WIFI_TITLE", @"FuseUI") message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:FuseTableLocalizedString(@"PLAYBACK_DISABLED_SETTINGS_BUTTON_TITLE", @"FuseUI") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[%c(LSApplicationWorkspace) defaultWorkspace] openSensitiveURL:[NSURL URLWithString:@"prefs:"] withOptions:nil];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:FuseTableLocalizedString(@"OK", @"FuseUI") style:UIAlertActionStyleDefault handler:nil]];
                [viewController presentViewController:alert animated:YES completion:nil];
                break;
            case 3:
                alert = [UIAlertController alertControllerWithTitle:FuseTableLocalizedString(@"PLAYBACK_DISABLED_UNAVAILABLE_TITLE", @"FuseUI") message:FuseTableLocalizedString(@"PLAYBACK_DISABLED_UNAVAILABLE_MESSAGE", @"FuseUI") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:FuseTableLocalizedString(@"OK", @"FuseUI") style:UIAlertActionStyleDefault handler:nil]];
                [viewController presentViewController:alert animated:YES completion:nil];
                break;
            case 4:
                alert = [UIAlertController alertControllerWithTitle:FuseTableLocalizedString(@"PLAYBACK_DISABLED_WIFI_TITLE", @"FuseUI") message:FuseTableLocalizedString(@"PLAYBACK_DISABLED_CELL_RESTRICTED_WIFI_MESSAGE", @"FuseUI") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:FuseTableLocalizedString(@"PLAYBACK_DISABLED_SETTINGS_BUTTON_TITLE", @"FuseUI") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[%c(LSApplicationWorkspace) defaultWorkspace] openSensitiveURL:[NSURL URLWithString:@"prefs:root=MUSIC"] withOptions:nil];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:FuseTableLocalizedString(@"OK", @"FuseUI") style:UIAlertActionStyleDefault handler:nil]];
                [viewController presentViewController:alert animated:YES completion:nil];
                break;
        }
    }
}

%hook MusicLibraryBrowseCollectionViewController
%property (nonatomic, retain) MelodyEntityPlayabilityController *playabilityController;

-(void)viewDidLoad {
    %orig;
    self.playabilityController = [[MelodyEntityPlayabilityController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleEntityPlayabilityControllerDidChangeNotification:) name:@"MusicEntityPlayabilityControllerDidChangeNotification" object:self.playabilityController];
}

%new
-(NSUInteger)_entityPlayabilityResultForEntityValueContext:(id)arg1 {
    return [self.playabilityController entityPlayabilityResultForEntityValueContext:arg1];
}

-(void)_updateEntityDisabledStateForCell:(id)cell withEntityValueContext:(id)context {
    if([cell respondsToSelector:@selector(setEntityDisabled:)]) {
        NSUInteger playabilityResult = [self _entityPlayabilityResultForEntityValueContext:context];
        [(id<MelodySupportsEntityDisabledCell>)cell setEntityDisabled:playabilityResult != 0];
    }
}

-(void)collectionView:(UICollectionView *)arg1 didSelectItemAtIndexPath:(id)arg2 {
    MusicLibraryViewConfiguration *viewConfig = [self libraryViewConfiguration];
    if (viewConfig != nil) {
        MusicEntityValueContext *selectionEntityValueContext = [viewConfig newSelectionEntityValueContext];
        [self _configureEntityValueContextOutput:selectionEntityValueContext forIndexPath:arg2];
        NSUInteger playabilityResult = [self _entityPlayabilityResultForEntityValueContext:selectionEntityValueContext];
        if (playabilityResult != 0) {
            handleUnplayableEntityValueContext(selectionEntityValueContext, playabilityResult, self);
            [arg1 deselectItemAtIndexPath:arg2 animated:YES];
        } else {
            %orig;
        }
    }
}

%end

%hook MusicLibraryBrowseTableViewController
%property (nonatomic, retain) MelodyEntityPlayabilityController *playabilityController;

-(void)viewDidLoad {
    %orig;
    self.playabilityController = [[MelodyEntityPlayabilityController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleEntityPlayabilityControllerDidChangeNotification:) name:@"MusicEntityPlayabilityControllerDidChangeNotification" object:self.playabilityController];
}

%new
-(NSUInteger)_entityPlayabilityResultForEntityValueContext:(id)arg1 {
    return [self.playabilityController entityPlayabilityResultForEntityValueContext:arg1];
}

-(void)_updateEntityDisabledStateForView:(id)view withEntityValueContext:(id)context {
    if([view respondsToSelector:@selector(setEntityDisabled:)]) {
        NSUInteger playabilityResult = [self _entityPlayabilityResultForEntityValueContext:context];
        [(id<MelodySupportsEntityDisabledCell>)view setEntityDisabled:playabilityResult != 0];
    }
}

-(void)tableView:(UITableView *)arg1 didSelectRowAtIndexPath:(id)arg2 {
    MusicLibraryViewConfiguration *viewConfig = [self libraryViewConfiguration];
    if (viewConfig != nil) {
        MusicEntityValueContext *selectionEntityValueContext = [viewConfig newSelectionEntityValueContext];
        [self _configureEntityValueContextOutput:selectionEntityValueContext forIndexPath:arg2];
        NSUInteger playabilityResult = [self _entityPlayabilityResultForEntityValueContext:selectionEntityValueContext];
        if (playabilityResult != 0) {
            handleUnplayableEntityValueContext(selectionEntityValueContext, playabilityResult, self);
            [arg1 deselectRowAtIndexPath:arg2 animated:YES];
        } else {
            %orig;
        }
    }
}

%end

// MARK: - Restore Old Tab Layout

%hook MusicStoreBag

-(id)initWithBagDictionary:(NSDictionary *)bagDict {
    NSMutableDictionary *bagDictM = [bagDict mutableCopy];
    [bagDictM setObject:@"t:music2" forKey:@"storefront-header-suffix"];
    [bagDictM setObject:@{
                            @"undecided": @[@{@"id": @"my_music"}, @{@"id": @"playlists"}, @{@"id": @"for_you", @"url": @"https://se2.itunes.apple.com/WebObjects/MZStoreElements2.woa/wa/justForYou"}, @{@"id": @"new"}, @{@"id": @"radio"}, @{@"id": @"connect"}],
                            @"classic": @[@{@"id": @"my_music"}, @{@"id": @"playlists"}, @{@"id": @"radio"}, @{@"id": @"connect"}, @{@"id": @"genius_mixes"}],
                            @"subscriber": @[@{@"id": @"for_you", @"url": @"https://se2.itunes.apple.com/WebObjects/MZStoreElements2.woa/wa/justForYou"}, @{@"id": @"new"}, @{@"id": @"radio"}, @{@"id": @"connect"}, @{@"id": @"my_music"}, @{@"id": @"playlists"}]
    } forKey:@"musicTabs"];
    return %orig([bagDictM copy]);
}

%end

%hook UIImage

+(id)imageNamed:(id)arg1 inBundle:(id)arg2 compatibleWithTraitCollection:(id)arg3 {
    return [UIImage _abTransformImage:%orig named:arg1];
}
+(id)imageNamed:(id)arg1 {
    return [UIImage _abTransformImage:%orig named:arg1];
}

+(id)imageNamed:(id)arg1 inBundle:(id)arg2 {
    return [UIImage _abTransformImage:%orig named:arg1];
}

%new
+(UIImage *)_abTransformImage:(UIImage *)image named:(NSString *)name {
    if([name isEqualToString:@"NowPlayingPlaybackModeShuffle"]) {
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return image;
}

%end

// MARK: - We need play buttons

%hook MusicEntityAbstractLockupView

%new
-(void)_layoutPlayButtonUsingBlock:(void (^)(MusicPlayButton *playButton))arg1 {
    MusicPlayButton *playButton = MSHookIvar<MusicPlayButton *>(self, "_playButton");
    if([self _shouldShowPlayButton]) {
        if(playButton == nil) {
            playButton = [[%c(MusicPlayButton) alloc] init];
            [playButton showPlayIndicator:YES];
            [playButton addTarget:self action:@selector(_playButtonTapped:) forControlEvents:0x40];
            [playButton setBigHitInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];
            [self _configurePlayButtonVisualProperties:playButton];
            [self addSubview:playButton];
            //[playButton _applyPlaybackStatus:_playbackStatus];
            arg1(playButton);
        }
        [playButton setHidden:NO];
    } else {
        [playButton setHidden:YES];
    }
}

%new
-(void)_playButtonTapped:(id)arg1 {
    int action = 0x0;//_MusicPlayButtonActionForPlaybackStatus(self->_playbackStatus);
    if(action != 0x0) [self _handlePlayButtonTappedWithAction:action];
}

%end

// MARK: - Add Play button back to recently added items

%hook MusicEntityVerticalLockupView

%new
-(void)_handlePlayButtonTappedWithAction:(unsigned long long)arg1 {
    id<MusicEntityVerticalLockupViewDelegate> delegate = [self delegate];
    if(delegate && [delegate respondsToSelector:@selector(verticalLockupView:didSelectPlayButtonAction:)]) {
        [delegate verticalLockupView:self didSelectPlayButtonAction:arg1];
    }
}

-(void)layoutSubviews {
    %orig;
    [self _layoutPlayButtonUsingBlock:^(MusicPlayButton *playButton) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(8 + playButton.buttonSize.height, 8 + playButton.buttonSize.width, 8 + playButton.buttonSize.height, 8 + playButton.buttonSize.width);
        MusicEntityViewContentArtworkDescriptor *artworkDescriptor = [[self _contentDescriptor] artworkDescriptor];
        if(artworkDescriptor != nil) {
            edgeInsets.top += artworkDescriptor.artworkEdgeInsets.top;
            edgeInsets.bottom += artworkDescriptor.artworkEdgeInsets.bottom;
            edgeInsets.left += artworkDescriptor.artworkEdgeInsets.left;
            edgeInsets.right += artworkDescriptor.artworkEdgeInsets.right;
        }
        CGRect playButtonFrame = UIEdgeInsetsInsetRect([self _artworkView].frame, edgeInsets);
        [playButton setFrame:CGRectMake(CGRectGetMaxX(playButtonFrame), CGRectGetMaxY(playButtonFramegi), playButton.frame.size.width, playButton.frame.size.height)];
    }];
}

%end

%end

// MARK: - Constructor

%ctor {
    @autoreleasepool {
        loadSettings();
        NSLog(@"Loaded settings. Is enabled: %@", isEnabled ? @"Y" : @"N");
        
        if (isEnabled) {
            %init(MusicNowPlayingChevronView = NSClassFromString(@"Music.NowPlayingChevronView"),
                  MusicNowPlayingContentView = NSClassFromString(@"Music.NowPlayingContentView"),
                  MusicNowPlayingDimmingView = NSClassFromString(@"Music.NowPlayingDimmingView"),
                  MusicArtworkComponentImageView = NSClassFromString(@"Music.ArtworkComponentImageView"),
                  MusicNowPlayingViewController = NSClassFromString(@"Music.NowPlayingViewController"),
                  MusicNowPlayingPresentationController = NSClassFromString(@"Music.NowPlayingPresentationController"),
                  MusicNowPlayingControlsHeader = NSClassFromString(@"Music.NowPlayingControlsHeader"),
                  MusicNowPlayingTransportButton = NSClassFromString(@"Music.NowPlayingTransportButton"),
                  MusicPlayerTimeControl = NSClassFromString(@"Music.PlayerTimeControl"),
                  MusicNowPlayingCollectionViewSecondaryBackground = NSClassFromString(@"Music.NowPlayingCollectionViewSecondaryBackground"),
                  MusicTitleSectionHeaderView = NSClassFromString(@"Music.TitleSectionHeaderView"),
                  MusicSongCell = NSClassFromString(@"Music.SongCell"),
                  MusicApplicationDelegate = NSClassFromString(@"Music.ApplicationDelegate"));
            %init(OtherStuff);
        }

        // listen for notifications from settings
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)settingsChanged, CFSTR("applebetas.ios.tweak.melody.changed"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
}
