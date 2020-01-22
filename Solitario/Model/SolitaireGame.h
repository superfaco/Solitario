//
//  SolitaireGame.h
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 24/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface SolitaireGame : NSObject

@property(nonatomic,strong,readonly)Card* card;
@property(nonatomic,readonly) NSUInteger numberOfSolvingDecks;
@property(nonatomic,strong,readonly)NSString* status;

-(Deck*)getSolvingDeck:(NSUInteger)index;
-(Card*)getFirstCardFromMainDeck;
-(Card*)getFirstCardFromSecondaryDeck;
-(Card*)getFirstCardFromSolvedDeck:(NSUInteger)index;
-(void)moveCardsFromSolvingDeck:(NSUInteger)deckIndex1 toSolvingDeck:(NSUInteger)deckIndex2 startingFromCard:(NSUInteger)cardIndex;
-(void)getCardFromMainDeck;
-(void)moveCardFromSecondaryDeckToSolvedDeck:(NSUInteger)solvedDeckIndex;
-(void)moveCardFromSecondaryDeckToSolvingDeck:(NSUInteger)solvingDeckIndex;
-(void)moveCardFromSolvingDeck:(NSUInteger)solvingDeckIndex toSolvedDeck:(NSUInteger)solvedDeckIndex;
//Designated initializer
-(instancetype)initWithCard:(Card*)card;

@end
