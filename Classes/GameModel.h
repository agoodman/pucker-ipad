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
#define kDefaultCx	384.0
#define kDefaultCy	100.0


@protocol GameStateDelegate
-(void)puckLaunched;
-(void)puckWallBounce;
-(void)scoreDidChange:(int)newScore;
-(void)multiplierDidChange:(int)newMultiplier;
-(void)attemptsDidChange:(int)newAttempts;
-(void)turnEndedWithState:(NSDictionary*)stateDictionary;
-(void)gameEndedWithState:(NSDictionary*)stateDictionary;
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
	
	id<GameStateDelegate> gameStateDelegate;
	dispatch_queue_t queue;
	
}

@property (assign) id<GameStateDelegate> gameStateDelegate;
@property (retain) Puck* activePuck;
@property (retain) NSMutableArray* pucks;
@property float cx;
@property float cy;
@property float angle;
@property float power;

-(void)resumeGameWithAttempts:(int)aAttempts score:(int)aScore multiplier:(int)aMultiplier cx:(float)aCx cy:(float)aCy angle:(float)aAngle power:(float)aPower pucks:(NSArray*)aPucks;
-(void)resetGame;
-(void)update:(float)dt;
-(void)launchPuck;
-(void)endTurn;
-(void)gameOver;

@end
