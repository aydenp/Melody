#import <UIKit/UIKit.h>
#import "../Headers.h"

@interface MelodyApplicationControllerDelegate : NSObject <SKUIApplicationDelegate, SKUIApplicationUpdatableAssetsDelegate> {
    RadioRecentStationsController *_recentStationsController;
}
-(id)init;
-(NSURL *)bundledUpdatableAssetsManifestURL;
-(NSURL *)updatableAssetsManifestURL;
-(void)application:(MusicApplicationController *)arg1 evaluateAppJavaScriptInContext:(id)arg2 JSContext:(id)arg3;
-(void)applicationDidLoadFromUpdatableAssetsCache:(id)cache;
-(BOOL)clearUpdatableAssetsCacheOnLaunch;
-(BOOL)loadApplicationAfterUpdatableAssetsRefresh;
-(id)application:(MusicApplicationController *)application navigationControllerWithTabBarItem:(SKUITabBarItem *)tabBarItem;
-(BOOL)_isOfflineForReporting;
-(unsigned long long)_storeAccountIdentifierForReporting;
@end
