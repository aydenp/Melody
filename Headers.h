#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>

@class MusicApplicationController, MPCPlayer, MelodyApplicationControllerDelegate, MelodyEntityPlayabilityController;

@interface MusicNavigationController : UINavigationController
@end

@protocol SKUIApplicationDelegate <NSObject>
@end

@interface UIApplication (FuckThaPolice)
-(void)terminateWithSuccess;
@end

@interface SKUIScrollingTabBarPalette : UIView
@property (assign,getter=isAttached,nonatomic) BOOL attached;                                                                           //@synthesize attached=_attached - In the implementation block
@property (nonatomic,readonly) UIView * contentView;                                                                                    //@synthesize contentView=_contentView - In the implementation block
@property (nonatomic,readonly) double paletteHeight;                                                                                    //@synthesize paletteHeight=_paletteHeight - In the implementation block
@property (assign,nonatomic) BOOL tabBarBackgroundExtendsBehindPalette;                                                                 //@synthesize tabBarBackgroundExtendsBehindPalette=_tabBarBackgroundExtendsBehindPalette - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(void)traitCollectionDidChange:(id)arg1 ;
-(id)_delegate;
-(id)_backgroundView;
-(UIView *)contentView;
-(BOOL)isAttached;
-(void)_setDelegate:(id)arg1 ;
-(void)setTabBarBackgroundExtendsBehindPalette:(BOOL)arg1 ;
-(void)_setAttached:(BOOL)arg1 ;
-(double)paletteHeight;
-(BOOL)tabBarBackgroundExtendsBehindPalette;
@end

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(void)openSensitiveURL:(NSURL *)url withOptions:(id)options;
@end

@interface RadioRecentStationsController : NSObject
-(id)init;
@end

@protocol SKUIApplicationUpdatableAssetsDelegate <NSObject>
@end

@interface MPUReportingController : NSObject
-(id)init;
-(void)addChildReportingController:(id)arg1 ;
@end

@interface MPUReportingPlaybackObserver : NSObject
-(id)initWithPlayer:(id)arg1 reportingController:(id)arg2 ;
-(void)setStoreFrontID:(NSString *)arg1 ;
-(void)setStoreAccountID:(unsigned long long)arg1 ;
-(void)setOffline:(BOOL)arg1 ;
-(void)setSBEnabled:(BOOL)arg1 ;
@end

@interface MusicLibraryViewConfiguration : NSObject
-(id)newSelectionEntityValueContext;
@end

@interface MusicLibraryBrowseCollectionViewConfiguration : MusicLibraryViewConfiguration
@end

@interface MPUJinglePlayActivityReportingController : NSObject
-(id)initWithWritingStyle:(unsigned long long)arg1 ;
-(void)setShouldReportPlayActivityEvents:(BOOL)arg1 ;
-(void)setShouldReportAggregateTimePlayActivityEvents:(BOOL)arg1 ;
@end

@interface MusicApplicationDelegate : NSObject <UIApplicationDelegate>
@property (retain,nonatomic) MPCPlayer * player;
// Custom:
@property (nonatomic, retain) MusicApplicationController *_abAppController;
@property (nonatomic, retain) MelodyApplicationControllerDelegate *_abAppControllerDelegate;
@property (nonatomic, retain) MPUReportingController *reportingController;
@property (nonatomic, retain) MPUJinglePlayActivityReportingController *jinglePlayActivityReportingController;
@property (nonatomic, retain) MPUReportingPlaybackObserver *reportingPlaybackObserver;
@property (nonatomic, assign) BOOL shouldRelayoutIcons;
-(void)_updateTabBarItemsAnimated:(BOOL)animated;
-(void)_setupWindowIfNecessary;
@end

@interface SSVFairPlaySubscriptionStatus : NSObject
-(BOOL)hasSubscriptionSlot;
-(BOOL)hasSubscriptionLease;
@end

@protocol MusicEntityValueProviding <NSObject>
@optional
+(BOOL)supportsConcurrentLoadingOfEntityProperties;

@required
-(id)valueForEntityProperty:(id)arg1;
-(id)valuesForEntityProperties:(id)arg1;
@end

@interface MPUContentItemIdentifierCollection : NSObject
@end

@interface MusicEntityValueContext : NSObject
-(id<MusicEntityValueProviding>)entityValueProvider;
-(MPUContentItemIdentifierCollection *)itemIdentifierCollection;
@end

