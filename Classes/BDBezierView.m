//
//  BDBezierView.m
//  BezierDemo
//
//  Created by Alexander v. Below on 07.11.08.
//  Copyright 2008 AVB Software. All rights reserved.
//

#import "BDBezierView.h"


@implementation BDBezierView

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


- (void) setUpView {
	CGFloat w = self.bounds.size.width;
	// CGFloat h = self.bounds.size.height;

	startView = [[BDPointView alloc] initWithFrame:CGRectMake(20, 200, 40, 40) color:[UIColor redColor]];
    startView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	midView = [[BDPointView alloc] initWithFrame:CGRectMake(w/2, 200, 40, 40) color:[UIColor greenColor]];
    midView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	endView = [[BDPointView alloc] initWithFrame:CGRectMake(w-60, 200, 40, 40) color:[UIColor redColor]];
    endView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	controlView = [[BDPointView alloc] initWithFrame:CGRectMake(w/2-20, 100, 40, 40) color:[UIColor blueColor]];
    controlView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	controlView2 = [[BDPointView alloc] initWithFrame:CGRectMake(w/2-10, 100, 40, 40) color:[UIColor blueColor]];
    controlView2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    point1Label = [[UILabel alloc] init]; 
    point1Label.textColor = [UIColor blueColor];
    point1Label.backgroundColor = [UIColor clearColor];
    point1Label.font = [UIFont systemFontOfSize:10];

    point2Label = [[UILabel alloc] init]; 
    point2Label.textColor = [UIColor blueColor];
    point2Label.backgroundColor = [UIColor clearColor];
    point2Label.font = [UIFont systemFontOfSize:10];

    point3Label = [[UILabel alloc] init]; 
    point3Label.textColor = [UIColor blueColor];
    point3Label.backgroundColor = [UIColor clearColor];
    point3Label.font = [UIFont systemFontOfSize:10];

    point4Label = [[UILabel alloc] init]; 
    point4Label.textColor = [UIColor blueColor];
    point4Label.backgroundColor = [UIColor clearColor];
    point4Label.font = [UIFont systemFontOfSize:10];

    point5Label = [[UILabel alloc] init]; 
    point5Label.textColor = [UIColor blueColor];
    point5Label.backgroundColor = [UIColor clearColor];
    point5Label.font = [UIFont systemFontOfSize:10];
    
    [self addSubview:point1Label];
    [self addSubview:point2Label];
    [self addSubview:point3Label];
    [self addSubview:point4Label];
    [self addSubview:point5Label];
	
	[self addSubview:startView];
	[self addSubview:endView];
	[self addSubview:controlView];
	[self addSubview:midView];
	[self addSubview:controlView2];
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
	
	CGPathMoveToPoint(bezierPath, nil, startView.center.x, startView.center.y);
	CGPathAddQuadCurveToPoint(bezierPath, nil, controlView.center.x, controlView.center.y, midView.center.x, midView.center.y);
	CGPathAddQuadCurveToPoint(bezierPath, nil, controlView2.center.x, controlView2.center.y, endView.center.x, endView.center.y);
	CGContextAddPath(ctx, bezierPath);
	CGContextStrokePath(ctx);
	CFRelease(bezierPath);
    
    CGRect frame;
    frame = startView.frame;
    point1Label.text = [NSString stringWithFormat:@"%.0f,%.0f", startView.center.x, startView.center.y];
    frame = [self adjFramePos:frame];
    point1Label.frame = frame;

    frame = midView.frame;
    point2Label.text = [NSString stringWithFormat:@"%.0f,%.0f", midView.center.x, midView.center.y];
    frame = [self adjFramePos:frame];
    point2Label.frame = frame;

    frame = endView.frame;
    point3Label.text = [NSString stringWithFormat:@"%.0f,%.0f", endView.center.x, endView.center.y];
    frame = [self adjFramePos:frame];
    point3Label.frame = frame;

    frame = controlView.frame;
    point4Label.text = [NSString stringWithFormat:@"%.0f,%.0f", controlView.center.x, controlView.center.y];
    frame = [self adjFramePos:frame];
    point4Label.frame = frame;

    frame = controlView2.frame;
    point5Label.text = [NSString stringWithFormat:@"%.0f,%.0f", controlView2.center.x, controlView2.center.y];
    frame = [self adjFramePos:frame];
    point5Label.frame = frame;
}

- (void)dealloc {
    [super dealloc];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	for (UITouch * touch in touches)
	{
		if ([[touch view] isKindOfClass:[BDPointView self]]) {
			CGPoint location = [touch locationInView:self];
			[touch view].center = location;	
            
            NSLog(@"x: %.0f, y: %.0f", location.x, location.y);

			[self setNeedsDisplay];
			return;
		}
	}
}
@end
