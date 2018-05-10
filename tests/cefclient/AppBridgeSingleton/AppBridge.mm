//
//  AppBridge.m
//  Janison Replay
//
//  Created by Alexander Kozlov on 10.05.2018.
//
#import <Cocoa/Cocoa.h>
#import "AppBridge.h"
#import "tests/cefclient/QuitDialog/QuitDialog.h"
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
    return self;
}

-(NSString*) retrieveAppVersion {
    return appVersion;
}




-(void)openDialog {
    BOOL needShow = YES;

    if ( quitDialog.window.visible  )
        needShow = NO;
    
    if ( needShow ) {
        NSModalResponse modalResult = [[NSApplication sharedApplication] runModalForWindow:quitDialog.window];
        
        [quitDialog.window orderOut:nil];
        
        if ( modalResult == NSAlertFirstButtonReturn ) {
            client::MainContext::Get()->GetRootWindowManager()->QuitKioskMode();
            [[NSApplication sharedApplication] terminate:nil];
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

@end