@interface MPCloudServiceStatusController : NSObject
+(id)sharedController;
-(void)beginObservingSubscriptionLease;
-(void)beginObservingSubscriptionStatus;
-(void)beginObservingCloudLibraryEnabled;
-(void)beginObservingFairPlaySubscriptionStatus;
-(void)endObservingFairPlaySubscriptionStatus;
-(SSVFairPlaySubscriptionStatus *)lastKnownFairPlaySubscriptionStatus;
@end

@interface MPNetworkObserver : NSObject
+(id)sharedNetworkObserver;
-(BOOL)isMusicCellularDownloadsAllowed;
-(BOOL)isMusicCellularDownloadingAllowed;
-(BOOL)isMusicCellularStreamingAllowed;
@end

@interface MPPlayerPlaybackLeaseController : NSObject
+(id)sharedController;
-(void)registerPlayer:(id)arg1 ;
@end

@interface MusicPlayableContentDelegate : NSObject
-(id)initWithPlayer:(id)arg1 ;
@end

@interface MPMediaQuery (PrivateAPI)
+(void)setFilteringDisabled:(BOOL)arg1 ;
@end

@interface MPMediaLibrary (PrivateAPI)
+(void)beginDiscoveringMediaLibraries;
-(void)addLibraryFilterPredicate:(id)arg1 ;
-(void)setCloudFilteringType:(long long)arg1 ;
@end

@interface MPUbiquitousPlaybackPositionController : NSObject
+(id)sharedUbiquitousPlaybackPositionController;
-(void)beginUsingPlaybackPositionMetadata;
@end

@interface MPUPlaybackAlertController : UIAlertController
+(id)contentRestrictedPlaybackAlertControllerForContentType:(long long)arg1 dismissalBlock:(/*^block*/id)arg2 ;
@end

@interface MusicAVPlayer : NSObject
+(MusicAVPlayer *)sharedAVPlayer;
-(void)setBanningCurrentItemShouldSkipToNextItem:(BOOL)banningCurrentItemShouldSkipToNextItem;
@end

@interface MusicPlaybackObserver : NSObject
+(MusicPlaybackObserver *)playbackObserverForPlayer:(id)player;
@end

@interface MusicGenreResourceImagesCatalog : NSObject
+(id)sharedGenreResourceImagesCatalog;
-(void)registerGenreResouceImages;
@end

// MARK: - Assets shit

@interface SSUpdatableAssetManifest : NSObject
-(NSString *)version;
@end

@interface SSUpdatableAssetController : NSObject
-(id)initWithBundledManifestURL:(id)arg1 clientIdentifier:(id)arg2 ;
-(NSURL *)manifestURL;
-(void)setManifestURL:(NSURL *)arg1 ;
-(SSUpdatableAssetManifest *)currentManifest;
@end

// MARK: - Need sorting:

@interface MusicApplicationCapabilitiesController : NSObject
+(id)shared;
-(BOOL)allowsConnectContent;
-(BOOL)allowsSubscriptionContent;
-(BOOL)hasNetworkConnectivity;
-(void)bagDidChange:(id)arg1 ;
-(BOOL)allowsRadioContent;
@end

@interface MusicNowPlayingContentView : UIView
@end

@interface MusicNowPlayingContentView (ClassicMusic)
-(UIImageView *)myImageView;
@end

@protocol MPUVibrantContentDisabling <NSObject>
@required
-(id)layersNotWantingVibrancy;
@end

@interface MPVolumeSlider : UISlider <MPUVibrantContentDisabling>
-(id)_thumbImageForStyle:(long long)arg1 ;
-(id)layersNotWantingVibrancy;
-(id)_minTrackImageForStyle:(long long)style;
-(id)_maxTrackImageForStyle:(long long)style;
@end

@interface MPButton : UIButton
@end

@interface MusicNowPlayingTransportButton : MPButton
@end

@interface MusicPlayerTimeControl: UIControl
-(BOOL)supportsDetailedScrubbing;
-(void)setSupportsDetailedScrubbing:(BOOL)arg1 ;
-(id)scrubbingDidChangeHandler;
-(void)setScrubbingDidChangeHandler:(id)arg1 ;
-(UIView *)elapsedTrack;
-(UIView *)remainingTrack;
-(UIView *)knobKnockoutView;
-(UILabel *)liveLabel;
-(UIImageView *)liveBackground;
-(void)set_tracking:(BOOL)arg1 ;
-(double)selectedElapsedTime;
-(void)setSelectedElapsedTime:(double)arg1 ;
-(double)accessibilityTotalDuration;
-(double)accessibilityElapsedDuration;
-(void)accessibilityUpdateWithElapsedDuration:(double)arg1 ;
-(BOOL)accessibilityIsLiveContent;
-(id)initWithFrame:(CGRect)arg1 ;
-(id)init;
-(CGRect)bounds;
-(void)layoutSubviews;
-(id)initWithCoder:(id)arg1 ;
-(void)dealloc;
-(BOOL)pointInside:(CGPoint)arg1 withEvent:(id)arg2 ;
-(void)didMoveToWindow;
-(void)setBounds:(CGRect)arg1 ;
-(void)setEnabled:(BOOL)arg1 ;
-(UIEdgeInsets)alignmentRectInsets;
-(void)tintColorDidChange;
-(CGSize)intrinsicContentSize;
-(id)viewForBaselineLayout;
-(void)cancelTrackingWithEvent:(id)arg1 ;
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(BOOL)continueTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(UILayoutGuide *)trackLayoutGuide;
-(BOOL)_tracking;
-(UILabel *)elapsedTimeLabel;
-(UILabel *)remainingTimeLabel;
-(UIView *)knobView;
@end

