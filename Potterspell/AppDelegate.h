//
//  AppDelegate.h
//  Potterspell
//
//  Created by Joshua DeWald on 4/1/18.
//  Copyright © 2018 Joshua DeWald. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Potterspell-Swift.h"
#import <Wiimote/Wiimote.h>
#import <OCLog/OCLog.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property SpellStorage* spells;
@property Wiimote *wiiMote;

@end

