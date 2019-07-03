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
    }];
    
}
@end
