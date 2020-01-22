//
//  SolitaireGame.m
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 24/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import "SolitaireGame.h"
#import "PlayingCard.h"

@interface SolitaireGame()
@property(strong, nonatomic)NSMutableArray* solvingDecks;
@property(strong, nonatomic)NSMutableArray* solvedDecks;
@property(strong, nonatomic)Deck* mainDeck;
@property(strong, nonatomic)Deck* secondaryDeck;
@property(nonatomic,strong,readwrite)Card* card;
-(void)addSolvingDeckFromSecondaryDeck;
-(BOOL)isValidToMoveCard:(Card*)card1 onTopOfSolvingCard:(Card*)card2;
@property(strong,nonatomic,readwrite)NSString* status;
@end

@implementation SolitaireGame

-(instancetype)init{
    return self = [self initWithCard:[PlayingCard new]];
}

-(NSUInteger)numberOfSolvingDecks{
    return self.solvingDecks.count;
}

//Designated initializer
-(instancetype)initWithCard:(Card *)card{
    self = [super init];
    if(self){
        self.card = card;
        self.mainDeck = [[Deck alloc] initFullDeckWithCard:card];
        self.secondaryDeck = [[Deck alloc] init];
        [self.mainDeck suffle];
        self.solvingDecks = [NSMutableArray new];
        for(int i = 0; i < 7; i++){
            [self.solvingDecks addObject:[[Deck alloc] init]];
            for(int j = 0; j < i; j++){
                Card* otherCard = [self.mainDeck removeFirstCard];
                [self.solvingDecks[i] addCard:otherCard];
            }
            Card* otherCard = [self.mainDeck removeFirstCard];
            if(!otherCard.isFlipped){
                [otherCard flip];
            }
            [self.solvingDecks[i] addCard:otherCard];
        }
        self.solvedDecks = [NSMutableArray new];
        for(int i = 0; i < [self.card suitStrings].count; i++){
            [self.solvedDecks addObject:[[Deck alloc]init]];
        }
    }
    return self;
}

-(BOOL)isValidToMoveCard:(Card *)card1 onTopOfSolvingCard:(Card *)card2{
    if(!card2)
        return true;
    return card1.suit != card2.suit && (NSInteger)[[self.card rankNumbers] indexOfObject:card1.rank] == (NSInteger)[[self.card rankNumbers] indexOfObject:card2.rank] - 1;
}

-(BOOL)isValidToMoveCard:(Card*)card1 onTopOfSolvedCard:(Card*)card2{
    return card1.suit == card2.suit && [[self.card rankNumbers] indexOfObject:card1.rank] == [[self.card rankNumbers] indexOfObject:card2.rank] + 1;
}

@synthesize card=_card;

-(Card*)card{
    if(!_card) _card = [PlayingCard new];
    return _card;
}

-(void)setCard:(Card *)card{
    if(card){
        _card = card;
    }
}

-(Deck*) getSolvingDeck:(NSUInteger)index{
    Deck* deck = nil;
    if(index < self.solvingDecks.count){
        deck = self.solvingDecks[index];
    }
    return deck;
}

-(Card*)getFirstCardFromMainDeck{
    return [self.mainDeck firstCard];
}

-(Card*)getFirstCardFromSecondaryDeck{
    return [self.secondaryDeck firstCard];
}

-(Card*)getFirstCardFromSolvedDeck:(NSUInteger)index{
    Card* card = nil;
    if(index < [self.card suitStrings].count){
        card = [self.solvedDecks[index] firstCard];
    }
    return card;
}

-(void)moveCardsFromSolvingDeck:(NSUInteger)solvingDeckIndex1 toSolvingDeck:(NSUInteger)solvingDeckIndex2 startingFromCard:(NSUInteger)startingCardIndex{
    if(solvingDeckIndex1 < self.solvingDecks.count && solvingDeckIndex2 < self.solvingDecks.count && startingCardIndex < [self.solvingDecks[solvingDeckIndex1] numberOfCards] && solvingDeckIndex1 != solvingDeckIndex2 && [self isValidToMoveCard:[self.solvingDecks[solvingDeckIndex1] cardAtIndex:startingCardIndex] onTopOfSolvingCard:[self.solvingDecks[solvingDeckIndex2] firstCard]] && [self.solvingDecks[solvingDeckIndex1] cardAtIndex:startingCardIndex].isFlipped){
            for(NSUInteger i = startingCardIndex; ; i--){
                Card* card = [self.solvingDecks[solvingDeckIndex1] removeCardAtIndex:i];
                [self.solvingDecks[solvingDeckIndex2] addCard:card];
                [card drop];
                if(!i){
                    break;
                }
            }
            
            Card* card = [self.solvingDecks[solvingDeckIndex1] firstCard];
            if(!card){
                [self.solvingDecks removeObjectAtIndex:solvingDeckIndex1];
            }
            else if(card && !card.isFlipped){
                [card flip];
            }
    }else if([self.solvingDecks[solvingDeckIndex1] cardAtIndex:startingCardIndex].rank == [[self.card rankNumbers] lastObject] && self.solvingDecks.count < 7){
            [self.solvingDecks addObject:[[Deck alloc] init]];
            [self moveCardsFromSolvingDeck:solvingDeckIndex1 toSolvingDeck:self.solvingDecks.count - 1 startingFromCard:startingCardIndex];
    }
}

