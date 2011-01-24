//
//  RootViewController.m
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import "RootViewController.h"
#import "PopTrumpsAppDelegate.h"
#import "JSON.h"
#import "CardDeck.h"
#import "global.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.navigationItem.title = @"Login To Pop Trumps";
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) joinGame:(id)sender {
	_responseString = [[NSMutableString alloc] init];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"%s/games.json", SERVER_HOST]]];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: [[NSString stringWithFormat:@"username=%@", _usernameField.text] dataUsingEncoding:NSUTF8StringEncoding]];
	[NSURLConnection connectionWithRequest:request delegate:self];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[_responseString appendString: str];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSDictionary* dict = [_responseString JSONValue];
	
	int gameId = [[dict objectForKey: @"id"] intValue];
	
	NSArray* cards = [dict objectForKey: @"cards"];
	if( cards &&
	    [cards isKindOfClass: [NSArray class]])
	{
		CardDeck* deck = [[CardDeck alloc] initFromArray: cards username:_usernameField.text];
		[((PopTrumpsAppDelegate*)[UIApplication sharedApplication].delegate) createGameWithId:gameId withDeck:deck andUsername: _usernameField.text];
		[deck autorelease];
		return;
		
	};
	NSLog( @"Error - could not pass the join game response");
}


@end

