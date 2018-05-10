//
//  SplashScreen.h
//  cefclient
//
//  Created by Alexander Kozlov on 03.05.2018.
//

#import <Cocoa/Cocoa.h>

@interface SplashScreen : NSWindowController
@property (assign) IBOutlet NSImageView *imageView;
@property (unsafe_unretained) IBOutlet NSTextField *versionField;

@end
