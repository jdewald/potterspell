//
//  AppDelegate.m
//  Potterspell
//
//  Created by Joshua DeWald on 4/1/18.
//  Copyright © 2018 Joshua DeWald. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

-(id)init {
    id f = [super init];
    
    self.spells = [[SpellStorage alloc] init];
    return f;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    


}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
