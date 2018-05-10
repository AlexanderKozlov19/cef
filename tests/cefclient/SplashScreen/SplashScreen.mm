//
//  SplashScreen.m
//  cefclient
//
//  Created by Alexander Kozlov on 03.05.2018.
//

#import "SplashScreen.h"
#import "tests/cefclient/AppBridgeSingleton/AppBridge.h"

@interface SplashScreen ()

@end

@implementation SplashScreen

@synthesize imageView;
@synthesize versionField;

- (void)windowDidLoad {
    [super windowDidLoad];
    
  //  [self.imageView setWantsLayer:YES];
   // [self.imageView setAlphaValue:0];
    NSImage *imageBack = [NSImage imageNamed:@"JanisonReplay.jpg"];
    imageBack.backgroundColor = [NSColor clearColor];
    [self.imageView setImage:imageBack];
    NSString *version = [NSString stringWithFormat:@"v. %@", [[AppBridge sharedAppBridge] retrieveAppVersion]];
    [self.versionField setStringValue: version];
   
    
   
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
