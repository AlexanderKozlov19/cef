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
const char *text2 = "dpogjhvsf";//"sfdpogjhvsf";
const char *text3 = "uftu";

@synthesize passwordTextField;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    passwordTextField.delegate = self;
   // [self.window setLevel:NSMainMenuWindowLevel+3];//]

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
        [self finishQuitDialog:NSAlertFirstButtonReturn];
    else
      if ( [test isEqualToString:@(text2)] )
              [self finishQuitDialog:NSAlertSecondButtonReturn];
    else
        if ( [test isEqualToString:@(text3)])
            [self finishQuitDialog:NSAlertThirdButtonReturn];
    else
        [self finishQuitDialog:NSModalResponseCancel];
}

-(BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{
    NSString *stringSelector = NSStringFromSelector( commandSelector );
    BOOL res = FALSE;
    
    if ( [stringSelector isEqualToString:@"cancelOperation:"] ) {
        [self finishQuitDialog:NSModalResponseCancel];
        res = TRUE;
    }
    
    if ( [stringSelector isEqualToString:@"insertNewline:"] ) {
        [self checkInput:[passwordTextField stringValue]];
        res = TRUE;
    }
    
    return res;
}

- (IBAction)onYesButton:(id)sender {
    [self checkInput:[passwordTextField stringValue]];
}

- (IBAction)onNoButton:(id)sender {
    [self finishQuitDialog:NSModalResponseCancel];
}

-(void)finishQuitDialog:(NSModalResponse)modalResponce {
     passwordTextField.stringValue = @"";
    [[NSApplication sharedApplication] stopModalWithCode:modalResponce];
    
}
@end
