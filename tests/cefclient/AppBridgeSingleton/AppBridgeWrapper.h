//
//  AppBridgeWrapper.h
//  Janison Replay
//
//  Created by Alexander Kozlov on 10.05.2018.
//

#ifndef AppBridgeWrapper_h
#define AppBridgeWrapper_h

namespace AppBridgeWrapper {
    void terminateApp();
    const char* retrieveAppVersionForBridge();
    void *retrieveBatteryInfo();
    const char *retrieveLayouts();
    bool setKeyboardLayout( const char *code );
    const char *retrieveCurrentLayout();
    void logEvent( const char *message );
    const char *retriveMachineName();
    bool checkForForceQuitWindow();
    const char *retrieveStartURL();
}

#endif /* AppBridgeWrapper_h */
