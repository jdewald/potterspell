//
//  ViewController.h
//  Potterspell
//
//  Created by Joshua DeWald on 4/1/18.
//  Copyright © 2018 Joshua DeWald. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SpellView.h"

@class SpellStorage;

typedef enum {
    kFree,
    kTesting
} SpellMode;

@interface ViewController : NSViewController

@property (weak) IBOutlet NSView* backgroundView;
@property (weak) IBOutlet SpellView* spellView;
@property (weak) IBOutlet NSTextField* spellNameField;
@property (weak) IBOutlet NSTextField* recognizedSpellNameLabel;

@property SpellMode currentSpellMode;

-(IBAction)addButtonPressed:(id)sender;
-(IBAction)clearButtonPressed:(id)sender;
-(IBAction)recognizeTogglePressed:(id)sender;
-(IBAction)toggleLiveMode:(id)sender;
-(IBAction)toggleTestMode:(id)sender;

@end