@synthesize status = _status;

-(NSString*) status{
    if(!_status) _status = @"";
    return _status;
}

-(void)getCardFromMainDeck{
    Card* card = [self.mainDeck removeFirstCard];
    if(card){
        if(!card.isFlipped){
            [card flip];
        }
        [self.secondaryDeck addCard:card];
    }else{
        while(self.secondaryDeck.numberOfCards){
            Card* otherCard = [self.secondaryDeck removeFirstCard];
            if(otherCard.isFlipped){
                [otherCard flip];
            }
            [self.mainDeck addCard:otherCard];
        }
    }
}

-(void)moveCardFromSecondaryDeckToSolvedDeck:(NSUInteger)solvedDeckIndex{
    if(solvedDeckIndex < [self.card suitStrings].count){
        Card* card = [self.secondaryDeck removeFirstCard];
        if(card){
            if([self.solvedDecks[solvedDeckIndex] firstCard]){
                if([self isValidToMoveCard:card onTopOfSolvedCard:[self.solvedDecks[solvedDeckIndex] firstCard]]){
                    [self.solvedDecks[solvedDeckIndex] addCard:card];
                }else{
                    [self.secondaryDeck addCard:card];
                }
            }else{
                if([card.rank isEqualToNumber:[[card rankNumbers] firstObject]]){
                    [self.solvedDecks[solvedDeckIndex] addCard:card];
                }else{
                    [self.secondaryDeck addCard:card];
                }
                
            }
            [card drop];
            if(!self.mainDeck.numberOfCards && !self.secondaryDeck.numberOfCards && !self.solvingDecks.count){
                self.status = @"You Won!";
            }
        }
    }
}

-(void)moveCardFromSolvingDeck:(NSUInteger)solvingDeckIndex toSolvedDeck:(NSUInteger)solvedDeckIndex{
    if(solvingDeckIndex < 7 && solvedDeckIndex < [self.card suitStrings].count){
        Card* card = [[self.solvingDecks objectAtIndex:solvingDeckIndex] removeFirstCard];
        if(card && card.isFlipped){
            if([self.solvedDecks[solvedDeckIndex] firstCard]){
                if([self isValidToMoveCard:card onTopOfSolvedCard:[self.solvedDecks[solvedDeckIndex] firstCard] ]){
                    [self.solvedDecks[solvedDeckIndex] addCard:card];
                }else{
                    [self.solvingDecks[solvingDeckIndex] addCard:card];
                }
            }else{
                if([card.rank isEqualToNumber:[[card rankNumbers] firstObject]]){
                    [self.solvedDecks[solvedDeckIndex] addCard:card];
                }else{
                    [self.solvingDecks[solvingDeckIndex] addCard:card];
                }
            }
            [card drop];
            if(![self.solvingDecks[solvingDeckIndex] firstCard]){
                [self.solvingDecks removeObjectAtIndex:solvingDeckIndex];
            }else if(![self.solvingDecks[solvingDeckIndex] firstCard].isFlipped){
                [[self.solvingDecks[solvingDeckIndex] firstCard] flip];
            }
            
            if(!self.mainDeck.numberOfCards && !self.secondaryDeck.numberOfCards && !self.solvingDecks.count){
                self.status = @"You Won!";
            }
        }
    }
}

-(void)moveCardFromSecondaryDeckToSolvingDeck:(NSUInteger)solvingDeckIndex{
    if(solvingDeckIndex < self.solvingDecks.count){
        if([self.secondaryDeck firstCard] && [self.secondaryDeck firstCard].isChosen){
            if([self.secondaryDeck firstCard].rank == [[self.card rankNumbers] lastObject]){
                if(self.solvingDecks.count < 7){
                    [self addSolvingDeckFromSecondaryDeck];
                }else{
                    [[self.secondaryDeck firstCard] drop];
                }
            }else{
                Card* card = [self.secondaryDeck removeFirstCard];
                if([self isValidToMoveCard:card onTopOfSolvingCard:[self.solvingDecks[solvingDeckIndex] firstCard]]){
                    [self.solvingDecks[solvingDeckIndex] addCard:card];
                }else{
                    [self.secondaryDeck addCard:card];
                }
                [card drop];
            }
        }
    }
}

-(void)addSolvingDeckFromSecondaryDeck{
    if([self.secondaryDeck firstCard] && [self.secondaryDeck firstCard].rank == [[self.card rankNumbers] lastObject]){
        Deck* deck = [[Deck alloc] init];
        Card* card = [self.secondaryDeck removeFirstCard];
        [card drop];
        [deck addCard:card];
        [self.solvingDecks addObject:deck];
    }
}

@end