@interface MusicPlayerTimeControl (ClassicMusic)
@property (nonatomic, retain) UIView *_abKnobDisplayView;
@end

@interface MusicNowPlayingControlsViewController : UIViewController
-(UIButton *)dismissButton;
-(UILabel *)titleLabel;
-(UIButton *)subtitleButton;
-(UILayoutGuide *)artworkLayoutGuide;
-(void)setArtworkLayoutGuide:(UILayoutGuide *)guide;
-(MusicPlayerTimeControl *)timeControl;
-(UILayoutGuide *)trackLayoutGuide;
-(MusicNowPlayingContentView *)artworkView;
-(MPVolumeSlider *)volumeSlider;
-(void)setupForVibrancy;
-(UIStackView *)titlesStackView;
@end

@class ABMusicNowPlayingFloatingGlyphButton;
@interface MusicNowPlayingControlsViewController (ClassicMusic)
-(ABMusicNowPlayingFloatingGlyphButton *)_abDismissButton;
-(void)set_abDismissButton:(ABMusicNowPlayingFloatingGlyphButton *)_abDismissButton;
@end

@interface UIView (PrivateAPI)
-(void)_setContinuousCornerRadius:(double)arg1;
@end

@interface UIView (ClassicMusic)
@property (nonatomic, assign) BOOL continuousCornerRadiusShouldDie;
@end

@class MusicNowPlayingViewController;

@interface MusicNowPlayingPresentationController : UIViewController
-(UIViewController *)rootViewController;
-(CGRect)frameOfPresentedViewInContainerView;
-(MusicNowPlayingViewController *)nowPlayingViewController;
-(void)dismissalTransitionWillBegin;
@end

@interface MusicNowPlayingViewController : UIViewController
-(MusicNowPlayingPresentationController *)_transitionPresentationController;
-(UICollectionView *)collectionView;
-(UIVisualEffectView *)backgroundView;
-(MusicNowPlayingControlsViewController *)controlsViewController;
@end

@interface MPUEffectView : UIView
- (void)setEffectImage:(id)arg1;
- (void)setEffectSettings:(id)arg1;
@end

@interface MPUBlurEffectView : MPUEffectView
-(id)initWithFrame:(CGRect)arg1;
@end

@interface MPUGradientView : UIView
-(CAGradientLayer *)gradientLayer;
@end

@interface MPUVibrantContentEffectView : MPUEffectView
-(UIView *)contentView;
-(id)hitTest:(CGPoint)arg1 withEvent:(id)arg2 ;
-(void)tintColorDidChange;
-(void)setReferenceView:(id)arg1 ;
-(void)updateEffect;
-(UIImageView *)blurImageView;
-(void)setBlurImageView:(UIImageView *)arg1 ;
-(void)reenableVibrancyForLayer:(id)arg1 ;
-(id)_layersNotWantingVibrancyForSubviewsOfView:(id)arg1 ;
-(void)disableVibrancyForLayer:(id)arg1 ;
-(void)setVibrancyEnabled:(BOOL)arg1 ;
-(BOOL)vibrancyEnabled;
-(UIView *)maskedView;
-(void)setMaskedView:(UIView *)arg1 ;
-(UIView *)vibrantContainer;
-(void)setVibrantContainer:(UIView *)arg1 ;
-(UIView *)tintingView;
-(void)setTintingView:(UIView *)arg1 ;
-(NSMapTable *)layerPinningViewMap;
-(void)setLayerPinningViewMap:(NSMapTable *)arg1 ;
-(void)updateVibrancyForContentView;
-(void)setPlusDView:(UIView *)arg1 ;
-(UIView *)plusDView;
@end

