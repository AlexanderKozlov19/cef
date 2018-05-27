//
//  AppBridge.h
//  Janison Replay
//
//  Created by Alexander Kozlov on 10.05.2018.
//

#import <Foundation/Foundation.h>

@interface AppBridge : NSObject

+(id)sharedAppBridge;

-(void)openDialog;
-(void)showQuitDialog;

-(NSString*)retrieveAppVersion;
-(void*)retrieveBatteryInfo;
-(const char*)retrieveJSONLayouts;
-(bool)selectKeyboardLayout:(const char*)codeLayoutJSON;
-(const char*)retrieveCurrentLayout:(BOOL)inDictionary;

-(void)logEvent:(const char*)message;
-(void)logEventForNsString:(NSString*)message;

-(const char*)retrieveMachineName;

- (BOOL)forceQuitWindowCheck;

-(const char*)retrieveStartURL;


@end
