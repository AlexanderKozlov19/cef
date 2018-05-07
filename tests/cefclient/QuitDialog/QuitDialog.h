//
//  QuitDialog.h
//  Janison Replay
//
//  Created by Alexander Kozlov on 08.05.2018.
//

#import <Cocoa/Cocoa.h>

@interface QuitDialog : NSWindowController<NSTextFieldDelegate>
- (IBAction)onYesButton:(id)sender;
- (IBAction)onNoButton:(id)sender;
@property (assign) IBOutlet NSSecureTextField *passwordTextField;


@end