@interface MusicNowPlayingViewController (ClassicMusic)
@property (nonatomic, retain) MPUBlurEffectView *blurryAlbumArtView;
@property (nonatomic, retain) NSArray *vibrancyViews;
@property (nonatomic, assign) BOOL hasSetObserver;
@property (nonatomic, assign) BOOL needsNewFrame;
-(UIImageView *)albumArtworkImageView;
-(void)handleImageViewChangeWithImage:(UIImage *)newImage;
-(void)doAlbumArtView;
-(UICollectionView *)collectionView;
-(void)addVibrancyView:(MPUVibrantContentEffectView *)vibrancyView;
-(void)removeVibrancyView:(MPUVibrantContentEffectView *)vibrancyView;
@end

@interface _UIBackdropViewSettings : NSObject
@property (assign,nonatomic) double blurRadius;
@property (assign,nonatomic) double grayscaleTintAlpha;
+(id)settingsForPrivateStyle:(long long)arg1;
@end

@interface MusicNowPlayingControlsHeader : UIView
-(UIView *)controlsView;
@end

@interface MusicNowPlayingControlsHeader (ClassicMusic)
@property (nonatomic, retain) MPUVibrantContentEffectView *vibrantView;
@end

@interface MusicTitleSectionHeaderView : UIView
-(void)setIsTopHairlineVisible:(BOOL)arg1;
-(void)setIsBottomHairlineVisible:(BOOL)arg1;
@end

@interface _UIBackdropView : UIView
-(id)initWithStyle:(long long)arg1;
@end


// MARK: - Playback APIs

@interface MPAVController : NSObject
@property (nonatomic,readonly) id feeder;
-(BOOL)hasVolumeControl;
-(id)_expectedAssetTypesForPlaybackMode:(long long)arg1 ;
-(void)togglePlayback;
-(void)play;
@end

@interface MPCMediaPlayerLegacyAVController : MPAVController
-(id)init;
-(void)dealloc;
-(void)_unregisterForPlaylistManager:(id)arg1 ;
-(void)playWithOptions:(unsigned long long)arg1 ;
-(void)_connectAVPlayer;
-(void)_registerForPlaylistManager:(id)arg1 ;
-(BOOL)jumpToItemWithContentID:(id)arg1 ;
-(void)setPlaylistManagerUUID:(NSUUID *)arg1 ;
-(NSUUID *)playlistManagerUUID;
-(void)setFallbackPlaybackContext:(id)arg1 ;
-(void)_playbackUserDefaultsEQPresetDidChangeNotification:(id)arg1 ;
-(void)_queueModificationsDidChangeNotification;
-(id)fallbackPlaybackContext;
@end

@interface MPCPlayer : NSObject
//@property (nonatomic,retain) MPRemoteCommandCenter * commandCenter;                                      //@synthesize commandCenter=_commandCenter - In the implementation block
//@property (nonatomic,readonly) AVPlayerLayer * videoLayer;                                               //@synthesize videoLayer=_videoLayer - In the implementation block
@property (nonatomic,copy,readonly) NSString * activeRouteName;                                          //@synthesize activeRouteName=_activeRouteName - In the implementation block
//@property (assign,nonatomic) MPCPlayerItemContainer * currentContainer;                                  //@synthesize currentContainer=_currentContainer - In the implementation block
//@property (assign,nonatomic) MPCPlayerItem * currentItem;                                                //@synthesize currentItem=_currentItem - In the implementation block
@property (nonatomic,copy,readonly) NSArray * nowPlayingInfoHandlers;
@property (nonatomic,copy,readonly) NSArray * playbackErrorObservers;
@property (nonatomic,copy,readonly) NSArray * playbackIntentObservers;
@property (getter=isRestoringPlaybackState,nonatomic,readonly) BOOL restoringPlaybackState;              //@synthesize restoringPlaybackState=_restoringPlaybackState - In the implementation block
@property (assign,nonatomic) long long state;                                                            //@synthesize state=_state - In the implementation block
+(Class)queueRequestOperationClass;
-(long long)state;
-(void)setState:(long long)arg1 ;
//-(MPCPlayerItem *)currentItem;
//-(void)setCurrentItem:(MPCPlayerItem *)arg1 ;
//-(AVPlayerLayer *)videoLayer;
//-(MPRemoteCommandCenter *)commandCenter;
//-(void)setCommandCenter:(MPRemoteCommandCenter *)arg1 ;
-(NSArray *)playbackIntentObservers;
-(void)recordLyricsViewEvent:(id)arg1 ;
-(void)preservePlaybackStateImmediately;
-(void)schedulePlaybackStatePreservation;
-(NSArray *)playbackErrorObservers;
-(void)performCommandEvent:(id)arg1 completion:(/*^block*/id)arg2 ;
//-(MPCPlayerItemContainer *)currentContainer;
-(void)addPlaybackIntent:(id)arg1 withOptions:(unsigned long long)arg2 completion:(/*^block*/id)arg3 ;
-(void)clearPlaybackQueueWithCompletion:(/*^block*/id)arg1 ;
-(BOOL)isRestoringPlaybackState;
-(void)restorePlaybackStateCompletionHandler:(/*^block*/id)arg1 ;
-(NSString *)activeRouteName;
-(NSArray *)nowPlayingInfoHandlers;
-(void)registerNowPlayingInfoHandler:(id)arg1 ;
-(void)registerPlaybackErrorObserver:(id)arg1 ;
-(void)registerPlaybackIntentObserver:(id)arg1 ;
-(void)unregisterNowPlayingInfoHandler:(id)arg1 ;
-(void)unregisterPlaybackErrorObserver:(id)arg1 ;
-(void)unregisterPlaybackIntentObserver:(id)arg1 ;
//-(void)setCurrentContainer:(MPCPlayerItemContainer *)arg1 ;
@end

