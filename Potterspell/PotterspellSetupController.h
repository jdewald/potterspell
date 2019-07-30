//
//  PotterspellSetupController.h
//  Potterspell
//
//  Created by Joshua DeWald on 7/2/19.
//  Copyright © 2019 Joshua DeWald. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Potterspell-Swift.h"


@interface PotterspellSetupController : NSViewController <NSTableViewDataSource,NSTableViewDelegate>
-(IBAction)saveTemplates:(id)sender;
-(IBAction)loadTemplates:(id)sender;
@property (weak) IBOutlet NSTextField* wiiMoteInfoLabel;
@property (weak) IBOutlet NSTableView* spellsView;
@end

