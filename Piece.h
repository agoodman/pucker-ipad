//
//  Piece.h
//  pucker
//
//  Created by Aubrey Goodman on 3/28/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Piece : NSObject {

	int pieceId;
	float x;
	float y;
	float radius;
	int count;
	
}

@property int pieceId;
@property float x;
@property float y;
@property float radius;
@property int count;


@end
