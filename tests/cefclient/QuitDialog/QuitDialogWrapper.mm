//
//  QuitDialogWrapper.cpp
//  Janison Replay
//
//  Created by Alexander Kozlov on 10.05.2018.
//

#import <Cocoa/Cocoa.h>
#import "QuitDialog.h"
#include "QuitDialogWrapper.h"


void QuitDialogWrapper::create(void) {
    [[NSApplication sharedApplication] terminate:nil];
}
