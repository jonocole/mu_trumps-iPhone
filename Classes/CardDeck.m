//
//  CardDeck.m
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import "CardDeck.h"
#import "Card.h"

@implementation CardDeck

@synthesize cards;
@synthesize username;

-(CardDeck*) initFromArray: (NSArray*)array username: (NSString*)inUsername {
	[super init];
	cards = [NSMutableArray array];
	[cards retain];
	username = [inUsername retain];
	for( NSDictionary* card in array ) {
		[cards addObject: [[Card alloc] initFromDictionary:card]];
	}
	return self;
}

-(Card*) topCard {
	return [cards objectAtIndex:0];
}

@end
