//
//  Card.h
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 25/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property(nonatomic,getter=isChosen,readonly)BOOL chosen;
@property(nonatomic,getter=isMatched,readonly)BOOL matched;
@property(nonatomic,getter=isFlipped,readonly)BOOL flipped;
@property(nonatomic,strong)NSString*suit;
@property(nonatomic,strong)NSNumber*rank;
-(void)flip;
-(void)choose;
-(void)drop;
-(NSInteger)match:(NSArray*)cards;
-(NSArray*)suitStrings;
-(NSArray*)rankNumbers;
-(NSArray*)rankStrings;
@end
