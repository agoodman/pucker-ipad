    //
//  PlayViewController.m
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "PlayViewController.h"


@interface PlayViewController (private)
-(void)loadSounds;
@end


@implementation PlayViewController

@synthesize playView, pauseView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	// init game model
	model = [[GameModel alloc] init];
	model.gameStateDelegate = self;
	[playView setModel:model];
	
	// load game sounds
	[self loadSounds];
	
	// TODO check for stored state and load if available
	
	// show pause view
	[self newGame];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	// automatically pause game when game view is obscured 
	[self pauseGame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return interfaceOrientation==UIInterfaceOrientationPortrait || 
		interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -

- (void)loadSounds
{
	AudioServicesCreateSystemSoundID((CFURLRef)[[[NSBundle mainBundle] URLForResource:@"multiplier" withExtension:@"caf"] retain], &multiplierSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[[[NSBundle mainBundle] URLForResource:@"attempts" withExtension:@"caf"] retain], &attemptSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[[[NSBundle mainBundle] URLForResource:@"wall" withExtension:@"caf"] retain], &wallSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[[[NSBundle mainBundle] URLForResource:@"score" withExtension:@"caf"] retain], &scoreSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[[[NSBundle mainBundle] URLForResource:@"buzzer" withExtension:@"caf"] retain], &buzzerSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[[[NSBundle mainBundle] URLForResource:@"turn" withExtension:@"caf"] retain], &turnSound);
	AudioServicesCreateSystemSoundID((CFURLRef)[[[NSBundle mainBundle] URLForResource:@"launch" withExtension:@"caf"] retain], &launchSound);
}

- (void)pauseGame
{
	[playView stopAnimation];
	pauseView.hidden = NO;
	gameOverView.hidden = YES;
}

- (IBAction)quitGame
{
	[playView stopAnimation];
	gameOverView.hidden = NO;
	pauseView.hidden = YES;
}

- (IBAction)resumeGame
{
	pauseView.hidden = YES;
	[playView startAnimation];
}

- (IBAction)newGame
{
	[model resumeGameWithAttempts:10 score:0 multiplier:1 cx:kDefaultCx cy:kDefaultCy angle:0 power:600 pucks:nil];
	[playView startAnimation];
	pauseView.hidden = YES;
	gameOverView.hidden = YES;
	playerScoreLabel.text = @"0";
	playerMultiplierLabel.text = @"1x";
	playerAttemptsLabel.text = @"10";
}

#pragma mark -
#pragma mark GameStateDelegate

- (void)puckLaunched
{
	dispatch_async(queue, ^{ AudioServicesPlaySystemSound(launchSound); });
}

- (void)puckWallBounce
{
	dispatch_async(queue, ^{ AudioServicesPlaySystemSound(wallSound); });
}

- (void)scoreDidChange:(int)newScore
{
	dispatch_async(dispatch_get_main_queue(), ^{
		playerScoreLabel.text = [NSString stringWithFormat:@"%d",newScore];
	});
	
	dispatch_async(queue, ^{ AudioServicesPlaySystemSound(scoreSound); });
}

- (void)multiplierDidChange:(int)newMultiplier
{
	dispatch_async(dispatch_get_main_queue(), ^{
		playerMultiplierLabel.text = [NSString stringWithFormat:@"%dx",newMultiplier];
	});
	if( newMultiplier>1 ) {
		dispatch_async(queue, ^{ AudioServicesPlaySystemSound(multiplierSound); });
	}
}

- (void)attemptsDidChange:(int)newAttempts
{
	dispatch_async(dispatch_get_main_queue(), ^{
		playerAttemptsLabel.text = [NSString stringWithFormat:@"%d",newAttempts];
	});
	dispatch_async(queue, ^{ AudioServicesPlaySystemSound(attemptSound); });
}

- (void)turnEndedWithState:(NSDictionary *)stateDictionary
{
	dispatch_async(queue, ^{ AudioServicesPlaySystemSound(turnSound); });
	dispatch_async(queue, ^{
		NSLog(@"TODO save state with %d pucks",[[stateDictionary objectForKey:@"pucks"] count]);
	});
}

- (void)gameEndedWithState:(NSDictionary*)stateDictionary
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self quitGame];
	});
	dispatch_async(queue, ^{ AudioServicesPlaySystemSound(buzzerSound); });
}

#pragma mark -

- (void)dealloc 
{
	[playView release];
	[pauseView release];
	[playerScoreLabel release];
	[playerMultiplierLabel release];
	[playerAttemptsLabel release];
    [super dealloc];
}


@end
