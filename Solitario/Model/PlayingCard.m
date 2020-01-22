//
//  Card.m
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 24/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(NSArray*)suitStrings{
    return @[@"♣️", @"♦️", @"♥️", @"♠️"];
}

-(NSArray*)rankStrings{
    return @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

-(NSArray*)rankNumbers{
    return @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13];
}
@end
