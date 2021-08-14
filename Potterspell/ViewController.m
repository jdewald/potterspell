//
//  ViewController.m
//  Potterspell
//
//  Created by Joshua DeWald on 4/1/18.
//  Copyright © 2018 Joshua DeWald. All rights reserved.
//

#import "ViewController.h"
#import <Wiimote/Wiimote.h>
#import <OCLog/OCLog.h>
#import "SpellView.h"
#import "Potterspell-Swift.h"
#import "AppDelegate.h"


@implementation ViewController {
    PennyPincher* pennyPincher;
    BOOL recognizing;
    BOOL liveMode;
    BOOL talkToDevices;
    NSTimer *recognizeTimer;
    SpellStorage* spells;
    NSString* desiredSpell;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self backgroundView].wantsLayer = true;
    [self backgroundView].layer.contents = [NSImage imageNamed:@"Starry"];
    [self recognizedSpellNameLabel].stringValue = @"";
    
    
    // Do any additional setup after loading the view.
    pennyPincher = [[PennyPincher alloc] init];
    recognizing = false;
    talkToDevices = true;
    
    spells = ((AppDelegate *)[[NSApplication sharedApplication] delegate]).spells;
}

- (void)viewWillAppear {
    [((AppDelegate *)[[NSApplication sharedApplication] delegate]).wiiMote setDelegate:self];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (void)wiimote:(Wiimote *)wiimote irPointPositionChanged:(WiimoteIRPoint *)point
{
    NSPoint nsPoint = [point position];
    
    NSLog(@"Processed point change: %i, %f, %f", [point index], [point position].x, [point position].y);
    
    if ([point position].x < 1023 || [point position].y < 1023) {
        if (point.index == 0) {
            [self.spellView addPoint:nsPoint];
        } else {
            [self.spellView addPoint2:nsPoint];

        }
        
        [[self spellView] setNeedsDisplay:YES];
        [[self view] setNeedsDisplay:YES];
    }
    
    if (liveMode) {
        if (recognizeTimer != nil) {
            [recognizeTimer invalidate];
            recognizeTimer = nil;
        
        }
        recognizeTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)0.5 repeats:false block:^(NSTimer * _Nonnull timer) {
            NSLog(@"Live mode recognize timer fired");
            [self recognize];
            [self clearButtonPressed:nil];
        }];
    }


}

- (void)wiimoteDisconnected:(Wiimote*)wiimote
{
    // debug message
    NSLog(@"Wiimote disconnected: %@ (%@)", [wiimote modelName], [wiimote addressString]);
}

//----
- (void)addButtonPressed:(id)sender
{

    if (! [spells addSpellWithName:self.spellNameField.stringValue pixels:[self spellView].pixels]) {
        NSLog(@"Unable to add spell!");
    }
    [self clearButtonPressed:sender];
  }

- (void) clearButtonPressed:(id)sender {
    [self.spellView clearPoints];
    [[self spellView] setNeedsDisplay:YES];
    [[self view] setNeedsDisplay:YES];
}

//-- Test mode stuff
-(void) pickNewSpell {
    NSUInteger spellIndex = arc4random_uniform([[spells.spellDefs allKeys] count]);
    desiredSpell = [spells.spellDefs allKeys][spellIndex];
    self.recognizedSpellNameLabel.stringValue = [NSString stringWithFormat:@"CAST: %@", desiredSpell];
}

//--End test mode stuff

- (void) startRecognizing {
    recognizing = true;
}

- (void) recognize {
    PennyPincherResult* result =[PennyPincher recognize:[[self spellView].pixels copy] templates:spells.spellTemplates];
    if (result != nil) {
        NSLog(@"Recognize value: %@", result);
        
        if (self.currentSpellMode == kTesting) {
            if (result.template.id == desiredSpell) {
                self.recognizedSpellNameLabel.stringValue = @"You got it!";
                [self performSelector:@selector(pickNewSpell) withObject:nil afterDelay:2.0f];
            }
        } else {
            self.recognizedSpellNameLabel.stringValue = result.template.id;
        }
        
        if (talkToDevices) {
            // Create the request.
            NSString *baseURL = @"http://127.0.0.1:3000/";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:result.template.id]]];
            
            
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
}
- (void) recognizeTogglePressed:(id)sender {
    recognizing = ! recognizing;
    
    if (recognizing) {
        [sender setTitle:@"Recognize"];
        
    }

    if (! recognizing) {
        [sender setTitle:@"Start"];
        [self recognize];

    
        
 
    }
    
}

// Toggle whether or not we are in "live" mode, which corresponds
// to whether we want to automatically try to recognize spells
-(void) toggleLiveMode:(id)sender {
    if ([sender state] == NSOnState) {
        liveMode = true;
        NSLog(@"Entered live mode");
    } else {
        liveMode = false;
        NSLog(@"Exited live mode");
    }
}

-(void) toggleTestMode:(id)sender {
    if ([sender state] == NSOnState) {
        self.currentSpellMode = kTesting;
        NSLog(@"Entered test mode");
        [self pickNewSpell];
    } else {
        self.currentSpellMode = kFree;
        NSLog(@"Exited live mode");
    }
}


@end
