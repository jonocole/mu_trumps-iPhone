//
//  GamePlayController.h
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardController.h"
#import "CardDeck.h"


@interface GamePlayController : UIViewController {
	CardController *_cardController;
	CardDeck *deck;
	UIView *_loadingScreen;
	NSString* _username;
	int gameId;
	
	enum {
		StateWaitForOpponent, 
		StateWaitForUser,
		StateWaitForResult
	} _currentState;
	
	NSString* _currentUser;
}

@property (readonly) int gameId;
@property (readonly) NSString* _username;

-(id) initWithDeck:(CardDeck*)deck username:(NSString*)username gameId:(int)gameId;
-(void) continueGame;

@end
