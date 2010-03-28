//
//  Game.m
//  pucker
//
//  Created by Aubrey Goodman on 3/28/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "Game.h"


@implementation Game

@synthesize gameId, uuid, moves;

- (void)dealloc
{
	[uuid release];
	[moves release];
	[super dealloc];
}

@end
