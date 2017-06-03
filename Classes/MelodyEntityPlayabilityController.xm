#import "MelodyEntityPlayabilityController.h"

@implementation MelodyEntityPlayabilityController

-(id)init {
    self = [super init];
    if (self) {
        self->_accessQueue = dispatch_queue_create("com.apple.FuseUI.MusicEntityPlayabilityController.accessQueue", DISPATCH_QUEUE_CONCURRENT);
        [self _setupCellularNetworkingAllowed];
        self->_showCloudMediaEnabled = [[%c(MusicDefaults) sharedDefaults] isShowCloudMediaEnabled];
        MPCloudServiceStatusController *cloudService = [%c(MPCloudServiceStatusController) sharedController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_cellularNetworkAllowedDidChangeNotification:) name:@"MPNetworkObserverIsMusicCellularNetworkingAllowedDidChangeNotification" object:[%c(MPNetworkObserver) sharedNetworkObserver]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_cellularNetworkAllowedDidChangeNotification:) name:@"MPNetworkObserverIsMusicCellularStreamingAllowedDidChangeNotification" object:[%c(MPNetworkObserver) sharedNetworkObserver]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_networkTypeDidChangeNotification:) name:@"ISNetworkTypeChangedNotification" object:[%c(ISNetworkObserver) sharedInstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_fairPlaySubscriptionStatusDidChangeNotification:) name:@"MPCloudServiceStatusControllerFairPlaySubscriptionStatusDidChangeNotification" object:cloudService];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_allowsExplicitContentDidChangeNotification:) name:@"MPRestrictionsMonitorAllowsExplicitContentDidChangeNotification" object:[%c(MPRestrictionsMonitor) sharedRestrictionsMonitor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_musicDefaultsDidChangeNotification:) name:@"MPUApplicationDefaultsDidChangeNotification" object:[%c(MusicDefaults) sharedDefaults]];
        [cloudService beginObservingFairPlaySubscriptionStatus];
    }
    return self;
}

-(void)dealloc {
    MPCloudServiceStatusController *cloudService = [%c(MPCloudServiceStatusController) sharedController];
    [cloudService endObservingFairPlaySubscriptionStatus];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPNetworkObserverIsMusicCellularNetworkingAllowedDidChangeNotification" object:[%c(MPNetworkObserver) sharedNetworkObserver]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ISNetworkTypeChangedNotification" object:[%c(ISNetworkObserver) sharedInstance]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPCloudServiceStatusControllerFairPlaySubscriptionStatusDidChangeNotification" object:cloudService];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPRestrictionsMonitorAllowsExplicitContentDidChangeNotification" object:[%c(MPRestrictionsMonitor) sharedRestrictionsMonitor]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPUApplicationDefaultsDidChangeNotification" object:[%c(MusicDefaults) sharedDefaults]];
    [cloudService beginObservingFairPlaySubscriptionStatus];
}

-(unsigned long long)entityPlayabilityResultForEntityValueContext:(MusicEntityValueContext *)context {
    id<MusicEntityValueProviding> entityValueProvider = [context entityValueProvider];
    MPUContentItemIdentifierCollection *itemIdentifierCollection = [context itemIdentifierCollection];
    MPCloudServiceStatusController *cloud = [MPCloudServiceStatusController sharedController];
    if(entityValueProvider != nil) {
        if(itemIdentifierCollection != nil) {
            long long networkType = [self _networkType];
            BOOL isCellularNetworkAllowed = [self _isCellularNetworkAllowed];
            NSSet *propertyCollection = [NSSet setWithObjects:@"hasNonPurgeableAsset", @"storeAssetProtectionType", @"isPlayable", @"musicItemStoreRestricted", @"isExplicit", @"musicShouldRespectShowCloudMediaPreference", nil];
            NSDictionary *result = [entityValueProvider valuesForEntityProperties:propertyCollection];
            
            // Check if item is explicit
            if([result[@"isExplicit"] boolValue]) {
                // Check if user is not allowed to see explicit content
                if(![[MPRestrictionsMonitor sharedRestrictionsMonitor] allowsExplicitContent]) return 1;
            }
            
            // Check if item is music store restricted
            if([result[@"musicItemStoreRestricted"] boolValue]) return 3;
            
            
            BOOL isCellularAndCantStream = [MelodyEntityPlayabilityController isCellularNetworkType:networkType] && !isCellularNetworkAllowed;
            BOOL cannotStream = networkType == 0 || isCellularAndCantStream;
            
            // Check if media item has no non-purgeable asset
            if([result[@"hasNonPurgeableAsset"] boolValue]) {
                // Check media item store asset protection type
                if([result[@"storeAssetProtectionType"] integerValue] == 2 && cannotStream) {
                    if([cloud lastKnownFairPlaySubscriptionStatus] != nil && [[cloud lastKnownFairPlaySubscriptionStatus] hasSubscriptionSlot]) {
                        if(![[cloud lastKnownFairPlaySubscriptionStatus] hasSubscriptionLease]) {
                            return 0;
                        }
                    } else {
                        return 0;
                    }
                }
            }
            
            if(![result[@"isPlayable"] boolValue]) return 3;
            
            if (isCellularAndCantStream) return 4;
            
            return networkType == 0 ? 2 : 0;
        }
    }
    return 0;
}

