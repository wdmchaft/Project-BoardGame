//
//  TypeDef.m
//  BoardGame
//
//  Created by Liz on 10-9-8.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "TypeDef.h"

const int TokenScoreModifier[NumberOfTokenTypes]={1,3,5};

const int RumbleTargetScoreModifier[NumberOfTokenTypes]={5,7,9};

const int BadgeTypes[NumberOfBadgeTypes] = {
	BadgeTypeMostRound,
	BadgeTypeMostRect,
	BadgeTypeMostSquare,
	
	BadgeTypeMostRobot,
	BadgeTypeMostSnake,
	BadgeTypeMostPalace,
	
	BadgeTypeEnoughRound,
	BadgeTypeEnoughRect,
	BadgeTypeEnoughSquare,
	
	BadgeTypeHasRobot,
	BadgeTypeHasSnake,
	BadgeTypeHasPalace
};

const int EnoughResource[NumberOfTokenTypes]={10,8,6};


void CGContextDrawImageInverted(CGContextRef c, CGRect r, CGImageRef image){
	CGContextSaveGState(c);
	CGContextScaleCTM(c, 1, -1);
	r.size.height *= -1;
	r.origin.y *= -1;
	CGContextDrawImage(c, r, image);
	r.size.height *= -1;
	r.origin.y *= -1;
	CGContextRestoreGState(c);
	
}