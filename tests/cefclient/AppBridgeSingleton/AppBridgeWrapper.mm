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
    
    const char *retrieveLayouts() {
        const char *result = [[AppBridge sharedAppBridge] retrieveJSONLayouts];
        return result;
    }
    
    bool setKeyboardLayout( const char *codeN ) {
        bool result = [[AppBridge sharedAppBridge] selectKeyboardLayout:codeN];
        return result;
    }
    
    const char* retrieveCurrentLayout() {
        const char *result = [[AppBridge sharedAppBridge] retrieveCurrentLayout:NO];
        return result;
    }
    
    void logEvent( const char *message ) {
        [[AppBridge sharedAppBridge] logEvent:message];
    }
    
    const char *retriveMachineName() {
        const char *str = [[AppBridge sharedAppBridge] retrieveMachineName];
        return str ;
    }
    
    bool checkForForceQuitWindow() {
        BOOL result = [[AppBridge sharedAppBridge] forceQuitWindowCheck];
        return result;
    }
    
    const char *retrieveStartURL() {
        const char *result = [[AppBridge sharedAppBridge] retrieveStartURL];
        return result;
    }
}
