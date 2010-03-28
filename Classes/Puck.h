//
//  Puck.h
//  PuckerLite
//
//  Created by Aubrey Goodman on 1/24/09.
//  Copyright 2009 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTrackable.h"

#define kMaxRadius 81.5
#define kScale 0.147


@protocol PuckEventDelegate

-(void)puckStopped;
-(void)puckInactive;

@end

@interface Puck : AbstractTrackable {

	int player;
	float radius, targetRadius;
	int count;
	bool launched;
	id<PuckEventDelegate> delegate;
	
}

@property int player;
@property float targetRadius;
@property float radius;
@property int count;
@property bool launched;

-(id)initAtPoint:(CGPoint)point withVelocity:(CGPoint)velocity;
-(void)setDelegate:(id<PuckEventDelegate>)aDelegate;
-(bool)wallInteraction:(CGRect)bounds;
-(bool)puckInteraction:(Puck*)puck;
-(bool)boundaryInteraction:(float)ymax;
-(float)distanceTo:(Puck*)puck;
-(float)projectedDistanceTo:(Puck*)puck after:(float)dt;

@end
