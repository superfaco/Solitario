//
//  Deck.m
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 24/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray* cards;
@end

@implementation Deck

@synthesize cards=_cards;

-(NSUInteger)numberOfCards{
    return self.cards.count;
}

-(instancetype)initFullDeckWithCard:(Card *)card{
    self = [self init];
    if(self){
        for(NSString* suit in [card suitStrings]){
            for(NSNumber* rank in [card rankNumbers]){
                Card* otherCard = [[card class] new];
                otherCard.suit = suit;
                otherCard.rank = rank;
                [self addCard:otherCard];
            }
        }
    }
    return self;
}

//Designated initializer
-(instancetype) init{
    self = [super init];
    if(self){
        self.cards = [NSMutableArray new];
    }
    return self;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop{
    if(atTop){
        [self.cards insertObject:card atIndex:0];
    }else{
        [self.cards addObject:card];
    }
}

-(void)addCard:(Card *)card{
    [self addCard:card atTop:YES];
}

-(void)insertCard:(Card *)card atIndex:(NSUInteger)index{
    if(self.cards.count && index <= self.cards.count){
        [self.cards insertObject:card atIndex:index];
    }
}

-(Card*)removeCardAtIndex:(NSUInteger)index{
    Card* card = nil;
    if(self.cards.count && index < self.cards.count){
        card = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return card;
}

-(Card*)removeFirstCard{
    Card* card = nil;
    if(self.cards.count){
        card = [self.cards firstObject];
        [self.cards removeObjectAtIndex:0];
    }
    return card;
}

-(Card*)removeLastCard{
    Card* card = nil;
    if(self.cards.count){
        card = [self.cards lastObject];
        [self.cards removeLastObject];
    }
    return card;
}

-(Card*)removeCard:(Card *)card{
    Card* otherCard = nil;
    if(self.cards.count && card){
        NSUInteger cardIndex = [self.cards indexOfObject:card];
        otherCard = [self.cards objectAtIndex:cardIndex];
        [self.cards removeObject:card];
    }
    return otherCard;
}

-(Card*)firstCard{
    Card* card = nil;
    if(self.cards.count){
        card = [self.cards firstObject];
    }
    return card;
}

-(Card*)lastCard{
    Card* card = nil;
    if(self.cards.count){
        card = [self.cards lastObject];
    }
    return card;
}

-(Card*)cardAtIndex:(NSUInteger)index{
    Card* card = nil;
    if(self.cards.count && index < self.cards.count){
        card = self.cards[index];
    }
    return card;
}

-(void)suffle{
    for(NSUInteger i = 0; i < self.cards.count; i++){
        NSUInteger index1, index2;
        index1 = arc4random() % self.cards.count;
        do{
            index2 = arc4random() % self.cards.count;
        }while(index2 == index1);
        [self swapCardsAtIndex:index1 andIndex:index2];
    }
}

-(void)swapCardsAtIndex:(NSUInteger)index1 andIndex:(NSUInteger)index2{
    Card* card = self.cards[index1];
    self.cards[index1] = self.cards[index2];
    self.cards[index2] = card;
}
@end