@interface MPCMediaPlayerLegacyPlayer : MPCPlayer
@property (nonatomic,retain) MPCMediaPlayerLegacyAVController * player;                                  //@synthesize player=_player - In the implementation block
//@property (nonatomic,retain) MPCMediaPlayerLegacyNowPlayingObserver * playerObserver;                    //@synthesize playerObserver=_playerObserver - In the implementation block
//@property (nonatomic,retain) MPCMediaPlayerLegacyReportingController * reportingController;              //@synthesize reportingController=_reportingController - In the implementation block
//@property (nonatomic,retain) MPCRadioPlaybackCoordinator * radioPlaybackCoordinator;                     //@synthesize radioPlaybackCoordinator=_radioPlaybackCoordinator - In the implementation block
//@property (nonatomic,readonly) MPAVController * avController;
//@property (nonatomic,retain) RadioRecentStationsController * recentStationsController;
@property (assign,nonatomic) BOOL iAmTheiPod;                                                            //@synthesize iAmTheiPod=_iAmTheiPod - In the implementation block
@property (nonatomic,readonly) unsigned long long hardQueueItemCount;
@property (getter=isMediaRemoteSyncing,nonatomic,readonly) BOOL mediaRemoteSync;                         //@synthesize mediaRemoteSync=_mediaRemoteSync - In the implementation block
//@property (nonatomic,retain) MPCPlaybackIntent * fallbackPlaybackIntent;                                 //@synthesize fallbackPlaybackIntent=_fallbackPlaybackIntent - In the implementation block
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy,readonly) NSString * description;
@property (copy,readonly) NSString * debugDescription;
+(Class)queueRequestOperationClass;
-(id)init;
-(void)dealloc;
-(long long)state;
-(id)currentItem;
-(id)videoLayer;
-(void)_playbackStateChangedNotification:(id)arg1 ;
-(void)_availableRoutesDidChangeNotification:(id)arg1 ;
//-(void)setRecentStationsController:(RadioRecentStationsController *)arg1 ;
//-(RadioRecentStationsController *)recentStationsController;
//-(MPAVController *)avController;
-(id)contentItemForOffset:(long long)arg1 ;
-(id)contentItemIdentifierForOffset:(long long)arg1 ;
-(BOOL)remoteCommand:(id)arg1 isSupportedForContentItemIdentifier:(id)arg2 ;
-(BOOL)remoteCommand:(id)arg1 isEnabledForContentItemIdentifier:(id)arg2 ;
-(void)_contentsDidChangeNotification:(id)arg1 ;
-(MPCMediaPlayerLegacyAVController *)player;
-(void)setPlayer:(MPCMediaPlayerLegacyAVController *)arg1 ;
-(void)_updateSupportedCommands;
-(BOOL)_shouldVendContentItemForOffset:(long long)arg1 ;
-(void)_playerDidPausePlaybackForLeaseEndNotification:(id)arg1 ;
-(void)_currentItemChangedNotification:(id)arg1 ;
-(void)_repeatShuffleTypeChangedNotification:(id)arg1 ;
-(void)_playerPlaybackErrorNotification:(id)arg1 ;
-(void)_soundCheckEnabledChangedNotification:(id)arg1 ;
-(void)setIAmTheiPod:(BOOL)arg1 ;
-(void)stopMediaRemoteSync;
-(void)_reloadPlayerWithPlaybackContext:(id)arg1 completionHandler:(/*^block*/id)arg2 ;
-(void)_handleInsertIntoQueueCommandEvent:(id)arg1 completionHandler:(/*^block*/id)arg2 ;
-(void)_handleCreateRadioStationCommandEvent:(id)arg1 completionHandler:(/*^block*/id)arg2 ;
-(void)_handleSetQueueCommandEvent:(id)arg1 completionHandler:(/*^block*/id)arg2 ;
-(void)recordLyricsViewEvent:(id)arg1 ;
//-(MPCMediaPlayerLegacyReportingController *)reportingController;
-(void)preservePlaybackStateImmediately;
-(void)_refreshIAmTheiPod;
-(BOOL)isMediaRemoteSyncing;
-(void)_currentItemInvalidedCommandsNotification:(id)arg1 ;
-(void)schedulePlaybackStatePreservation;
-(id)_playerItemForAVItem:(id)arg1 ;
-(void)performCommandEvent:(id)arg1 completion:(/*^block*/id)arg2 ;
-(id)currentContainer;
-(void)addPlaybackIntent:(id)arg1 withOptions:(unsigned long long)arg2 completion:(/*^block*/id)arg3 ;
-(void)clearPlaybackQueueWithCompletion:(/*^block*/id)arg1 ;
-(void)registerWithPlaybackLeaseController:(id)arg1 ;
-(void)startMediaRemoteSync;
-(BOOL)isRestoringPlaybackState;
-(void)restorePlaybackStateCompletionHandler:(/*^block*/id)arg1 ;
//-(void)setFallbackPlaybackIntent:(MPCPlaybackIntent *)arg1 ;
-(id)activeRouteName;
-(unsigned long long)hardQueueItemCount;
//-(MPCPlaybackIntent *)fallbackPlaybackIntent;
//-(MPCMediaPlayerLegacyNowPlayingObserver *)playerObserver;
//-(void)setPlayerObserver:(MPCMediaPlayerLegacyNowPlayingObserver *)arg1 ;
//-(void)setReportingController:(MPCMediaPlayerLegacyReportingController *)arg1 ;
//-(MPCRadioPlaybackCoordinator *)radioPlaybackCoordinator;
//-(void)setRadioPlaybackCoordinator:(MPCRadioPlaybackCoordinator *)arg1 ;
-(BOOL)iAmTheiPod;
@end

