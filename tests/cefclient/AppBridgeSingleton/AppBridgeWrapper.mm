//
//  AppBridgeWrapper.c
//  Janison Replay
//
//  Created by Alexander Kozlov on 10.05.2018.
//

#include "AppBridgeWrapper.h"
#import "AppBridge.h"

namespace AppBridgeWrapper {
    
    void terminateApp() {
        [[AppBridge sharedAppBridge] showQuitDialog];
       
    }
    
    const char * retrieveAppVersionForBridge() {
        const char *str = [[[AppBridge sharedAppBridge] retrieveAppVersion] UTF8String];
        return str ;
    }
    
    void *retrieveBatteryInfo() {
        void *result = [[AppBridge sharedAppBridge] retrieveBatteryInfo];
        
        return result;
    }
}
