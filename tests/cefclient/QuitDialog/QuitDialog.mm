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

const char *text1 = "FYJU$sfqmbz";
const char *text2 = "dpogjhvsf";

@synthesize passwordTextField;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    passwordTextField.delegate = self;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)checkInput:(NSString*)text {
    NSMutableString *newString = [[NSMutableString alloc] init];
    for ( NSUInteger index = 0; index < [text length]; index++ ) {
        unichar temp = [text characterAtIndex:index];
        temp++;
        [newString appendString:[NSString stringWithFormat:@"%c",temp]];
    }
    
    NSString *test = [NSString stringWithString:newString];
    
    if ( [test isEqualToString:@(text1)] )
        [[NSApplication sharedApplication] stopModalWithCode:NSAlertFirstButtonReturn];
    else
      if ( [test isEqualToString:@(text2)] )
              [[NSApplication sharedApplication] stopModalWithCode:NSAlertSecondButtonReturn];
    else
        [[NSApplication sharedApplication] stopModalWithCode:NSModalResponseCancel];
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
        //[[NSApplication sharedApplication] stopModalWithCode:NSAlertFirstButtonReturn];
        [self checkInput:[passwordTextField stringValue]];
        res = TRUE;
    }
    
    NSLog(@"Selector method is (%@)", stringSelector );
    
    return res;
}

- (IBAction)onYesButton:(id)sender {
    [self checkInput:[passwordTextField stringValue]];
}

- (IBAction)onNoButton:(id)sender {
    [[NSApplication sharedApplication] stopModalWithCode:NSModalResponseCancel];
}
@end