// MARK: - StoreKit shit

@interface SKUIViewController : UIViewController
-(id)initWithTabBarItem:(id)arg1;
@end

@interface SKUIMutableApplicationControllerOptions : NSObject
@property (assign,nonatomic) BOOL supportsFullApplicationReload;
@property (assign,nonatomic) long long tabBarControllerStyle;
@property (assign,nonatomic) BOOL pageRenderMetricsEnabled;
@property (assign,nonatomic) BOOL requiresLocalBootstrapScript;
@property (assign,getter=isBootstrapScriptFallbackEnabled,nonatomic) BOOL bootstrapScriptFallbackEnabled;
@property (assign,nonatomic) double bootstrapScriptFallbackMaximumAge;
@property (assign,nonatomic) double bootstrapScriptTimeoutInterval;
-(id)init;
@end

@interface SKUINavigationDocumentController : NSObject
-(id)initWithNavigationController:(id)arg1 ;
@end

@interface SKUIApplicationController : NSObject
@property (nonatomic,copy) NSArray * tabBarItems;
@property (nonatomic,readonly) UIViewController * rootViewController;
@property (nonatomic,readonly) SKUINavigationDocumentController * _transientNavigationController;
@property (nonatomic,readonly) id scrollingTabBarController;
+(id)applicationOptionsWithLaunchOptions:(id)launchOptions;
-(id)initWithClientContextClass:(Class)arg1 options:(id)arg2 ;
-(void)_startScriptContextWithURL:(id)arg1 ;
-(void)_loadApplicationFromUpdatableAssetsCache:(id)arg1 ;
-(void)_setManifestURLOnUpdatableAssetController:(id)arg1 completion:(/*^block*/id)arg2 ;
-(void)_loadApplicationScript;
-(void)setDelegate:(id)arg1 ;
-(void)updateTabBarWithItems:(id)arg1 animated:(BOOL)arg2;
-(void)evaluateBlockWhenLoaded:(/*^block*/id)arg1 ;
-(id)selectTabWithIdentifier:(id)arg1 ;
@end

@interface MusicUserInterfaceStatusController : NSObject
+(MusicUserInterfaceStatusController *)sharedUserInterfaceStatusController;
-(void)beginObservingAllowedUserInterfaceComponents;
-(id)supportedTabIdentifiersForTraitCollection:(id)traitCollection;
-(NSString *)storeFrontID;
-(long long)tabState;
@end

