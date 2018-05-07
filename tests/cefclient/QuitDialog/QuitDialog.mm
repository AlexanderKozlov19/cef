//
//  QuitDialog.m
//  Janison Replay
//
//  Created by Alexander Kozlov on 08.05.2018.
//

#import "QuitDialog.h"

@interface QuitDialog ()

@end

@implementation QuitDialog

@synthesize passwordTextField;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    passwordTextField.delegate = self;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{
    NSString *stringSelector = NSStringFromSelector( commandSelector );
    BOOL res = FALSE;
    
    if ( [stringSelector isEqualToString:@"cancelOperation:"] ) {
        [[NSApplication sharedApplication] stopModalWithCode:NSModalResponseCancel];
        res = TRUE;
    }
    
    if ( [stringSelector isEqualToString:@"insertNewline:"] ) {
        [[NSApplication sharedApplication] stopModalWithCode:NSAlertFirstButtonReturn];
        res = TRUE;
    }
    
    NSLog(@"Selector method is (%@)", stringSelector );
    
    return res;
}

- (IBAction)onYesButton:(id)sender {
    [[NSApplication sharedApplication] stopModalWithCode:NSAlertFirstButtonReturn];
}

- (IBAction)onNoButton:(id)sender {
    [[NSApplication sharedApplication] stopModalWithCode:NSModalResponseCancel];
}
@end
