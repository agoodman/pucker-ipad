//
//  GameModel.m
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "GameModel.h"


@interface GameModel (private)
-(void)checkPuckEvents:(float)dt;
-(void)growActivePuck;
-(BOOL)doesActivePuckInteractWithPuck:(Puck*)p after:(float)dt;
-(BOOL)doesActivePuckInteractWithRect:(CGRect)rect after:(float)dt;
-(BOOL)doesActivePuckInteractWithShieldAfter:(float)dt;
@end


@implementation GameModel

@synthesize scoreDelegate;
@synthesize activePuck;
@synthesize pucks;
@synthesize cx, cy, angle, power;

- (id)init
{
	if( self = [super init] ) {
		self.cx = 384.0;
		self.cy = 100.0;
		
		attempts = 10;
		
		self.pucks = [[[NSMutableArray alloc] init] autorelease];
		pucksOld = [[NSMutableArray alloc] init];
		pucksNew = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)setPower:(float)aPower
{
	if( aPower<600 ) {
		power = 600;
	}else if( aPower<800 ) {
		power = 800;
	}else if( aPower<1000 ) {
		power = 1000;
	}else{
		power = 1200;
	}
}

- (void)resumeGameWithAttempts:(int)aAttempts 
						 score:(int)aScore 
					multiplier:(int)aMultiplier
							cx:(float)aCx
							cy:(float)aCy
						 angle:(float)aAngle
						 power:(float)aPower4
						 pucks:(NSArray*)aPucks
{
	attempts = aAttempts;
	score = aScore;
	multiplier = aMultiplier;
	[pucks removeAllObjects];
	[pucks addObjectsFromArray:aPucks];
}

- (void)update:(float)dt
{
	[self checkPuckEvents:dt];
	
	if( activePuck ) {
		activePuck.x += activePuck.u * dt;
		activePuck.y += activePuck.v * dt;
		
		float mag = [activePuck scalarVelocity];
		float uu = activePuck.u / mag, vv = activePuck.v / mag;
		
		mag -= kPuckDamping * dt;
		activePuck.u = uu * mag;
		activePuck.v = vv * mag;
		
		if( activePuck.ds!=0 ) {
			activePuck.s += activePuck.ds;
		}
	}
}

- (void)checkPuckEvents:(float)dt
{
	if( !activePuck ) {
		return;
	}
	
	// check for shield interaction
	if( activePuck.launched && [self doesActivePuckInteractWithShieldAfter:dt] ) {
		self.activePuck = nil;
		attempts--;
		[scoreDelegate attemptsDidChange:attempts];
	}
	
	// check for launch
	if( !activePuck.launched ) {
		if( abs(activePuck.x-cx)>150+activePuck.radius && 
		   abs(activePuck.y-cy)>150+activePuck.radius ) 
		{
			activePuck.launched = YES;
		}else{
			float dx = activePuck.x - cx, dy = activePuck.y - cy;
			if( sqrt(dx*dx+dy*dy)>150+activePuck.radius ) {
				activePuck.launched = YES;
			}
		}
	}
	
	// check all pucks for collisions with active puck
	for (Puck* p in pucks) {
		BOOL collisionDetected = NO;
		if( [self doesActivePuckInteractWithPuck:p after:dt] ) {
			if( activePuck.launched ) {
				p.count = p.count - 1;
				multiplier++;
				[scoreDelegate multiplierDidChange:multiplier];
				collisionDetected = YES;
			}else{
				attempts--;
				self.activePuck = nil;
				[scoreDelegate attemptsDidChange:attempts];
				collisionDetected = YES;
			}
		}
		if( p.count<=0 ) {
			score += multiplier;
			[scoreDelegate scoreDidChange:score];
			[pucksOld addObject:p];
		}
		if( collisionDetected ) {
			break;
		}
	}
	[pucks removeObjectsInArray:pucksOld];
	[pucksOld removeAllObjects];
	
	// check for wall interaction
	if( [self doesActivePuckInteractWithRect:CGRectMake(0, 0, 768, 906) after:dt] ) {
		if( activePuck.launched ) {
			NSLog(@"TODO play wall bounce sound");
		}else{
			self.activePuck = nil;
			attempts--;
			[scoreDelegate attemptsDidChange:attempts];
		}
	}
	
	if( [activePuck scalarVelocity]<5 ) {
		if( activePuck.launched ) {
			activePuck.u = activePuck.v = 0;
			activePuck.count = 3;
			[self growActivePuck];
			[pucks addObject:activePuck];
		}
		self.activePuck = nil;
	}
}

- (BOOL)doesActivePuckInteractWithPuck:(Puck*)puck after:(float)dt
{
	if( [activePuck projectedDistanceTo:puck after:dt]<0 ) {
		// determine the radial and tangential unit vectors
		float rx = activePuck.x - puck.x,
		ry = activePuck.y - puck.y;
		
		float rmag = sqrt(rx*rx+ry*ry);
		
		rx /= rmag;
		ry /= rmag;
		
		float tx = -ry,
		ty = rx;
		
		// determine radial and tangential velocity components
		float vr = activePuck.u * rx + activePuck.v * ry,
		vt = activePuck.u * tx + activePuck.v * ty;
		
		// reflect radial component
		vr = -vr;
		
		activePuck.u = vr * rx + vt * tx;
		activePuck.v = vr * ry + vt * ty;
		
		return YES;
	}
	
	return NO;
}

- (BOOL)doesActivePuckInteractWithRect:(CGRect)rect after:(float)dt
{
	if( activePuck.x - activePuck.radius < rect.origin.x ||
	   activePuck.x + activePuck.u * dt - activePuck.radius < rect.origin.x ||
	   activePuck.x + activePuck.radius > rect.origin.x + rect.size.width ||
	   activePuck.x + activePuck.u * dt + activePuck.radius > rect.origin.x + rect.size.width )
	{
		activePuck.u = -activePuck.u;
		return YES;
	}
	if( activePuck.y - activePuck.radius < rect.origin.y ||
	   activePuck.y + activePuck.v * dt - activePuck.radius < rect.origin.y ||
	   activePuck.y + activePuck.radius > rect.origin.y + rect.size.height ||
	   activePuck.y + activePuck.v * dt + activePuck.radius > rect.origin.y + rect.size.height )
	{
		activePuck.v = -activePuck.v;
		return YES;
	}
	return NO;
}

- (BOOL)doesActivePuckInteractWithShieldAfter:(float)dt
{
	float dx = activePuck.x + activePuck.u * dt - cx,
		dy = activePuck.y + activePuck.v * dt - cy;
	float d = sqrt(dx*dx+dy*dy);
	if( abs(d - 150.0 - activePuck.radius)<5 ) {
		return YES;
	}
	return NO;
}

- (void)growActivePuck
{
	float dx = activePuck.x - cx, dy = activePuck.y - cy;
	float dmin = sqrt(dx*dx+dy*dy) - 150;
	for (Puck* p in pucks) {
		dx = activePuck.x - p.x;
		dy = activePuck.y - p.y;
		float d = sqrt(dx*dx+dy*dy) - p.radius;
		if( d<dmin ) {
			dmin = d;
		}
	}

	if( activePuck.x<dmin ) {
		dmin = activePuck.x;
	}
	if( 768-activePuck.x<dmin ) {
		dmin = 768-activePuck.x;
	}
	if( activePuck.y<dmin ) {
		dmin = activePuck.y;
	}
	if( 906-activePuck.y<dmin ) {
		dmin = 906-activePuck.y;
	}
	activePuck.radius = dmin;
	activePuck.s = 0.2 * dmin / 16.0f;
}

- (void)launchPuck
{
	float u = power * cos(angle);
	float v = power * sin(angle);
	self.activePuck = [[[Puck alloc] initAtPoint:CGPointMake(cx, cy) withVelocity:CGPointMake(u, v)] autorelease];
	multiplier = 1;
	[scoreDelegate multiplierDidChange:multiplier];
}

#pragma mark -


- (void)dealloc
{
	[activePuck release];
	[pucks release];
	[pucksOld release];
	[pucksNew release];
	[super dealloc];
}

@end
