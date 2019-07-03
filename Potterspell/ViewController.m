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
#import <PennyPincher/PennyPincher-Swift.h>
#import "Potterspell-Swift.h"
#import "AppDelegate.h"

@implementation ViewController {
    PennyPincher* pennyPincher;
    BOOL recognizing;
    BOOL liveMode;
    NSTimer *recognizeTimer;
    SpellStorage* spells;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self attachToWiimote];
    
    // Do any additional setup after loading the view.
    pennyPincher = [[PennyPincher alloc] init];
    recognizing = false;
    
    spells = ((AppDelegate *)[[NSApplication sharedApplication] delegate]).spells;

}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}



- (id)attachToWiimote
{
    //self = [super init];
    
    if(self == nil)
        return nil;
    
    // for debug output
    [[OCLog sharedLog] setLevel:OCLogLevelDebug];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(wiimoteConnectedNotification:)
     name:WiimoteConnectedNotification
     object:nil];
    
    [Wiimote setUseOneButtonClickConnection:YES]; // ;)
    [Wiimote beginDiscovery]; // begin wait for new wiimotes (what not paired). 30 sec.
    // If wiimote already paired, it can be connected without discovering.

    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)wiimoteConnectedNotification:(NSNotification*)notification
{
    Wiimote *wiimote = [notification object];
    
    // debug message
    NSLog(@"Wiimote connected: %@ (%@)", [wiimote modelName], [wiimote addressString]);
    
    // begin listen events from wiimote (see WiimoteDelegate.h)
    [wiimote setDelegate:self];
    [[wiimote accelerometer] setEnabled:NO]; // and enable accelerometer
    [wiimote setIREnabled:YES]; // we want to know about IR changes
    
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedGravityX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    // raw accelerometer values.
    // sensitivity can be changed by [[wiimot accelerometer] setGravitySmoothQuant: <value> ];
    
    NSLog(@"RAW: X: %f, Y: %f, Z: %f", x, y, x);
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedPitch:(CGFloat)pitch roll:(CGFloat)roll
{
    // processed values
    // sensitivity can be changed by [[wiimot accelerometer] setAnglesSmoothQuant: <value> ];
    
    NSLog(@"PROCESSED: PITCH: %f, ROLL: %f", pitch, roll);
}

- (void)wiimote:(Wiimote *)wiimote irPointPositionChanged:(WiimoteIRPoint *)point
{
    NSPoint nsPoint = [point position];
    
    NSLog(@"Processed point change: %i, %f, %f", [point index], [point position].x, [point position].y);
    if (point.index == 0) {
        [self.spellView addPoint:nsPoint];
    } else {
        [self.spellView addPoint2:nsPoint];

    }
    [[self spellView] setNeedsDisplay:YES];
    [[self view] setNeedsDisplay:YES];
    
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

- (void) startRecognizing {
    recognizing = true;
}

- (void) recognize {
    PennyPincherResult* result =[PennyPincher recognize:[[self spellView].pixels copy] templates:spells.spellTemplates];
    if (result != nil) {
        NSLog(@"Recognize value: %@", result);
        self.recognizedSpellNameLabel.stringValue = result.template.id;
        
        
        // Create the request.
        NSString *baseURL = @"http://127.0.0.1:3000/";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[baseURL stringByAppendingString:result.template.id]]];
        
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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


@end
