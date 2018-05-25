//
//  AppBridge.m
//  Janison Replay
//
//  Created by Alexander Kozlov on 10.05.2018.
//
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "AppBridge.h"
#import "tests/cefclient/QuitDialog/QuitDialog.h"
#include "NSWindow+SEBWindow.h"
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
        int timeLeft;
        
    };
    
    BatteryInfo batteryInfo;
    BatteryInfo *currentBatteryState;
    CFRunLoopSourceRef runLoopSource;
    
    NSMutableArray *keyboardLayouts;
    NSMutableArray *keyboardLayoutsForSend;
    
    NSDictionary *sISO639_2Dictionary;
    
    NSString *pathToLog;
    
    NSDateFormatter* formatter;
    
    NSString *machineName;
    
    NSString *startURL;
}

+(id)sharedAppBridge {
    
    static AppBridge *sharedAppBridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppBridge = [[self alloc] init];
        
        
    });
    return sharedAppBridge;
    
    
}

-(void)loadStartURL {
    startURL = nil;
    
    NSString *configFileName = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Contents/Resources/config.json"];
    
    BOOL jsonExists = [[NSFileManager defaultManager] fileExistsAtPath:configFileName];
    if ( jsonExists ) {
        
        NSString *stringJSON = [[NSString alloc] initWithContentsOfFile:configFileName encoding:NSUTF8StringEncoding error:NULL];
        NSError *error =  nil;
        NSDictionary *jsonConfig = [NSJSONSerialization JSONObjectWithData:[stringJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        if ( [jsonConfig objectForKey:@"startUrl"] != nil ) {
            startURL = jsonConfig[@"startUrl"];
        }
    }
        
}

-(id)init {
    
    machineName = [[NSHost currentHost] localizedName];
    
  //  [NSWindow setupChangingWindowLevels];

    formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
        
    pathToLog = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Contents/Temp/log.txt"];
    
    [self loadStartURL];

    NSString *plistPath = [[NSBundle mainBundle]  pathForResource:@"iso639_2" ofType:@"plist"];
    
    sISO639_2Dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    quitDialog = [[QuitDialog alloc] initWithWindowNibName:@"QuitDialog"];
    appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [self logEventForNsString:@"Starting application..."];
    [self logEventForNsString:[NSString stringWithFormat:@"AppVersion: %@", appVersion]];
    
    [self retrieveBatteryStatus];
    if ( currentBatteryState )  // if battery is present
         [self startBatteryService];
    
    keyboardLayouts = [[NSMutableArray alloc] init];
    keyboardLayoutsForSend = [[NSMutableArray alloc] init];
    [self retrieveKeyboardLayouts];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:NSTextInputContextKeyboardSelectionDidChangeNotification object:nil];
  

    return self;
}


- (void) keyboardChanged: (NSNotification *) notification {
    
    NSString *apiName = @"keyboardLayout";
    NSString *eventName = @"layoutChanged";
    
    const char *curLayout = [self retrieveCurrentLayout:YES];
    
    client::MainContext::Get()->GetRootWindowManager()->SendCallbackMessage([apiName UTF8String], [eventName UTF8String], curLayout);
    

}

-(void)retrieveBatteryStatus {
    
    currentBatteryState = NULL;
    
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    
    int numOfSources = CFArrayGetCount(sources);
    if (numOfSources == 0) {
        [self logEventForNsString:@"BatteryInfo: Battery not found"];
        return ;
    }
    
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
        
        [self logEventForNsString:[ NSString stringWithFormat:@"BatteryInfo: charging: %d percantage = %f timeLeft = %ud", batteryInfo.isCharging, batteryInfo.percentage, batteryInfo.timeLeft ]];
        
     //   NSLog(@"charging: %d percantage = %f timeLeft = %ud", batteryInfo.isCharging, batteryInfo.percentage, batteryInfo.timeLeft);
        
        
    }
    
    currentBatteryState = &batteryInfo;
   
    
}

void powerSourceChange(void* context) {
    BatteryInfo *batteryInfo = (BatteryInfo*)[(AppBridge*)context retrieveBatteryInfo];
    
    [[ AppBridge sharedAppBridge] logEventForNsString:@"BatteryInfo: Battery status has changed."];
    
    NSString *apiName = @"battery";
    NSString *eventName = @"statusChanged";
    
    NSDictionary *dict = NULL;
    
    if ( batteryInfo ) {
        dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSNumber numberWithBool:batteryInfo->isCharging ] forKey:@"isCharging"];
        [dict setValue:[NSNumber numberWithDouble:batteryInfo->percentage ] forKey:@"level"];
        [dict setValue:[NSNumber numberWithInt:batteryInfo->timeLeft ] forKey:@"timeLeft"];
        
        
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:kNilOptions
                                                         error:&error];
    NSString *stringJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    client::MainContext::Get()->GetRootWindowManager()->SendCallbackMessage([apiName UTF8String], [eventName UTF8String], [stringJSON UTF8String]);
    
  //  NSLog(@"battery sent");
    
    
}

