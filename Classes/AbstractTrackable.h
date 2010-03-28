//
//  AbstractTrackable.h
//  ScorchLite
//
//  Created by Aubrey Goodman on 3/28/09.
//  Copyright 2009 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG false
#define kTrackNearRange 50


@interface AbstractTrackable : NSObject {

	float x, y, u, v, du, dv;
	float a, r, s, da, dr, ds;
	
}

@property float x, y, u, v, du, dv;
@property float a, r, s, da, dr, ds;

-(float)scalarVelocity;
-(float)scalarAcceleration;

-(bool)isNearTrack:(AbstractTrackable*)track;
-(float)rangeToTrack:(AbstractTrackable*)track;


@end
