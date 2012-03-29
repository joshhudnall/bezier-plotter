//
//  BDBezierView.m
//  BezierDemo
//
//  Created by Alexander v. Below on 07.11.08.
//  Copyright 2008 AVB Software. All rights reserved.
//

#import "BDBezierView.h"

@interface BDBezierView ()

@property (nonatomic, retain) NSMutableArray *_points;

@end



@implementation BDBezierView
@synthesize _points;

- (id)initWithCoder:(NSCoder *)aCoder {
	if (self = [super initWithCoder:aCoder])
	{
		[self setUpView];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setUpView];
	}
    return self;
}


- (void)setUpView {
	self._points = [NSMutableArray arrayWithCapacity:3];
	
	[self addPointWithControlPoint:NO];
	[self addPointWithControlPoint:YES];
	[self addPointWithControlPoint:YES];
}

- (void)addPointWithControlPoint:(BOOL)addControlPoint {
	NSDictionary *point;
	
	BDPointView *pointView = [[BDPointView alloc] initWithFrame:CGRectMake(20, 20, 40, 40) color:[UIColor redColor]];
    pointView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[self addSubview:pointView];
	
	if (addControlPoint) {
		BDPointView *controlPointView = [[BDPointView alloc] initWithFrame:CGRectMake(40, 20, 40, 40) color:[UIColor greenColor]];
		controlPointView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

		point = [NSDictionary dictionaryWithObjectsAndKeys:
				 [pointView retain], @"point",
				 [controlPointView retain], @"controlPoint", nil];
		
		[self addSubview:controlPointView];
		[controlPointView release];
	} else {
		point = [NSDictionary dictionaryWithObjectsAndKeys:
				 [pointView retain], @"point", nil];
	}
	[pointView release];
	
	[self._points addObject:point];
}

- (CGRect)adjFramePos:(CGRect)frame {
    if (frame.origin.x < self.frame.size.width / 2) {
        frame.origin.x += 45;
    } else {
        frame.origin.x -= 45;
    }
    
    return frame;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx;
	ctx = UIGraphicsGetCurrentContext();
	
	CGMutablePathRef bezierPath = CGPathCreateMutable();
	
	if ([_points count] > 0) {
		BDPointView *view = [[_points objectAtIndex:0] objectForKey:@"point"];
		CGPathMoveToPoint(bezierPath, nil, view.center.x, view.center.y);
	}
	
	for (int i = 1; i < [_points count]; i++) {
		BDPointView *pointView = [[_points objectAtIndex:i] objectForKey:@"point"];
		BDPointView *controlPointView = [[_points objectAtIndex:i] objectForKey:@"controlPoint"];
		CGPathAddQuadCurveToPoint(bezierPath, nil, controlPointView.center.x, controlPointView.center.y, pointView.center.x, pointView.center.y);
	}
	CGContextAddPath(ctx, bezierPath);
	CGContextStrokePath(ctx);
	CFRelease(bezierPath);
    
//    CGRect frame;
//    frame = startView.frame;
//    point1Label.text = [NSString stringWithFormat:@"%.0f,%.0f", startView.center.x, startView.center.y];
//    frame = [self adjFramePos:frame];
//    point1Label.frame = frame;

}

- (void)dealloc {
    [super dealloc];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch * touch in touches) {
		if ([[touch view] isKindOfClass:[BDPointView self]]) {
			CGPoint location = [touch locationInView:self];
			[touch view].center = location;	
            
            //NSLog(@"x: %.0f, y: %.0f", location.x, location.y);

			[self setNeedsDisplay];
			return;
		}
	}
}

- (void)printCode {
	NSMutableString *code = [NSMutableString string];
	
	if ([_points count] > 0) {
		BDPointView *view = [[_points objectAtIndex:0] objectForKey:@"point"];
		[code appendFormat:@"CGPathMoveToPoint(bezierPath, nil, %.0f, %.0f);\n", view.center.x, view.center.y];
	}
	
	for (int i = 1; i < [_points count]; i++) {
		BDPointView *pointView = [[_points objectAtIndex:i] objectForKey:@"point"];
		BDPointView *controlPointView = [[_points objectAtIndex:i] objectForKey:@"controlPoint"];
		[code appendFormat:@"CGPathAddQuadCurveToPoint(bezierPath, nil, %.0f, %.0f, %.0f, %.0f);\n", controlPointView.center.x, controlPointView.center.y, pointView.center.x, pointView.center.y];
	}
	
	NSLog(@"%@", code);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { 
	
	//Get all the touches.
	NSSet *allTouches = [event allTouches];
	
	//Number of touches on the screen
	switch ([allTouches count])
	{
		case 1:
		{
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			switch([touch tapCount])
			{
				case 1: //Single tap
					
					break;
				case 2: //Double tap.
					[self printCode];
					break;
				case 3: //Double tap.
					[self addPointWithControlPoint:YES];
					break;
			}
		} 
			break;
	}
	
}
@end
