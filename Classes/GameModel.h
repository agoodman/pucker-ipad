//
//  GameModel.h
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Puck.h"

#define kPuckDamping 500.0


@protocol GameStateDelegate
-(void)scoreDidChange:(int)newScore;
-(void)multiplierDidChange:(int)newMultiplier;
-(void)attemptsDidChange:(int)newAttempts;
@end


@interface GameModel : NSObject {

	Puck* activePuck;
	NSMutableArray* pucks;
	NSMutableArray* pucksOld;
	NSMutableArray* pucksNew;
	
	float cx, cy;
	float angle, power;
	
	int score;
	int multiplier;
	int attempts;
	
	id<GameStateDelegate> scoreDelegate;
	
}

@property (assign) id<GameStateDelegate> scoreDelegate;
@property (retain) Puck* activePuck;
@property (retain) NSMutableArray* pucks;
@property float cx;
@property float cy;
@property float angle;
@property float power;

-(void)resetGame;
-(void)update:(float)dt;
-(void)launchPuck;

@end
