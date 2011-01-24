//
//  Card.m
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import "Card.h"
#import "global.h"
#import "JSON.h"

@implementation Card

@synthesize name;
@synthesize image_url;
@synthesize artist_id;

-(id) initFromDictionary:(NSDictionary*)json {
	[super init];
	name = [[json objectForKey: @"name"] retain];
	image_url = [[json objectForKey: @"image"] retain];
	artist_id = [[json objectForKey:@"id"] intValue];
//	for( NSString* string in [json keyEnumerator]) {
//		NSLog( @"%@ = %@", string, [json objectForKey:string]);
//	}
//	NSLog( @"Creating card for artist: %@", name );
	
	NSString* artistInfo = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"%s/artists/%i.json", SERVER_HOST, artist_id]] encoding:NSUTF8StringEncoding error: NULL];
	NSDictionary* info = [artistInfo JSONValue];
	
	NSDictionary* stats = [info objectForKey:@"stats"];
	
	_albumsStat = [(NSString*)[stats objectForKey:@"albums"] floatValue];
	_singlesStat = [(NSString*)[stats objectForKey: @"singles"] floatValue];
	_hotnessStat = [(NSString*)[stats objectForKey: @"hotttnesss"] floatValue];
	_familiarityStat = [(NSString*)[stats objectForKey: @"familiarity"] floatValue];
	
	return self;
}

- (float)statByName: (NSString*)statName {
	if( ![statName compare:@"hotttnesss"] ) {
		return _hotnessStat;
	}
    if( ![statName compare:@"singles"] ) {
	    return _singlesStat;
    }
    if( ![statName compare:@"albums"] ) {
	    return _albumsStat;
    }
    if( ![statName compare:@"familiarity"] ) {
	    return _familiarityStat;
    }
	return 0;
}

@end