-(void)startBatteryService {
    runLoopSource = (CFRunLoopSourceRef)IOPSNotificationCreateRunLoopSource(powerSourceChange, self);
    if(runLoopSource) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
        [self logEventForNsString:@"BatteryInfo: Battery service had started."];
    }
    
}

-(void*)retrieveBatteryInfo {
    if ( currentBatteryState ) //&& ( currentBatteryState->timeLeft < 0) )
        [self retrieveBatteryStatus];
    return currentBatteryState;
}

-(void)retrieveKeyboardLayouts {
    
    
    [keyboardLayouts removeAllObjects];
    [keyboardLayoutsForSend removeAllObjects];
    
    NSLocale *enLocale = [NSLocale localeWithLocaleIdentifier:@"en"];
    
    NSArray *inputSources = [(NSArray *)TISCreateInputSourceList(NULL,false ) copy];
    
    for ( NSObject *inputSource in inputSources) {
        
        NSMutableDictionary *keyboardLayout = [[NSMutableDictionary alloc] init];
        
        NSString *sourceType = (NSString*)TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceType);
        
        if ( ![sourceType isEqualToString:@"TISTypeKeyboardLayout"] )
            continue;
        
        NSString *inputSourceID = (NSString*) TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceID);
        
        NSArray *Languages = [(NSArray *)TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceLanguages) copy];
        NSString *primaryLanguage = NULL;
        if ([Languages count] > 0) {
            primaryLanguage = [Languages objectAtIndex:0];
        }
        
        NSLocale* tempLocale = [NSLocale localeWithLocaleIdentifier:primaryLanguage];
        
        [keyboardLayout setValue:inputSourceID forKey:@"layoutCode"];
        
        [keyboardLayout setValue:tempLocale.localeIdentifier forKey:@"id"];
        [keyboardLayout setValue:tempLocale.languageCode forKey:@"code2"];
        [keyboardLayout setValue:[tempLocale localizedStringForLanguageCode:tempLocale.languageCode] forKey:@"languageNativeName"];
        NSLog(@"countryCode %@", tempLocale.countryCode );
        [keyboardLayout setValue:[tempLocale localizedStringForCountryCode:tempLocale.countryCode] forKey:@"cultureNativeName"];
        [keyboardLayout setValue:[enLocale localizedStringForLanguageCode:tempLocale.languageCode] forKey:@"languageName"];
        [keyboardLayout setValue:[enLocale localizedStringForCountryCode:tempLocale.countryCode] forKey:@"cultureName"];
        
        [keyboardLayout setValue:[sISO639_2Dictionary objectForKey:tempLocale.languageCode] forKey:@"code3"];
        
        [keyboardLayouts addObject:keyboardLayout];
        
        NSMutableDictionary *dictForSend = [[NSMutableDictionary alloc] initWithDictionary:keyboardLayout];
        [dictForSend removeObjectForKey:@"layoutCode"];
        [keyboardLayoutsForSend addObject:dictForSend];
        
        [self logEventForNsString:[NSString stringWithFormat:@"Keyboard Info: layout was found: %@", primaryLanguage]];

        
    }
   

}

-(const char*)retrieveJSONLayouts {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:keyboardLayoutsForSend
                                                       options:kNilOptions
                                                         error:&error];
    NSString *stringJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [stringJSON UTF8String];
}

-(bool)selectKeyboardLayout:(const char*)codeLayoutJSON{
    
    bool result = false;
    
    NSString *codeStr = [NSString stringWithUTF8String:codeLayoutJSON ];
    NSData* jsonData = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    NSString *testString = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
    
    NSArray *inputSources = [(NSArray *)TISCreateInputSourceList(NULL,false ) copy];
    
    for ( NSMutableDictionary *layout in keyboardLayouts ) {
        if ( [layout[@"id"] isEqualToString:testString] ) {
            for ( NSObject *inputSource in inputSources) {
                NSString *sourceType = (NSString*)TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceType);
                
                if ( ![sourceType isEqualToString:@"TISTypeKeyboardLayout"] )
                    continue;
                
                NSString *inputSourceID = (NSString*) TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceID);
                
                if ( [ inputSourceID isEqualTo: layout[@"layoutCode"]] ) {
                    TISSelectInputSource( (TISInputSourceRef)inputSource );
                    result = true;
                    break;
                }
                
                
            }
            break;
        }
    }
    
   
    return result;
}

