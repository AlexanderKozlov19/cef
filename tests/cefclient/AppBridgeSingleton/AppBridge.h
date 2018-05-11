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



@end
