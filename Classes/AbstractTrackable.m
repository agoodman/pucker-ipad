//
//  AbstractTrackable.m
//  ScorchLite
//
//  Created by Aubrey Goodman on 3/28/09.
//  Copyright 2009 Migrant Studios LLC. All rights reserved.
//

#import "AbstractTrackable.h"


@implementation AbstractTrackable

@synthesize x, y, u, v, du, dv;
@synthesize a, r, s, da, dr, ds;

- (CGPoint)position
{
	return CGPointMake(x, y);
}

- (CGPoint)velocity
{
	return CGPointMake(u, v);
}

- (CGPoint)acceleration
{
	return CGPointMake(du, dv);
}

- (float)scalarVelocity
{
	return sqrt(u*u+v*v);
}

- (float)scalarAcceleration
{
	return sqrt(du*du+dv*dv);
}

- (bool)isNearTrack:(AbstractTrackable*)track
{
	float dx = abs(track.x-x),
		dy = abs(track.y-y);
	if( dx>480 ) {
		dx = 960 - dx;
	}
	if( dy>320 ) {
		dy = 640 - dy;
	}
	return (dx<kTrackNearRange && dy<kTrackNearRange);
}

- (float)rangeToTrack:(AbstractTrackable*)track
{
	float dx = abs(track.x-x),
		dy = abs(track.y-y);
	if( dx>480 ) {
		dx = 960 - dx;
	}
	if( dy>320 ) {
		dy = 640 - dy;
	}
	float tRange = sqrt(dx*dx+dy*dy);
	return tRange;
}

- (void)tick:(float)dt
{
	x += u*dt;
	y += v*dt;
	
	if( x<0 || x>960 ) {
		x = fmod(x+960,960);
	}
	
	u += du*dt;
	v += dv*dt;
	
	a += da*dt;
	r += dr*dt;
	s += ds*dt;
}

- (NSArray*)keys
{
	return [NSArray arrayWithObjects:@"x",@"y",@"u",@"v",@"du",@"dv",@"r",@"a",@"s",@"dr",@"da",@"ds",nil];
}


@end
