//
//  Game.h
//  pucker
//
//  Created by Aubrey Goodman on 3/28/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Game : NSObject {

	int gameId;
	NSString* uuid;
	NSArray* moves;
	
}

@property int gameId;
@property (retain) NSString* uuid;
@property (retain) NSArray* moves;


@end