@interface MusicStorePlaybackContext : NSObject
+(void)setDefaultClientContext:(id)arg1 ;
@end

@interface MusicModalNavigationStackRegistry : NSObject
+(id)sharedModalNavigationStackRegistry;
-(void)setClientContext:(id)arg1 ;
@end

@interface MusicDefaults : NSObject
+(id)sharedDefaults;
-(BOOL)isInternalInstall;
-(BOOL)isShowCloudMediaEnabled;
@end

@interface MPRestrictionsMonitor : NSObject 
+(id)sharedRestrictionsMonitor;
-(BOOL)allowsExplicitContent;
@end

@interface MusicLibrarySplitViewController : UIViewController
@end

@interface SKUIDocumentContainerViewController : UIViewController
-(id)initWithDocument:(id)arg1 options:(id)arg2 clientContext:(id)arg3 ;
@end

@interface MusicJSPlaybackCoordinator : NSObject
-(void)setPlayer:(MusicAVPlayer *)arg1 ;
@end

@interface MPCloudController : NSObject
+(id)sharedCloudController;
+(void)migrateCellularDataPreferencesIfNeeded;
-(void)becomeActive;
@end

@interface MusicClientContext : NSObject
@property (nonatomic,readonly) MusicJSPlaybackCoordinator *jsPlaybackCoordinator;
@property (nonatomic,readonly) RadioRecentStationsController *recentStationsController;
+(id)_fallbackConfigurationDictionary;
-(id)initWithConfigurationDictionary:(id)arg1 ;
-(void)evaluateClientJavaScriptInContext:(id)arg1 withAppContext:(id)arg2 ;
-(SSUpdatableAssetController *)updatableAssetController;
-(void)setRecentStationsController:(RadioRecentStationsController *)recentStationsController;
@end

@interface ISNetworkObserver : NSObject
+(id)sharedInstance;
-(long long)networkType;
@end

@interface SSAccount : NSObject
-(NSNumber *)uniqueIdentifier;
@end

@interface SSAccountStore : NSObject
+(id)defaultStore;
-(SSAccount *)activeAccount;
@end

@interface MusicContextualActionsHeaderViewController : UIViewController
@property (nonatomic,copy) void (^selectionHandler)();
@property (nonatomic,copy) void (^dismissRequestHandler)();
@end

@interface UIViewController (FuseUIShit)
-(UIViewController *)music_furthestPresentingViewController;
@end

@interface MusicApplicationController : SKUIApplicationController
@property (nonatomic,readonly) MusicClientContext *clientContext;
-(void)dealloc;
-(id)activeDocument;
-(void)loadApplicationWithOptions:(id)arg1 ;
-(Class)_JSITunesStoreClass;
-(BOOL)_sendNativeBackButtonMetricEvents;
-(BOOL)modalDocumentController:(id)arg1 willPushDocument:(id)arg2 options:(id)arg3 ;
-(id)modalDocumentController:(id)arg1 alertControllerForDocument:(id)arg2 withDismissObserverBlock:(/*^block*/id)arg3 options:(id)arg4 ;
-(void)uploadQueue:(id)arg1 uploadsDidChange:(id)arg2 ;
@end

@interface MusicRootViewController : UIViewController
@property (retain,nonatomic) UITabBarController *_tabBarController;
@end

@interface UIImage (AppleBetas)
+(UIImage *)_abTransformImage:(UIImage *)image named:(NSString *)name;
@end

@interface MusicStoreItemMetadataContext : NSObject
-(BOOL)isPlayable;
-(BOOL)isStoreRestricted;
@end

@interface MusicStoreEntityValueProvider : NSObject
-(MusicStoreItemMetadataContext *)storeItemMetadataContext;
@end

@interface SKUIScrollingTabBarController : UITabBarController
@property (assign,nonatomic) UIOffset additionalTabBarPalettePositionOffset;
-(void)attachTabBarPalette:(id)arg1 animated:(BOOL)arg2 completion:(/*^block*/id)arg3 ;
-(void)attachTabBarPalette:(id)arg1 ;
-(void)detachTabBarPalette:(id)arg1 ;
-(SKUIScrollingTabBarPalette *)existingTabBarPalette;
-(void)setClientContext:(id)arg1 ;
-(void)setTransientViewController:(id)arg1 animated:(BOOL)arg2 ;
-(void)detachTabBarPalette:(id)arg1 animated:(BOOL)arg2 completion:(/*^block*/id)arg3 ;
-(id)tabBarPaletteWithHeight:(double)arg1 ;
-(void)setChargeEnabledOnTabBarButtonsContainer:(BOOL)arg1 ;
@end

