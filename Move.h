//
//  Move.h
//  pucker
//
//  Created by Aubrey Goodman on 3/28/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"


@interface Move : NSObject {

	int game_id;
	float x;
	float y;
	float angle;
	float power;
	int attempts;
	NSArray* pieces;
	int score_differential;
	int max_multiplier;

}

@property int game_id;
@property float x;
@property float y;
@property float angle;
@property float power;
@property int attempts;
@property (retain) NSArray* pieces;
@property int score_differential;
@property int max_multiplier;


@end
