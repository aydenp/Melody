#import <UIKit/UIKit.h>

@class MelodyMiniPlayerViewController;

@interface MelodyMusicTabBarController : SKUIScrollingTabBarController
@property (nonatomic,retain) MPAVController * player;
@property (assign,getter=isMiniPlayerVisible,nonatomic) BOOL miniPlayerVisible;
@property (nonatomic,retain) MelodyMiniPlayerViewController *miniPlayerViewController;
@property (nonatomic,assign) BOOL _shouldIgnorePresentations;
@property (assign,nonatomic) BOOL _miniPlayerVisible;
@property (assign,nonatomic) BOOL _isMiniPlayerPresented;
-(void)dealloc;
-(void)viewDidLayoutSubviews;
-(void)viewDidLoad;
-(void)setTransientViewController:(id)arg1 animated:(BOOL)arg2 ;
-(void)setClientContext:(id)arg1 ;
-(void)presentNowPlayingViewControllerWithCompletion:(/*^block*/id)arg1 ;
-(void)presentMiniPlayerViewController;
-(void)dismissMiniPlayerViewController;
-(void)_playerContentsChangedNotification:(id)arg1 ;
-(void)_updateMiniPlayerVisiblity;
-(void)presentNowPlayingViewController;
-(void)setMiniPlayerVisible:(BOOL)arg1 ;
-(BOOL)isMiniPlayerVisible;
@end
