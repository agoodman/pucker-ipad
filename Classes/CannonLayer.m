//
//  CannonLayer.m
//  pucker
//
//  Created by Aubrey Goodman on 3/23/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "CannonLayer.h"


@implementation CannonLayer


- (id)init
{
	if( self = [super init] ) {
		sprites[0] = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"cannon-background.png"]];
		sprites[1] = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"inner-ring.png"]];
		sprites[2] = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"outer-ring.png"]];
		sprites[3] = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"cannon.png"]];
		numSprites = 4;
		numTracks = 5;
	}
	
	return self;
}

- (void)cx:(float)cx cy:(float)cy angle:(float)angle power:(float)power
{
	int k = 0;
	index[k] = 0;
	translations[k] = CGPointMake(cx, cy);
	rotations[k] += 0.0015;
	scales[k] = 0.9;
	alphas[k++] = 0.75;

	index[k] = 0;
	translations[k] = CGPointMake(cx, cy);
	rotations[k] -= 0.002;
	scales[k] = 0.9;
	alphas[k++] = 0.75;
	
	index[k] = 1;
	translations[k] = CGPointMake(cx, cy);
	rotations[k] += 0.005;
	scales[k] = 1.0 + 0.05*cos(25*rotations[k]);
	alphas[k++] = 0.5;

	index[k] = 2;
	translations[k] = CGPointMake(cx, cy);
	rotations[k] -= 0.005;
	scales[k] = 1.0 + 0.05*sin(25*rotations[k]);
	alphas[k++] = 0.5;
	
	index[k] = 3;
	translations[k] = CGPointMake(cx, cy);
	rotations[k] = angle;
	scales[k] = 1.0;
	alphas[k++] = 1.0;
}

@end
