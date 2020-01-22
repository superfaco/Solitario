//
//  Deck.h
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 24/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject{
    @protected
    NSMutableArray* _cards;
}
-(void)addCard:(Card*)card atTop:(BOOL)atTop;
-(void)addCard:(Card*)card;
-(void)insertCard:(Card*)card atIndex:(NSUInteger)index;
-(Card*)removeCardAtIndex:(NSUInteger)index;
-(Card*)removeFirstCard;
-(Card*)removeLastCard;
-(Card*)removeCard:(Card*)card;
-(Card*)firstCard;
-(Card*)lastCard;
-(Card*)cardAtIndex:(NSUInteger)index;
-(void)swapCardsAtIndex:(NSUInteger)index1 andIndex:(NSUInteger)index2;
-(void)suffle;
-(instancetype)initFullDeckWithCard:(Card*)card;
@property(nonatomic,readonly)NSUInteger numberOfCards;
@end
