//
//  SpriteLayer.m
//  ScorchLite
//
//  Created by Aubrey Goodman on 9/9/09.
//  Copyright 2009 Migrant Studios LLC. All rights reserved.
//

#import "SpriteLayer.h"
#import "AbstractTrackable.h"
#import "Puck.h"


@implementation SpriteLayer

- (void)render
{
	for (int k=0;k<numTracks;k++) {
		glPushMatrix();
		glLoadIdentity();
		glTranslatef(translations[k].x, translations[k].y, 0);
		glRotatef(rotations[k]*180.0/M_PI, 0, 0, 1);
		glScalef(scales[k], scales[k], 1);
		glColor4f(1.0, 1.0, 1.0, alphas[k]);
		
		[sprites[index[k]] drawAtPoint:CGPointZero];
		
		glPopMatrix();
	}
}

- (void)dealloc
{
	for (int k=0;k<numSprites;k++) {
		[sprites[k] release];
	}
	[super dealloc];
}


@end
