//
//  ES1Renderer.h
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright Migrant Studios 2010. All rights reserved.
//

#import "ESRenderer.h"
#import "GameModel.h"
#import "PuckLayer.h"
#import "CannonLayer.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@interface ES1Renderer : NSObject <ESRenderer>
{
	GameModel* model;
	PuckLayer* puckLayer;
	CannonLayer* cannonLayer;
	
@private
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer;
}

@property (retain) GameModel* model;

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
