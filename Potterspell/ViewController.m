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


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self attachToWiimote];
    
    // Do any additional setup after loading the view.
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
    [[wiimote accelerometer] setEnabled:YES]; // and enable accelerometer
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
        [((SpellView*)[self view]) addPoint:nsPoint];
    } else {
        [((SpellView*)[self view]) addPoint2:nsPoint];

    }
    [[self view] setNeedsDisplay:YES];
}

- (void)wiimoteDisconnected:(Wiimote*)wiimote
{
    // debug message
    NSLog(@"Wiimote disconnected: %@ (%@)", [wiimote modelName], [wiimote addressString]);
}

@end
