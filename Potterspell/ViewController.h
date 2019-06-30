//
//  ViewController.h
//  Potterspell
//
//  Created by Joshua DeWald on 4/1/18.
//  Copyright © 2018 Joshua DeWald. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SpellView.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet SpellView* spellView;
@property (weak) IBOutlet NSTextField* spellNameField;
@property (weak) IBOutlet NSTextField* recognizedSpellNameLabel;

-(IBAction)addButtonPressed:(id)sender;
-(IBAction)clearButtonPressed:(id)sender;
-(IBAction)recognizeTogglePressed:(id)sender;
-(IBAction)toggleLiveMode:(id)sender;
@end

