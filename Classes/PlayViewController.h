//
//  PlayViewController.h
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright 2010 Migrant Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayView.h"
#import "GameModel.h"


@interface PlayViewController : UIViewController <GameStateDelegate> {

	UILabel* playerScore;
	UILabel* playerMultiplier;
	UILabel* playerAttempts;
	PlayView* playView;
	UIView* pauseView;
	GameModel* model;
	
}

@property (retain) IBOutlet UILabel* playerScore;
@property (retain) IBOutlet UILabel* playerMultiplier;
@property (retain) IBOutlet UILabel* playerAttempts;
@property (retain) IBOutlet PlayView* playView;
@property (retain) IBOutlet UIView* pauseView;

-(void)showPause;
-(IBAction)quitGame;
-(IBAction)resumeGame;


@end
