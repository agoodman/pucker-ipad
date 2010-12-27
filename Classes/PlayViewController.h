//
//  PlayViewController.h
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "PlayView.h"
#import "GameModel.h"


@interface PlayViewController : UIViewController <GameStateDelegate> {

	UILabel* playerScoreLabel;
	UILabel* playerMultiplierLabel;
	UILabel* playerAttemptsLabel;
	PlayView* playView;
	UIView* pauseView;
	UIView* gameOverView;
	GameModel* model;
	SystemSoundID multiplierSound;
	SystemSoundID attemptSound;
	SystemSoundID wallSound;
	SystemSoundID scoreSound;
	SystemSoundID buzzerSound;
	SystemSoundID turnSound;
	SystemSoundID launchSound;
	dispatch_queue_t queue;
	
}

@property (retain) IBOutlet UILabel* playerScoreLabel;
@property (retain) IBOutlet UILabel* playerMultiplierLabel;
@property (retain) IBOutlet UILabel* playerAttemptsLabel;
@property (retain) IBOutlet PlayView* playView;
@property (retain) IBOutlet UIView* pauseView;
@property (retain) IBOutlet UIView* gameOverView;

-(void)pauseGame;
-(IBAction)quitGame;
-(IBAction)resumeGame;
-(IBAction)newGame;


@end