-(const char*)retrieveCurrentLayout:(BOOL)inDictionary {
    const char *result = nil;
    
    NSArray *inputSources = [(NSArray *)TISCreateInputSourceList(NULL,false ) copy];
    NSString *selectedLayout = nil;
    
    for ( NSObject *inputSource in inputSources) {
        NSString *sourceType = (NSString*)TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceType);
        
        if ( ![sourceType isEqualToString:@"TISTypeKeyboardLayout"] )
            continue;
        
         CFBooleanRef isSelected = (CFBooleanRef) TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceIsSelected);
        
        
        
        if ( isSelected == kCFBooleanTrue)  {
            selectedLayout = (NSString*) TISGetInputSourceProperty((TISInputSourceRef)inputSource, kTISPropertyInputSourceID);
            break;
        }
        
    }
    
    if ( selectedLayout != nil ) {
        for ( NSMutableDictionary *dictionary in keyboardLayouts ) {
            if ( [dictionary[@"layoutCode"] isEqualToString:selectedLayout] ) {
                NSString *currentID = dictionary[@"id"];
                NSError *error;
                NSData *jsonData = nil;
                
                if ( inDictionary ) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:currentID, @"layoutId", nil];
                    
                    jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
                    
                }
                else {
                    
                    jsonData = [NSJSONSerialization dataWithJSONObject:currentID
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error];
                   
                }
                
                NSString *stringJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                result = [stringJSON UTF8String];
            }
        }
        
        
    }
    
    [self logEventForNsString:[NSString stringWithFormat:@"Keyboard Info: currentLayout %@", @(result)]];
    
    return result;
    
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

-(void)logEvent:(const char*)message {
    [self logEventForNsString:@(message)];


}

-(void)logEventForNsString:(NSString*)message {

    NSString *messageWithTime = [NSString stringWithFormat:@"%@: %@\n", [formatter stringFromDate:[NSDate date]], message ];

    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:pathToLog];
    if ( !fh ) {
        [[NSFileManager defaultManager] createFileAtPath:pathToLog contents:nil attributes:nil];
        fh = [NSFileHandle fileHandleForWritingAtPath:pathToLog];
    }
    if ( !fh ) return;
    @try {
        [fh seekToEndOfFile];
        [fh writeData:[messageWithTime dataUsingEncoding:NSUTF8StringEncoding]];
    }
    @catch (NSException * e) {
        
    }
    
    [fh closeFile];
}

-(NSString*)retrieveMachineName {
    return machineName;
}

- (BOOL)forceQuitWindowCheck
{
    BOOL process = [self forceQuitWindowOpen];
    BOOL userQuit = NO;
    while ( process ) {
        // Show alert that the Force Quit window is open
        NSLog(@"Force Quit window is open, show error message and ask user to close it or quit SEB.");
        NSAlert *newAlert = [[NSAlert alloc] init];
        [newAlert setMessageText:NSLocalizedString(@"Close Force Quit Window", nil)];
        [newAlert setInformativeText:NSLocalizedString(@"Janison Replay cannot run when the Force Quit window is open. Close the window or quit Janison Replay.", nil)];
        [newAlert setAlertStyle:NSCriticalAlertStyle];
        [newAlert addButtonWithTitle:NSLocalizedString(@"Retry", nil)];
        [newAlert addButtonWithTitle:NSLocalizedString(@"Quit", nil)];
        int answer = [newAlert runModal];
        switch(answer)
        {
            case NSAlertFirstButtonReturn:
                NSLog(@"Force Quit window was open, user clicked retry");
                process = [self forceQuitWindowOpen];
                break; // Test if window is closed now
                
            case NSAlertSecondButtonReturn:
            {
                // Quit SEB
                NSLog(@"Force Quit window was open, user decided to quit Janison Replay.");
                process = NO;
                userQuit = YES;
                break;
                //quittingMyself = TRUE; //SEB is terminating itself
              
            }
        }
        
      
    }
    
    if ( userQuit )
        [[NSApplication sharedApplication] terminate: nil];
    
    return userQuit;
        
}


// Check if the Force Quit window is open
- (BOOL)forceQuitWindowOpen {
    BOOL forceQuitWindowOpen = false;
    NSArray *windowList = CFBridgingRelease(CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID));
    for (NSDictionary *windowInformation in windowList) {
        if ([[windowInformation valueForKey:@"kCGWindowOwnerName"] isEqualToString:@"loginwindow"]) {
            forceQuitWindowOpen = true;
            break;
        }
    }
    return forceQuitWindowOpen;
}

- (const char*)retrieveStartURL {
    return [startURL UTF8String];
}


@end
