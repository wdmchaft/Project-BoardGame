//
//  GameMode.m
//  BoardGame
//
//  Created by Liz on 10-11-14.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "GameMode.h"
#import "GameLogic.h"
#import "Player.h"
#import "Project.h"
#import "Badge.h"


@implementation GameMode

- (GameResult)validate{
	return GameResultContinue;
}

- (NSString *)description{
	return @"";
}

#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:type forKey:@"type"];
    [coder encodeInt:roundLimit forKey:@"roundLimit"];	
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    type = [coder decodeIntForKey:@"type"];
	roundLimit = [coder decodeIntForKey:@"roundLimit"];
    return self;
}

@end



@implementation GameModeCollectResource

- (id)initWithResourceType:(ResourceType)aType targetAmount:(int)amount andRoundLimit:(int)limit{
	if ((self = [super init])) {
		type = aType;
		targetAmount = amount;
		roundLimit = limit;
	}
	return self;
}

- (GameResult)validate{
	//always check the first player
	Player * p = [[GameLogic sharedInstance] playerWithID:0];
	
	if ([p.tokenAmounts amountForIndex:type] >= targetAmount) {
		return GameResultSuccess;
	}
	
	if ([Round sharedInstance].count >= roundLimit) {
		return GameResultFailure;
	}	
	
	return GameResultContinue;
}

- (NSString *)description{
	return [NSString stringWithFormat:@"Collect %d %@ within %d rounds.",
			targetAmount, 
			[GameLogic descriptionForResourceType:type],
			roundLimit];
}

#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
    [coder encodeInt:targetAmount forKey:@"targetAmount"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
	targetAmount = [coder decodeIntForKey:@"targetAmount"];
    return self;
}

@end



@implementation GameModeBuildProject

- (id)initWithRumbleTargetType:(ResourceType)aType andRoundLimit:(int)limit{
	if ((self = [super init])) {
		type = aType;
		roundLimit = limit;
	}
	return self;
}


- (GameResult)validate{
	//always check the first player
	Player * p = [[GameLogic sharedInstance] playerWithID:0];
	
	for (Project * project in p.projects) {
		if (project.isCompleted && project.type == type) {
			return GameResultSuccess;
		}
	}
	
	if ([Round sharedInstance].count >= roundLimit) {
		return GameResultFailure;
	}
	
	return GameResultContinue;
}

- (NSString *)description{
	return [NSString stringWithFormat:@"Build %@ within %d rounds.",
			[GameLogic titleForRumbleTargetType:type],
			roundLimit];
}

@end



@implementation GameModeGetBadge

- (id)initWithBadgeType:(BadgeType)aType andRoundLimit:(int)limit{
	if ((self = [super init])) {
		type = aType;
		roundLimit = limit;
	}
	return self;
}

- (GameResult)validate{
	//always check the first player
	Player * p = [[GameLogic sharedInstance] playerWithID:0];
	
	for (Badge * b in p.badges) {
		if (b.type == type) {
			return GameResultSuccess;
		}
	}
	
	if ([Round sharedInstance].count >= roundLimit) {
		return GameResultFailure;
	}
		
	return GameResultContinue;
}

- (NSString *)description{
	return [NSString stringWithFormat:@"Get %@ Badge within %d rounds.",
			[GameLogic shortDescriptionForBadgeType:type],
			roundLimit];
}

@end
