//
//  PuckLayer.m
//  pucker
//
//  Created by Aubrey Goodman on 3/26/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "PuckLayer.h"
#import "Puck.h"


@implementation PuckLayer

- (id)init
{
	if( self=[super init] ) {
		// load images using Pucks.plist
		NSArray* tSprites = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Pucks" ofType:@"plist"]];
		numSprites = tSprites.count;
		for (int k=0,K=numSprites;k<K;k++) {
			sprites[k] = [[Texture2D alloc] initWithImage:[UIImage imageNamed:[tSprites objectAtIndex:k]]];
		}
	}
	
	return self;
}

- (void)updateWithPucks:(NSArray*)pucks
{
	int tIndex = 0;
	for (Puck* p in pucks) {
		if( tIndex==kMaxTracks ) break;
		index[tIndex] = p.count;
		translations[tIndex] = CGPointMake(p.x, p.y);
		rotations[tIndex] = p.r;
		scales[tIndex] = p.s;
		alphas[tIndex] = p.a;
		tIndex++;
	}
	numTracks = tIndex;
}

@end
