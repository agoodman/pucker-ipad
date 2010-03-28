//
//  ESRenderer.h
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright Migrant Studios 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol ESRenderer <NSObject>

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
