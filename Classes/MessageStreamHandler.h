//
//  MessageStreamHandler.h
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageStreamHandler : NSObject {
	NSString* _username;
	id delegate;
}

@property (retain, readwrite) id delegate;

-(MessageStreamHandler*) initWithUsername:(NSString*)username;

@end
