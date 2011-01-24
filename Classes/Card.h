//
//  Card.h
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Card : NSObject {
	NSString* name;
	NSString* image_url;
	int artist_id;
	
	float _albumsStat;
	float _singlesStat;
	float _hotnessStat;
	float _familiarityStat;
}

@property (retain, readonly) NSString* name;
@property (retain, readonly) NSString* image_url;
@property (readonly) int artist_id;

-(id) initFromDictionary:(NSDictionary*)json;
-(float) statByName: (NSString*)statName;
@end
