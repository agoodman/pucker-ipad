//
//  GameModel.m
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "GameModel.h"
#import "PlayView.h"


@interface GameModel (private)
-(void)checkPuckEvents:(float)dt;
-(void)growActivePuck;
-(NSDictionary*)currentState;
-(BOOL)doesActivePuckInteractWithPuck:(Puck*)p after:(float)dt;
-(BOOL)doesActivePuckInteractWithRect:(CGRect)rect after:(float)dt;
-(BOOL)doesActivePuckInteractWithShieldAfter:(float)dt;
@end


@implementation GameModel

@synthesize gameStateDelegate;
@synthesize activePuck;
@synthesize pucks;
@synthesize cx, cy, angle, power;

- (id)init
{
	if( self = [super init] ) {
		queue = dispatch_queue_create("com.migrant.pucker.game", 0);
		
		self.cx = kDefaultCx;
		self.cy = kDefaultCy;
		
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
						 power:(float)aPower
						 pucks:(NSArray*)aPucks
{
	attempts = aAttempts;
	score = aScore;
	multiplier = aMultiplier;
	cx = aCx;
	cy = aCy;
	angle = aAngle;
	power = aPower;
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
		[gameStateDelegate attemptsDidChange:attempts];
		if( attempts<=0 ) {
			[self gameOver];
			return;
		}
	}
	
	// check for launch
	if( !activePuck.launched ) {
		if( abs(activePuck.x-cx)>kPanRange+activePuck.radius && 
		   abs(activePuck.y-cy)>kPanRange+activePuck.radius ) 
		{
			activePuck.launched = YES;
		}else{
			float dx = activePuck.x - cx, dy = activePuck.y - cy;
			if( sqrt(dx*dx+dy*dy)>kPanRange+activePuck.radius ) {
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
				[gameStateDelegate multiplierDidChange:multiplier];
				collisionDetected = YES;
			}else{
				attempts--;
				self.activePuck = nil;
				[gameStateDelegate attemptsDidChange:attempts];
				if( attempts<=0 ) {
					[self gameOver];
					return;
				}
				collisionDetected = YES;
			}
		}
		if( p.count<=0 ) {
			score += multiplier;
			[gameStateDelegate scoreDidChange:score];
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
			[gameStateDelegate puckWallBounce];
		}else{
			self.activePuck = nil;
			attempts--;
			[gameStateDelegate attemptsDidChange:attempts];
			if( attempts<=0 ) {
				[self gameOver];
				return;
			}
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
		[self endTurn];
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
	[gameStateDelegate multiplierDidChange:multiplier];
	[gameStateDelegate puckLaunched];
}

- (void)endTurn
{
	[gameStateDelegate turnEndedWithState:[self currentState]];
}

- (void)gameOver
{
	[gameStateDelegate gameEndedWithState:[self currentState]];
}

#pragma mark -

- (NSDictionary*)currentState
{
	NSMutableDictionary* tState = [[[NSMutableDictionary alloc] init] autorelease];
	[tState setValue:[NSNumber numberWithInt:attempts] forKey:@"attempts"];
	[tState setValue:[NSNumber numberWithInt:score] forKey:@"score"];
	[tState setValue:[NSNumber numberWithInt:multiplier] forKey:@"multiplier"];
	[tState setValue:[NSNumber numberWithFloat:cx] forKey:@"cx"];
	[tState setValue:[NSNumber numberWithFloat:cy] forKey:@"cy"];
	[tState setValue:[NSNumber numberWithFloat:angle] forKey:@"angle"];
	[tState setValue:[NSNumber numberWithFloat:power] forKey:@"power"];
	[tState setObject:[NSArray arrayWithArray:pucks] forKey:@"pucks"];
	return tState;
}

- (void)dealloc
{
	[activePuck release];
	[pucks release];
	[pucksOld release];
	[pucksNew release];
	[super dealloc];
}

@end
