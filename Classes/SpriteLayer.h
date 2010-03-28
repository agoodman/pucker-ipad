//
//  SpriteLayer.h
//  Pucker
//
//  Created by Aubrey Goodman on 03/22/10.
//  Copyright 2010 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"

#define kMaxTracks 100


@interface SpriteLayer : NSObject {

	Texture2D *sprites[kMaxTracks];
	int numSprites;
	
	int index[kMaxTracks];
	CGPoint translations[kMaxTracks];
	float rotations[kMaxTracks];
	float scales[kMaxTracks];
	float alphas[kMaxTracks];
	int numTracks;

}

-(void)render;


@end
