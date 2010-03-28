//
//  Move.m
//  pucker
//
//  Created by Aubrey Goodman on 3/28/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "Move.h"


@implementation Move

@synthesize game_id, x, y, angle, power, attempts, pieces, score_differential, max_multiplier;

- (void)dealloc
{
	[pieces release];
	[super dealloc];
}

@end