-(void)_musicDefaultsDidChangeNotification:(id)arg1 {
    BOOL isShowCloudMediaEnabled = [[%c(MusicDefaults) sharedDefaults] isShowCloudMediaEnabled];
    dispatch_barrier_async(self->_accessQueue, ^{
        if(isShowCloudMediaEnabled != self->_showCloudMediaEnabled) {
            self->_showCloudMediaEnabled = isShowCloudMediaEnabled;
            dispatch_async(dispatch_get_global_queue(0x0, 0x0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicEntityPlayabilityControllerDidChangeNotification" object:self];
            });
        }
    });
}

-(void)_networkTypeDidChangeNotification:(id)arg1 {
    dispatch_barrier_async(self->_accessQueue, ^{
        if(self->_hasValidNetworkType) {
            long long networkType = self->_networkType;
            self->_hasValidNetworkType = NO;
            long long newNetworkType = [self _networkType];
            if(newNetworkType != networkType) {
                dispatch_async(dispatch_get_global_queue(0x0, 0x0), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicEntityPlayabilityControllerDidChangeNotification" object:self];
                });
            }
        }
    });
}

-(void)_cellularNetworkAllowedDidChangeNotification:(id)arg1 {
    dispatch_barrier_async(self->_accessQueue, ^{
        BOOL cell = self->_cellularNetworkAllowed;
        if((cell & 0xff) != 0xff) {
            [self _setupCellularNetworkingAllowed];
            if(![MelodyEntityPlayabilityController isCellularNetworkType:[self _networkType]]) {
                dispatch_async(dispatch_get_global_queue(0x0, 0x0), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicEntityPlayabilityControllerDidChangeNotification" object:self];
                });
            }
        }
    });
}

-(void)_fairPlaySubscriptionStatusDidChangeNotification:(id)arg1 {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicEntityPlayabilityControllerDidChangeNotification" object:self];
}

-(void)_allowsExplicitContentDidChangeNotification:(id)arg1 {
    dispatch_async(dispatch_get_global_queue(0x0, 0x0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicEntityPlayabilityControllerDidChangeNotification" object:self];
    });
}

-(long long)_networkType {
    if(!self->_hasValidNetworkType) {
        self->_hasValidNetworkType = 0x1;
        self->_networkType = [[%c(ISNetworkObserver) sharedInstance] networkType];
    }
    return self->_networkType;
}

-(void)_setupCellularNetworkingAllowed {
    self->_cellularNetworkAllowed = [[%c(MPNetworkObserver) sharedNetworkObserver] isMusicCellularStreamingAllowed];
}

-(BOOL)_isCellularNetworkAllowed {
    return self->_cellularNetworkAllowed;
}

+(BOOL)isCellularNetworkType:(long long)networkType {
    return (networkType != 0x0 ? 0x1 : 0x0) & (networkType != 0x3e8 ? 0x1 : 0x0);
}

@end
