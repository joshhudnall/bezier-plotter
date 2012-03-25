//
//  BDBezierView.h
//  BezierDemo
//
//  Created by Alexander v. Below on 07.11.08.
//  Copyright 2008 AVB Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDPointView.h"

@interface BDBezierView : UIView {
	BDPointView * startView;
	BDPointView * midView;
	BDPointView * endView;
	BDPointView * controlView;
	BDPointView * controlView2;

	UILabel * point1Label;
	UILabel * point2Label;
	UILabel * point3Label;
	UILabel * point4Label;
	UILabel * point5Label;
}

- (void) setUpView;

@end
