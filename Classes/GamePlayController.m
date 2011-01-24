//
//  GamePlayController.m
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import "GamePlayController.h"
#import "PopTrumpsAppDelegate.h"
#import "global.h"


@implementation GamePlayController

@synthesize gameId;
@synthesize _username;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithDeck:(CardDeck*)inDeck username:(NSString*)username gameId:(int)inGameId {
	[super init];
	_username = [username retain];
	gameId = inGameId;
	_loadingScreen = [[[NSBundle mainBundle] loadNibNamed:@"LoadingScreen" owner:self options:nil] objectAtIndex:0];
	_currentState = StateWaitForOpponent;
	deck = inDeck;
	[deck retain];
    return self;
}

- (void) loadView {
	_cardController = [[CardController alloc] initWithCard: [deck topCard] gameId:gameId];
	_cardController._gamePlayController = self;
	[_cardController loadView];
	self.view = _loadingScreen;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[_cardController viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)startGame {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: 1.0];
	
	self.view = _cardController.view;
	[UIView commitAnimations];
}

- (void)currentUser:(NSString*)username {	
	_currentUser = [username retain];
	
	if( _currentState == StateWaitForResult ) {
		NSLog( @"Current user set to: %@. Waiting for continue", _currentUser );
		return;
	}

	NSLog( @"Current user set to: %@.", _currentUser );

	if( ![_currentUser compare: _username] ) {
		[_cardController setActive:YES];
		_cardController._resultLabel.hidden = YES;
		_cardController._albumsButton.hidden = NO;
		_cardController._singlesButton.hidden = NO;
		_cardController._hotnessButton.hidden = NO;
		_cardController._familiarityButton.hidden = NO;
		_currentState = StateWaitForUser;
	} else {
		[self startGame];
		[_cardController setActive:NO username:_currentUser];
		_currentState = StateWaitForOpponent;
	}
}

- (void)receivedPlayForUser: (NSString*)username stat:(NSString*)stat value:(NSString*)value {
	if( [username compare: _username] ) {
		NSLog( @"Received play from opponent" );
		UIButton* statButton;
		if( ![stat compare: @"hotttnesss"] ) {
			statButton = _cardController._hotnessButton;
		}
		else if( ![stat compare:@"familiarity"] ) {
			statButton = _cardController._familiarityButton;
		}
		
		_cardController._albumsButton.hidden = YES;
		_cardController._singlesButton.hidden = YES;
		_cardController._familiarityButton.hidden = YES;
		_cardController._hotnessButton.hidden = YES;
		
		statButton.hidden = NO;
		
		NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"%s/games/%i/ack.json", SERVER_HOST, gameId]]];
		[req setHTTPMethod:@"POST"];
		[req setHTTPBody:[[NSString stringWithFormat:@"username=%@", _username] dataUsingEncoding:NSUTF8StringEncoding]];
		[NSURLConnection connectionWithRequest: req delegate:self];
	}
}

- (void)winReceived {
	_cardController._resultLabel.text = @"Winner";
	_cardController._resultLabel.hidden = NO;
	_cardController._continueButton.hidden = NO;
	_currentState = StateWaitForResult;
}

- (void)loseReceived {
	_cardController._resultLabel.text = @"Loser";
	_cardController._resultLabel.hidden = NO;
	_cardController._continueButton.hidden = NO;
	_currentState = StateWaitForResult;
}

- (void)continueGame {
	_currentState = StateWaitForUser;

	CardController* oldCardController = _cardController;
	Card* topCard = [deck topCard];
	_cardController = [[CardController alloc] initWithCard:[deck topCard] gameId:gameId];
	_cardController._gamePlayController = self;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: 1.0];
	
	self.view = _cardController.view;
	[UIView commitAnimations];
	[oldCardController release];
	[self currentUser: _currentUser];
}

- (void)cardsReceived: (CardDeck*)inDeck {
	if( deck ) 
		[deck release];
	
	deck = inDeck;
	[deck retain];
}

@end
