    //
//  PlayViewController.m
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import "PlayViewController.h"


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
	
	// init game model
	model = [[GameModel alloc] init];
	model.scoreDelegate = self;
	[playView setModel:model]; 
	
	// TODO check for stored state and load if available
	
	// show pause view
	[self showPause];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self showPause];
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

- (void)showPause
{
	[playView stopAnimation];
	pauseView.hidden = NO;
}

- (IBAction)quitGame
{
	
}

- (IBAction)resumeGame
{
	pauseView.hidden = YES;
	[playView startAnimation];
}

#pragma mark -
#pragma mark ScoreDelegate

- (void)scoreDidChange:(int)newScore
{
	playerScore.text = [NSString stringWithFormat:@"%d",newScore];
	NSLog(@"TODO play score sound");
}

- (void)multiplierDidChange:(int)newMultiplier
{
	playerMultiplier.text = [NSString stringWithFormat:@"%dx",newMultiplier];
	NSLog(@"TODO play puck bounce sound");
}

- (void)attemptsDidChange:(int)newAttempts
{
	playerAttempts.text = [NSString stringWithFormat:@"%d",newAttempts];
	NSLog(@"TODO play lost puck sound");
}

#pragma mark -

- (void)dealloc 
{
	[playView release];
	[pauseView release];
	[playerScore release];
	[playerMultiplier release];
	[playerAttempts release];
    [super dealloc];
}


@end
