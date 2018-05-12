//
//  AppBridge.m
//  Janison Replay
//
//  Created by Alexander Kozlov on 10.05.2018.
//
#import <Cocoa/Cocoa.h>
#import "AppBridge.h"
#import "tests/cefclient/QuitDialog/QuitDialog.h"
#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/ps/IOPSKeys.h>

#include "include/cef_app.h"
#import  "include/cef_application_mac.h"
#include "tests/cefclient/browser/main_context_impl.h"
#include "tests/cefclient/browser/resource.h"
#include "tests/cefclient/browser/root_window.h"
#include "tests/cefclient/browser/test_runner.h"
#include "tests/shared/browser/client_app_browser.h"
#include "tests/shared/browser/main_message_loop_external_pump.h"
#include "tests/shared/browser/main_message_loop_std.h"
#include "tests/shared/common/client_switches.h"

@implementation AppBridge {
    QuitDialog *quitDialog;
    NSString *appVersion;
    
    struct BatteryInfo {
        bool isCharging;
        double percentage;
        unsigned int timeLeft;
        
    };
    
    BatteryInfo batteryInfo;
    BatteryInfo *currentBatteryState;
    CFRunLoopSourceRef runLoopSource;
}

+(id)sharedAppBridge {
    
    static AppBridge *sharedAppBridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppBridge = [[self alloc] init];
        
        
    });
    return sharedAppBridge;
    
    
}

-(id)init {
    quitDialog = [[QuitDialog alloc] initWithWindowNibName:@"QuitDialog"];
    appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [self retrieveBatteryStatus];
  
    return self;
}

-(void)retrieveBatteryStatus {
    
    currentBatteryState = NULL;
    
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    
    int numOfSources = CFArrayGetCount(sources);
    if (numOfSources == 0) return ;
    
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    
    for (int i = 0 ; i < numOfSources ; i++)
    {
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource) return;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSIsChargingKey));
        batteryInfo.isCharging = CFBooleanGetValue( (CFBooleanRef)psValue );
        
        int curCapacity = 0;
        int maxCapacity = 0;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        
        batteryInfo.percentage = ((double)curCapacity/(double)maxCapacity);
        
        int timeLeft;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSTimeToEmptyKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberIntType, &timeLeft);
        batteryInfo.timeLeft = timeLeft * 60;
        
        
    }
    
    currentBatteryState = &batteryInfo;
    [self startBatteryService];
    
    
}

void powerSourceChange(void* context) {
  /*  NSArray* args = [NSArray arrayWithObjects: @"Power Source has changed!", nil];
    id win = [[(PowerSourceInfoWorker*)context webView] windowScriptObject];
    [win callWebScriptMethod:@"jsCallback" withArguments:args];
   */
    [(AppBridge*)context retrieveBatteryStatus];
}

-(void)startBatteryService {
    runLoopSource = (CFRunLoopSourceRef)IOPSNotificationCreateRunLoopSource(powerSourceChange, self);
    if(runLoopSource) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
    }
    
}

-(void*)retrieveBatteryInfo {
    return currentBatteryState;
}

-(NSString*) retrieveAppVersion {
    return appVersion;
}


-(void)quitKioskAndCloseApp {
    client::MainContext::Get()->GetRootWindowManager()->QuitKioskMode();
    [[NSApplication sharedApplication] terminate:nil];
}

-(void)openDialog {
    BOOL needShow = YES;

    if ( quitDialog.window.visible  )
        needShow = NO;
    
    if ( needShow ) {
        NSModalResponse modalResult = [[NSApplication sharedApplication] runModalForWindow:quitDialog.window];
        
        [quitDialog.window orderOut:nil];
        
        if ( modalResult == NSAlertFirstButtonReturn ) {
            [self quitKioskAndCloseApp];
        }
        else
            if ( modalResult == NSAlertSecondButtonReturn ) {
                client::MainContext::Get()->GetRootWindowManager()->ReconfigurePage();
            }
        else
            if ( modalResult == NSAlertThirdButtonReturn ) {
                client::MainContext::Get()->GetRootWindowManager()->NavigateToTestPage();
            }
    }
}

-(void)showQuitDialog {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Quit"];
    [alert setInformativeText:@"Are you sure you want to quit?"];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        [self quitKioskAndCloseApp];
    }
    [alert release];
}

@end
