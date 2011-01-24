    //
//  CardController.m
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import "CardController.h"
#import "GamePlayController.h"
#import "Card.h"
#import "global.h"

@implementation CardController
@synthesize _gamePlayController;
@synthesize _albumsButton;
@synthesize _singlesButton;
@synthesize _hotnessButton;
@synthesize _familiarityButton;
@synthesize _resultLabel;
@synthesize _continueButton;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithCard: (Card*)card gameId:(int)gameId{
    self = [super initWithNibName:@"CardController" bundle:nil];
    if (self) {
		_card = card;
		_gameId = gameId;
        // Custom initialization.
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[_artistNameLabel setText: [_card.name uppercaseString]];
	[_artistImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _card.image_url]]]];
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

- (IBAction) flipView:(id)sender {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: 1.0];
	
	[self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[UIView commitAnimations];
}

- (void)setActive: (BOOL)active {
	[self setActive: active username: nil];
}

- (void)setActive: (BOOL)active username:(NSString*)username {
	if( active ) {
		[_yourTurn setText: @"It's your turn"];
	} else {
		[_yourTurn setText: @"It's your opponent's turn"];
	}
	
	[_yourTurn setHidden: NO];
	[_albumsButton setEnabled:active];
	[_singlesButton setEnabled:active];
	[_hotnessButton setEnabled:active];
	[_familiarityButton setEnabled:active];
}


- (void)playTurn: (id)sender {
	NSString* statName;
	if( sender == _albumsButton ) {
		statName = @"albums";
	} else if ( sender == _singlesButton ) {
		statName = @"singles";
	} else if ( sender == _hotnessButton ) {
		statName = @"hotttnesss";
	} else if ( sender == _familiarityButton ) {
		statName = @"familiarity";
	}
	
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat: @"%s/games/%i/plays.json", SERVER_HOST, _gameId]]];
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:[[NSString stringWithFormat:@"stat=%@&username=%@&artist_id=%i", statName, _gamePlayController._username, _card.artist_id ] dataUsingEncoding: NSUTF8StringEncoding]];
	[NSURLConnection connectionWithRequest:req delegate:self];
	
	[self revealStat: statName];
}

- (void)revealStat: (NSString*)statName {
	_resultLabel.text = [NSString stringWithFormat: @"%@: %f", statName, [_card statByName: statName]];
	_resultLabel.hidden = NO;
}

- (IBAction)continueGame:(id)sender {
	[_gamePlayController continueGame];
}

@end