@protocol MusicEntityVerticalLockupViewDelegate <NSObject>
@optional
-(void)verticalLockupView:(id)arg1 didSelectPlayButtonAction:(unsigned long long)arg2;
@end

@interface MusicPlayButton : UIControl
-(void)showPlayIndicator:(BOOL)arg1 ;
-(void)setBigHitInsets:(UIEdgeInsets)insets;
-(CGSize)buttonSize;
@end

@interface MusicEntityPlaybackStatus : NSObject <NSCopying, NSMutableCopying>
@property (nonatomic,readonly) double playbackCurrentTime;
@property (nonatomic,readonly) long long playbackDisplayState;              //@synthesize playbackDisplayState=_playbackDisplayState - In the implementation block
@property (nonatomic,readonly) double playbackDuration;                     //@synthesize playbackDuration=_playbackDuration - In the implementation block
@property (nonatomic,readonly) float playbackRate;                          //@synthesize playbackRate=_playbackRate - In the implementation block
@property (nonatomic,readonly) BOOL shouldDisplayPlaying;
@end

@interface MusicEntityViewContentArtworkDescriptor : NSObject
-(UIEdgeInsets)artworkEdgeInsets;
@end

@interface MusicEntityViewContentDescriptor : NSObject
-(MusicEntityViewContentArtworkDescriptor *)artworkDescriptor;
@end

@interface MusicEntityAbstractLockupView : UIView
-(void)_handlePlayButtonTappedWithAction:(unsigned long long)arg1 ;
-(MusicEntityViewContentDescriptor *)_contentDescriptor;
-(BOOL)_shouldShowPlayButton;
-(void)_configurePlayButtonVisualProperties:(id)arg1 ;
-(void)_layoutPlayButtonUsingBlock:(void (^)(MusicPlayButton *playButton))arg1;
-(UIView *)_artworkView;
@end

@interface MusicEntityVerticalLockupView : MusicEntityAbstractLockupView
-(id<MusicEntityVerticalLockupViewDelegate>)delegate;
-(void)_handlePlayButtonTappedWithAction:(unsigned long long)arg1 ;
@end

@interface SKUITabBarItem : NSObject
@property (nonatomic,readonly) NSString * tabIdentifier;                               //@synthesize tabIdentifier=_tabIdentifier - In the implementation block
@property (assign,nonatomic) BOOL alwaysCreatesRootViewController;                     //@synthesize alwaysCreatesRootViewController=_alwaysCreatesRootViewController - In the implementation block
@property (assign,nonatomic) long long barTintStyle;                                   //@synthesize barTintStyle=_barTintStyle - In the implementation block
@property (nonatomic,copy) NSString * metricsIdentifier;                               //@synthesize metricsIdentifier=_metricsIdentifier - In the implementation block
@property (nonatomic,copy) NSURL * rootURL;                                            //@synthesize rootURL=_rootURL - In the implementation block
@property (nonatomic,retain) UIViewController * customRootViewController;              //@synthesize customRootViewController=_customRootViewController - In the implementation block
@property (nonatomic,retain) Class rootViewControllerClass;                            //@synthesize rootViewControllerClass=_rootViewControllerClass - In the implementation block
@property (nonatomic,retain) UITabBarItem * underlyingTabBarItem;                      //@synthesize underlyingTabBarItem=_underlyingTabBarItem - In the implementation block
@property (nonatomic,retain) UIColor * userInterfaceTintColor;                         //@synthesize userInterfaceTintColor=_userInterfaceTintColor - In the implementation block
-(id)initWithTabIdentifier:(id)arg1 ;
@end

@protocol MelodyPlayabilityObserving
@required
@property (nonatomic, retain) MelodyEntityPlayabilityController *playabilityController;
-(NSUInteger)_entityPlayabilityResultForEntityValueContext:(id)arg1;
-(void)_handleEntityPlayabilityControllerDidChangeNotification:(NSNotification *)notification;
@end

@interface MusicLibraryBrowseCollectionViewController : UIViewController <MelodyPlayabilityObserving>
-(MusicLibraryViewConfiguration *)libraryViewConfiguration;
-(void)_configureEntityValueContextOutput:(id)arg1 forIndexPath:(id)arg2 ;
@end

@interface MusicLibraryBrowseTableViewController : UIViewController <MelodyPlayabilityObserving>
-(MusicLibraryViewConfiguration *)libraryViewConfiguration;
-(void)_configureEntityValueContextOutput:(id)arg1 forIndexPath:(id)arg2 ;
@end

@protocol MelodySupportsEntityDisabledCell <NSObject>
@required
-(void)setEntityDisabled:(BOOL)arg1;
@end
