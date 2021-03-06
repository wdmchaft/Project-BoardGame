//
//  BoardGameView.m
//  BoardGame
//
//  Created by Liz on 10-8-25.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "BoardGameView.h"


@interface BoardGameView (Private)

- (void)enterRumbleZoomOut;
- (void)enterRumblePan;
- (void)enterRumbleZoomIn;
- (void)enterRumbleZoomInComplete;

- (void)exitRumbleZoomOut;
- (void)exitRumblePan;
- (void)exitRumbleZoomIn;
- (void)exitRumbleZoomInComplete;

@end

@implementation BoardGameView



- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		board = [[Board alloc] initWithFrame:self.bounds];
		rumbleBoard = [[RumbleBoard alloc]initWithFrame:self.bounds];
		self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)initGame{
	[board setValue:controller forKey:@"controller"];
	[board setValue:self forKey:@"bgv"];
	[rumbleBoard setValue:controller forKey:@"controller"];
	[rumbleBoard setValue:self forKey:@"bgv"];
	[self addSubview:board];

}

// Switch:
//  ZoomOut, Pan, ZoomIn


- (void)enterRumble{
	[self enterRumbleZoomOut];
	[GameLogic sharedInstance].animationInProgress = YES;
}

- (void)enterRumbleZoomOut{
	[rumbleBoard enterRumble];
	
	rumbleBoard.transform = CGAffineTransformMakeScale(ZoomOutScale,ZoomOutScale);
	rumbleBoard.center = CGPointMake(self.center.x + PanDistance, self.center.y);
	
	[self addSubview:rumbleBoard];
	
	[UIView beginAnimations:@"ZoomOut" context:nil];
	[UIView setAnimationDuration:ZoomOutTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enterRumblePan)];	
	board.transform = CGAffineTransformMakeScale(ZoomOutScale,ZoomOutScale);
	[UIView commitAnimations];
	
}

- (void)enterRumblePan{
	[UIView beginAnimations:@"Pan" context:nil];
	[UIView setAnimationDuration:ZoomOutTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enterRumbleZoomIn)];	
	board.center = CGPointMake(self.center.x - PanDistance, self.center.y);
	rumbleBoard.center = self.center;
	[UIView commitAnimations];
}

- (void)enterRumbleZoomIn{
	[UIView beginAnimations:@"ZoomIn" context:nil];
	[UIView setAnimationDuration:ZoomOutTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enterRumbleZoomInComplete)];
	rumbleBoard.transform = CGAffineTransformMakeScale(1, 1);
	rumbleBoard.frame = self.bounds;
	[UIView commitAnimations];
}

- (void)enterRumbleZoomInComplete{
	[GameLogic sharedInstance].animationInProgress = NO;
	[rumbleBoard enterRumbleAnimDidStop];
}


- (void)exitRumble{
	[GameLogic sharedInstance].animationInProgress = YES;	
	[self exitRumbleZoomOut];
}

- (void)exitRumbleZoomOut{
	board.transform = CGAffineTransformMakeScale(ZoomOutScale,ZoomOutScale);
	board.center = CGPointMake(self.center.x - PanDistance, self.center.y);
	
	[UIView beginAnimations:@"ZoomOut" context:nil];
	[UIView setAnimationDuration:ZoomOutTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(exitRumblePan)];	
	rumbleBoard.transform = CGAffineTransformMakeScale(ZoomOutScale,ZoomOutScale);
	[UIView commitAnimations];
	
}

- (void)exitRumblePan{
	[UIView beginAnimations:@"Pan" context:nil];
	[UIView setAnimationDuration:ZoomOutTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(exitRumbleZoomIn)];	
	rumbleBoard.center = CGPointMake(self.center.x + PanDistance, self.center.y);
	board.center = self.center;
	[UIView commitAnimations];
}

- (void)exitRumbleZoomIn{
	[rumbleBoard removeFromSuperview];

	[UIView beginAnimations:@"ZoomIn" context:nil];
	[UIView setAnimationDuration:ZoomOutTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(exitRumbleZoomInComplete)];
	board.transform = CGAffineTransformMakeScale(1, 1);
	board.frame = self.bounds;
	[UIView commitAnimations];
}

- (void)exitRumbleZoomInComplete{
	[GameLogic sharedInstance].animationInProgress = NO;	
	[rumbleBoard exitRumble];
	[rumbleBoard exitRumbleAnimDidStop];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reset{
	[board removeFromSuperview];
	[rumbleBoard removeFromSuperview];
	[board reset];
	[rumbleBoard reset];
}



- (void)dealloc {
	[board release];
	[rumbleBoard release];
    [super dealloc];
}


@end
