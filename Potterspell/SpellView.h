//
//  SpellView.h
//  Potterspell
//
//  Created by Joshua DeWald on 4/1/18.
//  Copyright © 2018 Joshua DeWald. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpellView : NSView 
@property NSMutableArray *pixels;
@property NSMutableArray *pixels2;
-(void) addPoint:(NSPoint)point;
-(void) addPoint2:(NSPoint)point;
-(void) clearPoints;
@end
