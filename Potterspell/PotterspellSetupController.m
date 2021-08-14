//
//  PotterspellSetupController.m
//  Potterspell
//
//  Created by Joshua DeWald on 7/2/19.
//  Copyright © 2019 Joshua DeWald. All rights reserved.
//

#import "PotterspellSetupController.h"
#import "AppDelegate.h"

@implementation PotterspellSetupController
SpellStorage* spells;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    spells = ((AppDelegate *)[[NSApplication sharedApplication] delegate]).spells;
    [self spellsView].delegate = self;
    [self spellsView].dataSource = self;
}

-(void) saveTemplates:(id)sender {
    
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    
    [savePanel beginWithCompletionHandler:^(NSModalResponse result) {
        NSURL*  saveFilename = [savePanel URL];
        
        
        [spells saveSpellsWithTargetUrl:saveFilename];
    }];
    
}

-(void) loadTemplates:(id)sender {
    
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        NSURL*  saveFilename = [openPanel URL];
        
        [spells loadSpellsWithTargetUrl:saveFilename];
        [self.spellsView reloadData];
    }];
    
}

- (void)viewWillAppear {
    if (((AppDelegate *)[[NSApplication sharedApplication] delegate]).wiiMote != nil) {
        [((AppDelegate *)[[NSApplication sharedApplication] delegate]).wiiMote setDelegate:self];
        self.wiiMoteInfoLabel.stringValue = ((AppDelegate *)[[NSApplication sharedApplication] delegate]).wiiMote.addressString;
    }
    
}

//-- NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (spells.spellDefs != nil) {
        NSLog(@"Number of keys: %i", [spells.spellDefs.allKeys count]);
        return [spells.spellDefs.allKeys count];
    } else {
        return 0;
    }
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableColumn == tableView.tableColumns[0]) {
        NSTableCellView* cell = [tableView makeViewWithIdentifier:@"SpellNameID" owner:self];
        NSTextField* spellField = [cell subviews][0];
        spellField.stringValue = spells.spellDefs.allKeys[row];
        return cell;
    }
    return nil;
}
@end
