//
//  Puck.m
//  PuckerLite
//
//  Created by Aubrey Goodman on 1/24/09.
//  Copyright 2009 Migrant Studios LLC. All rights reserved.
//

#import "Puck.h"

#define DEBUG false

@implementation Puck

@synthesize player;
@synthesize radius;
@synthesize targetRadius;
@synthesize count;
@synthesize launched;

- (id)initAtPoint:(CGPoint)point withVelocity:(CGPoint)velocity
{
	self.x = point.x;
	self.y = point.y;
	self.u = velocity.x;
	self.v = velocity.y;
	self.count = 0;
	self.s = 0.2;
	self.a = 1.0;
	self.radius = 16;
	
	return self;
}

- (void)setDelegate:(id<PuckEventDelegate>)aDelegate
{
	delegate = aDelegate;
}

- (float)distanceTo:(Puck*)puck
{
	float dx = [puck x]-x,
		dy = [puck y]-y;
	float d = sqrt(dx*dx+dy*dy) - [puck radius] - radius;
	return d;
}

- (float)projectedDistanceTo:(Puck*)puck after:(float)dt
{
	float dx = (puck.x + (puck.u * dt)) - (x + (u * dt)),
		dy = (puck.y + (puck.v * dt)) - (y + (v * dt));
	float d = sqrt(dx*dx+dy*dy) - puck.radius - radius;
	return d;
}

@end
