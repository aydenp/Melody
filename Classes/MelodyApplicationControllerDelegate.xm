#import "MelodyApplicationControllerDelegate.h"

@implementation MelodyApplicationControllerDelegate

-(id)init {
    self = [super init];
    if(self != nil) {
        _recentStationsController = [[%c(RadioRecentStationsController) alloc] init];
    }
    return self;
}

-(NSURL *)bundledUpdatableAssetsManifestURL {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(0x5, 0x2, 0x1);
    NSString *path = [[[searchPaths firstObject] stringByAppendingPathComponent:@"MusicUISupport"] stringByAppendingPathComponent:@"manifest.json"];
    return [NSURL fileURLWithPath:path];
}

-(NSURL *)updatableAssetsManifestURL {
    NSString *assetURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"MusicUpdatableAssetManifestURL"];
    if(assetURL == nil) {
        assetURL = (NSString *)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("MusicUpdatableAssetManifestURL"), CFSTR("com.apple.Fuse")));
    }
    return [NSURL URLWithString:assetURL];
}

-(void)application:(MusicApplicationController *)arg1 evaluateAppJavaScriptInContext:(id)arg2 JSContext:(id)arg3 {
    MusicClientContext *context = [arg1 clientContext];
    [context setRecentStationsController:_recentStationsController];
    [context evaluateClientJavaScriptInContext:arg3 withAppContext:arg2];
    [[context jsPlaybackCoordinator] setPlayer:[%c(MusicAVPlayer) sharedAVPlayer]];
}

-(void)applicationDidLoadFromUpdatableAssetsCache:(id)cache {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_MusicClientDidLoadNotification" object:nil];
}

-(BOOL)clearUpdatableAssetsCacheOnLaunch {
    Boolean keyExists = false;
    Boolean clear = CFPreferencesGetAppBooleanValue(CFSTR("MusicClearUpdatableAssetCacheOnLaunch"), CFSTR("com.apple.Music"), &keyExists);
    if (keyExists == false) {
        clear = CFPreferencesGetAppBooleanValue(CFSTR("MusicClearUpdatableAssetCacheOnLaunch"), CFSTR("com.apple.Fuse"), &keyExists);
    }
    return clear;
}

-(BOOL)loadApplicationAfterUpdatableAssetsRefresh {
    Boolean keyExists = false;
    Boolean load = CFPreferencesGetAppBooleanValue(CFSTR("MusicRefreshUpdatableAssetManifestOnLaunch"), CFSTR("com.apple.Music"), &keyExists);
    if (keyExists == false) {
        load = CFPreferencesGetAppBooleanValue(CFSTR("MusicRefreshUpdatableAssetManifestOnLaunch"), CFSTR("com.apple.Fuse"), &keyExists);
    }
    return load;
}

-(id)application:(MusicApplicationController *)application navigationControllerWithTabBarItem:(SKUITabBarItem *)tabBarItem {
    MusicNavigationController *navVC = [[%c(MusicNavigationController) alloc] init];
    NSString *tabID = tabBarItem.tabIdentifier;
    if(tabID != nil) {
        NSString *restorationIdentifier = [NSString stringWithFormat:@"navigation-%@", tabID];
        [navVC setRestorationIdentifier:restorationIdentifier];
    }
    return navVC;
}

-(BOOL)_isOfflineForReporting {
    return [[%c(ISNetworkObserver) sharedInstance] networkType] != 0x0;
}

-(unsigned long long)_storeAccountIdentifierForReporting {
    return [[[[%c(SSAccountStore) defaultStore] activeAccount] uniqueIdentifier] unsignedLongLongValue];
}

@end
