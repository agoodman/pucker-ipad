//
//  EAGLView.m
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright Migrant Studios 2010. All rights reserved.
//

#import "PlayView.h"

#import "ES1Renderer.h"
#import "ES2Renderer.h"

@implementation PlayView

@synthesize animating;
@dynamic animationFrameInterval;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
    {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

//        renderer = [[ES2Renderer alloc] init];

//        if (!renderer)
//        {
            renderer = [[ES1Renderer alloc] init];

            if (!renderer)
            {
                [self release];
                return nil;
            }
//        }

        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;

        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
    }

    return self;
}

- (void)setModel:(GameModel*)aModel
{
	model = aModel;
	[(ES1Renderer*)renderer setModel:aModel];
}

- (void)drawView:(id)sender
{
	[model update:(float)animationFrameInterval/60.0];
    [renderer render];
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;

        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        if (displayLinkSupported)
        {
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.

            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];

        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }

        animating = FALSE;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( touches.count==1 ) {
		// check if touch is near cannon
		BOOL isNear = YES;
		CGPoint p = [[touches anyObject] locationInView:self];
		if( abs(p.x-model.cx)>150 || abs(p.y-906+model.cy)>150 ) {
			isNear = NO;
		}
		if( isNear ) {
			// start drag
			dragStart = YES;
		}
		
	}else if( touches.count==2 ) {
		// check if both touches are near the cannon
		BOOL isNear = YES;
		for (UITouch* t in touches) {
			CGPoint p = [t locationInView:self];
			if( abs(p.x-model.cx)>150 || abs(p.y-906+model.cy)>150 ) {
				isNear = NO;
				break;
			}
		}
		if( isNear ) {
			// start pan
			panning = YES;
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( touches.count==1 ) {
		if( dragStart ) {
			dragStart = NO;
			dragging = YES;
		}
		CGPoint p = [[touches anyObject] locationInView:self];
		float dx = p.x - model.cx, dy = p.y - 906 + model.cy;
		float tAngle = -atan2(dy, dx);
		float tLength = (sqrt(dx*dx+dy*dy) / 150.0) * 800.0;
		@synchronized( model ) {
			model.angle = tAngle;
			model.power = tLength;
		}
	}else if( touches.count==2 && panning ) {
		UITouch *t = [touches anyObject];
		CGPoint p1 = [t locationInView:self];
		CGPoint p0 = [t previousLocationInView:self];
		@synchronized( model ) {
			float tCx = model.cx + (p1.x - p0.x),
				tCy = model.cy - (p1.y - p0.y);
			float dmin = 768;
			for (Puck* p in model.pucks) {
				float dx = p.x - tCx, dy = p.y - tCy;
				float d = sqrt(dx*dx+dy*dy) - 150.0 - p.radius;
				if( d<dmin ) {
					dmin = d;
				}
			}
			if( tCx>50 && tCx<718 && tCy>50 && tCy<856 && dmin>0 ) {
				model.cx = tCx;
				model.cy = tCy;
			}
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if( panning ) {
		panning = NO;
	}
	if( dragging ) {
		dragging = NO;
		[model launchPuck];
	}
}

- (void)dealloc
{
    [renderer release];

    [super dealloc];
}

@end
