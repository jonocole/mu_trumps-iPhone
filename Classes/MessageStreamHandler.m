//
//  MessageStreamHandler.m
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import "MessageStreamHandler.h"
#import "JSON.h"
#import "global.h"
#import "CardDeck.h";

@implementation MessageStreamHandler
@synthesize delegate;

-(MessageStreamHandler*) initWithUsername:(NSString *)username {
	[super init];
	_username = [username retain];
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%s/messaging/%@", SERVER_HOST, _username]]];
	[NSURLConnection connectionWithRequest:req delegate:self];
	return self;
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString* strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSLog( @"Received Data: %@", strData );
	if( !strData ) return;
	NSArray* messages = [strData JSONValue];
	
	if( ![messages count] )
		return;
	
	for( NSDictionary* dict in messages ) {
		NSString* event = [dict objectForKey:@"event"];
		if( event ) {
			if( delegate ) {
				if( ![event compare: @"start"] ) {
					[delegate startGame];
				}
				if( ![event compare: @"current_user"] ) {
					NSString* username = [dict objectForKey:@"username"];
					NSLog( @"current_user %@", username );
					[delegate currentUser:username];
				}
				if( ![event compare: @"play" ] ) {
					NSString* username = [dict objectForKey: @"username"];
					NSString* stat = [dict objectForKey: @"stat"];
					NSString* value = [dict objectForKey: @"value"];
					[delegate receivedPlayForUser: username stat:stat value:value];
				}
				if( ![event compare: @"result" ] ) {
					NSString* result = [dict objectForKey: @"result"];
					if( ![result compare: @"win"] ) {
						NSLog( @"Winner!" );
						[delegate winReceived];
					} else if ( ![result compare: @"lose" ] ) {
						NSLog( @"Loser!" );
						[delegate loseReceived];
					}
				}
				
				if( ![event compare: @"cards" ] ) {
					[delegate cardsReceived:[[CardDeck alloc] initFromArray:[dict objectForKey:@"cards"] username:_username ]];
				}
			}
		}
	}
	[strData release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
	//continuously poll for data
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%s/messaging/%@", SERVER_HOST, _username]]];
	[NSURLConnection connectionWithRequest:req delegate:self];
}

@end
