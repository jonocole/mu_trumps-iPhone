//
//  CardDeck.h
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"


@interface CardDeck : NSObject {
	NSMutableArray* cards;
	NSString* username;
}

@property (retain, readonly) NSArray* cards;
@property (retain, readonly) NSString* username;

-(CardDeck*) initFromArray: (NSArray*)array username:(NSString*)username;
-(Card*) topCard;

@end
