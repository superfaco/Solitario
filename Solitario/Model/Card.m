//
//  Card.m
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 25/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import "Card.h"

@interface Card()
@property(nonatomic,getter=isChosen,readwrite)BOOL chosen;
@property(nonatomic,getter=isMatched,readwrite)BOOL matched;
@property(nonatomic,getter=isFlipped,readwrite)BOOL flipped;
@end

@implementation Card

@synthesize suit=_suit;
@synthesize rank=_rank;

-(void)flip{
    if(self.isFlipped){
        self.flipped = NO;
    }else{
        self.flipped = YES;
    }
}

-(void)choose{
    self.chosen = YES;
}

-(void)drop{
    self.chosen = NO;
}

-(NSInteger)match:(NSArray *)cards{
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)] userInfo:nil];
}

-(NSArray*)suitStrings{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)] userInfo:nil];
}

-(NSArray*)rankNumbers{
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)] userInfo:nil];
}

-(NSArray*)rankStrings{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass",NSStringFromSelector(_cmd)] userInfo:nil];
}

-(NSString*)suit{
    if(!_suit) _suit = [[self suitStrings] firstObject];
    return _suit;
}

-(void)setSuit:(NSString *)suit{
    if([[self suitStrings] containsObject:suit]){
        _suit = suit;
    }
}

-(NSNumber*)rank{
    if(!_rank) _rank = [[self rankNumbers] firstObject];
    return _rank;
}

-(void)setRank:(NSNumber *)rank{
    if([[self rankNumbers] containsObject:rank]){
        _rank = rank;
    }
}

-(NSString*) description{
    NSUInteger rankIndex = [[self rankNumbers] indexOfObject:self.rank];
    return [[self rankStrings][rankIndex] stringByAppendingString:self.suit];
}

@end
