//
//  PopTrumpsAppDelegate.h
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamePlayController.h"

@interface PopTrumpsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	GamePlayController *__gamePlayController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet GamePlayController *__gamePlayController;

-(void) createGameWithId: (int)gameId withDeck:(CardDeck*)deck andUsername:(NSString*)username;

@end

