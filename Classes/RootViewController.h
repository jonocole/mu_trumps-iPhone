//
//  RootViewController.h
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
	IBOutlet UITextField* _usernameField;
	IBOutlet UITextField* _serverLabel;
	NSMutableString* _responseString;
}

-(IBAction) joinGame:(id)sender;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

@end
