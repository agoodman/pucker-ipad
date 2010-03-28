//
//  PuckerAppDelegate.h
//  Pucker
//
//  Created by Aubrey Goodman on 3/20/10.
//  Copyright Migrant Studios 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PuckerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UITabBarController* tabBarController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (retain) IBOutlet UITabBarController* tabBarController;

@end
