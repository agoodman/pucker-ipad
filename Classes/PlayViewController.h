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

	UILabel* playerScore;
	UILabel* playerMultiplier;
	UILabel* playerAttempts;
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
	dispatch_queue_t queue;
	
}

@property (retain) IBOutlet UILabel* playerScore;
@property (retain) IBOutlet UILabel* playerMultiplier;
@property (retain) IBOutlet UILabel* playerAttempts;
@property (retain) IBOutlet PlayView* playView;
@property (retain) IBOutlet UIView* pauseView;
@property (retain) IBOutlet UIView* gameOverView;

-(void)showPause;
-(IBAction)quitGame;
-(IBAction)resumeGame;
-(IBAction)newGame;


@end
