//
//  SpellView.m
//  Potterspell
//
//  Created by Joshua DeWald on 4/1/18.
//  Copyright © 2018 Joshua DeWald. All rights reserved.
//

#import "SpellView.h"

@implementation SpellView

-(void) awakeFromNib {
    self.pixels = [[NSMutableArray alloc] initWithCapacity:100];
        self.pixels2 = [[NSMutableArray alloc] initWithCapacity:100];
}
- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];

    return self;
}



- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    CGFloat xFact = self.frame.size.width / 1024;
    CGFloat yFact = self.frame.size.height / 768;
    
    CGContextRef myContext  = [[NSGraphicsContext // 1
                          currentContext] graphicsPort];
    
      CGContextSetRGBFillColor (myContext, 1, 0, 0, 1);
     //CGContextFillRect (myContext, CGRectMake (0, 0, 200, 100 ));
    
    [[self pixels] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPoint point = ((NSValue*)obj).pointValue;
        CGContextFillRect(myContext, CGRectMake((1024 - point.x) * xFact, point.y * yFact, 5, 5));
    }];
    
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 1);
    [[self pixels2] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPoint point = ((NSValue*)obj).pointValue;
        CGContextFillRect(myContext, CGRectMake((1024 - point.x) * xFact, point.y * yFact, 5, 5));
    }];
}

-(void) addPoint:(NSPoint)point {
    [self.pixels addObject:[NSValue valueWithPoint:point]];

}

-(void) addPoint2:(NSPoint)point {
    [self.pixels2 addObject:[NSValue valueWithPoint:point]];

}

-(void) clearPoints {
    [self.pixels removeAllObjects];
    [self.pixels2 removeAllObjects];
}

@end
