#import <UIKit/UIKit.h>
#import "../Headers.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MelodyEntityPlayabilityController : NSObject {
    dispatch_queue_t _accessQueue;
    char _cellularNetworkAllowed;
    BOOL _showCloudMediaEnabled;
    BOOL _hasValidNetworkType;
    long long _networkType;
}
-(void)dealloc;
-(id)init;
-(unsigned long long)entityPlayabilityResultForEntityValueContext:(id)arg1 ;
-(void)_musicDefaultsDidChangeNotification:(id)arg1 ;
-(void)_networkTypeDidChangeNotification:(id)arg1 ;
-(void)_cellularNetworkAllowedDidChangeNotification:(id)arg1 ;
-(void)_fairPlaySubscriptionStatusDidChangeNotification:(id)arg1 ;
-(void)_allowsExplicitContentDidChangeNotification:(id)arg1 ;
-(long long)_networkType;
-(BOOL)_isCellularNetworkAllowed;
+(BOOL)isCellularNetworkType:(long long)networkType;
@end
