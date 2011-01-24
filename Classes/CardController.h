//
//  CardController.h
//  PopTrumps
//
//  Created by Jono Cole on 23/01/2011.
//  Copyright 2011 Last.fm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Card;
@class GamePlayController;

@interface CardController : UIViewController {
	IBOutlet UIView *_frontView;
	IBOutlet UIView *_detailView;
	IBOutlet UILabel *_artistNameLabel;
	IBOutlet UIImageView *_artistImage;
	IBOutlet UIImageView *_artistOverlay;
	IBOutlet UILabel *_yourTurn;
	
	IBOutlet UIButton *_singlesButton;
	IBOutlet UIButton *_albumsButton;
	IBOutlet UIButton *_hotnessButton;
	IBOutlet UIButton *_familiarityButton;
	
	IBOutlet UILabel *_resultLabel;
	IBOutlet UIButton *_continueButton;
	
	GamePlayController* _gamePlayController;
	Card* _card;
	int _gameId;
}

@property (assign, readwrite) GamePlayController* _gamePlayController;
@property (assign, readonly) UIButton* _singlesButton;
@property (assign, readonly) UIButton* _albumsButton;
@property (assign, readonly) UIButton* _hotnessButton;
@property (assign, readonly) UIButton* _familiarityButton;
@property (assign, readwrite) UILabel* _resultLabel;
@property (assign, readwrite) UIButton* _continueButton;

-(id) initWithCard:(Card*)card gameId:(int)gameId;
-(IBAction) flipView:(id)sender;
-(IBAction) continueGame:(id)sender;
-(void) setActive:(BOOL)active;
-(void) setActive:(BOOL)active username:(NSString*)username;
-(void) playTurn:(id)sender;

@end
