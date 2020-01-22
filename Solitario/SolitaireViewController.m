//
//  ViewController.m
//  Solitario
//
//  Created by Fernando Alfonso Caldera Olivas on 24/04/19.
//  Copyright © 2019 Fernando Alfonso Caldera Olivas. All rights reserved.
//

#import "SolitaireViewController.h"
#import "Model/SolitaireGame.h"
#import "DeckButton.h"

@interface SolitaireViewController ()
@property (strong, nonatomic) NSMutableArray* solvingDecksButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *solvedDecksButtons;
@property (weak, nonatomic) IBOutlet UIButton *mainDeckButton;
@property (weak, nonatomic) IBOutlet UIButton *secondaryDeckButton;
@property (strong,nonatomic)SolitaireGame* game;
@property (weak, nonatomic) IBOutlet UILabel *lblWin;

@end

@implementation SolitaireViewController

static int topMargin;
static int bottomMargin;
static int leftMargin;
static int rightMargin;
static int cardWidth;
static int cardHeight;
static int spaceSize;

-(void)viewDidLoad{
    [super awakeFromNib];
    [super viewDidLoad];
    self.game = [[SolitaireGame alloc] init];
    
    if(self.solvingDecksButtons){
        for(NSMutableArray* array in self.solvingDecksButtons){
            for(DeckButton* deckButton in array){
                [deckButton removeFromSuperview];
            }
        }
    }
    
    self.solvingDecksButtons = [NSMutableArray new];
    
    CGRect viewRect = [self.view bounds];
    topMargin = bottomMargin = viewRect.size.height / 100 * 5;
    leftMargin = rightMargin = viewRect.size.width / 100 * 5;
    [self updateUI];
}

-(void)updateUI{
    
    CGRect viewRect = [self.view bounds];
    if(self.game.numberOfSolvingDecks == 0){
        cardWidth = 1;
        cardHeight = 1;
        spaceSize = 1;
    }else{
        cardWidth = ((viewRect.size.width - leftMargin - rightMargin) - viewRect.size.width * 1 / 100 * (self.game.numberOfSolvingDecks - 1)) / self.game.numberOfSolvingDecks;
        
        NSUInteger maxCardsInPlayingDeck = 0;
        for(NSInteger i = 0; i < self.game.numberOfSolvingDecks; i++){
            if([self.game getSolvingDeck:i].numberOfCards > maxCardsInPlayingDeck){
                maxCardsInPlayingDeck = [self.game getSolvingDeck:i].numberOfCards;
            }
        }
        
        cardHeight = 448 / maxCardsInPlayingDeck;
        
        spaceSize = ((viewRect.size.width - leftMargin - rightMargin) - cardWidth * self.game.numberOfSolvingDecks) / (self.game.numberOfSolvingDecks - 1);
    }
    
    [self updateDeckButton:self.mainDeckButton withCard:[self.game getFirstCardFromMainDeck]];
    [self updateDeckButton:self.secondaryDeckButton withCard:[self.game getFirstCardFromSecondaryDeck]];
    
    for(NSMutableArray* array in self.solvingDecksButtons){
        for(DeckButton* deckButton in array){
            [deckButton removeFromSuperview];
        }
    }
    [self.solvingDecksButtons removeAllObjects];
    
    for(NSUInteger i = 0, x = viewRect.origin.x + leftMargin; i < self.game.numberOfSolvingDecks; i++, x += cardWidth + spaceSize){
        [self.solvingDecksButtons addObject:[NSMutableArray new]];
        for(NSUInteger j = [self.game getSolvingDeck:i].numberOfCards? [self.game getSolvingDeck:i].numberOfCards - 1 : 0, y = viewRect.origin.y + topMargin; ; j--, y += cardHeight * 2 / 3){
            DeckButton* solvingDeckButton = [DeckButton buttonWithType:UIButtonTypeRoundedRect];
            [solvingDeckButton setFrame:CGRectMake(x, y, cardWidth, cardHeight)];
            [self updateDeckButton:solvingDeckButton withCard:[[self.game getSolvingDeck:i] cardAtIndex:j]];
            solvingDeckButton.cardIndex = j;
            solvingDeckButton.deckIndex = i;
            [solvingDeckButton addTarget:self action:@selector(solvingDecksButtonsTouchDown:) forControlEvents:UIControlEventTouchDown];
            [solvingDeckButton addTarget:self action:@selector(solvingDecksButtonsTouchUpOutside:forEvent:) forControlEvents:UIControlEventTouchUpOutside];
            [solvingDeckButton addTarget:self action:@selector(solvingDecksButtonsTouchUpInside:forEvent:) forControlEvents:UIControlEventTouchUpInside];
            [self.solvingDecksButtons[i] addObject:solvingDeckButton];
            [self.view addSubview:solvingDeckButton];
            if(!j){
                break;
            }
        }
    }
    
    NSUInteger i = 0;
    for(UIButton* deckButton in self.solvedDecksButtons){
        [self updateDeckButton:deckButton withCard:[self.game getFirstCardFromSolvedDeck:i]];
        i++;
    }
    
    self.lblWin.text = self.game.status;
    [self.view setNeedsLayout];
}

-(IBAction)solvingDecksButtonsTouchUpInside:(DeckButton*)sender forEvent:(UIEvent*)event{
    [self solvingDecksButtonsTouchUpOutside:sender forEvent:event];
}

-(IBAction)solvingDecksButtonsTouchUpOutside:(DeckButton*)sender forEvent:(UIEvent*)event{
    //In here, we're gonna try to figure out what deck the user intended to drop the cards (that is, from one solving deck to another).
    //Let's first check the point of the last touch event that ocurred.
    CGPoint touchLocation = [[[event touchesForView:sender] anyObject] locationInView:sender.superview];
    
    //then, we're gonna iterate throught all the solvingDeckButtons to find out
    //the target deck (which must be different from the sender, but the model validates that..)
    
    //Let's create a variable to store the minimum distance and another one for storing the index of the deck i which the minimum distance was found..
    
    //We initialize it at infinite..
    NSInteger minDistanceBetweenSolvingDecks = NSIntegerMax;
    
    //We initialize it at -1
    NSInteger indexOfSolvingDeckWithMinDistance = -1;
    
    //We create another variable to count the index of the deck..
    NSInteger indexOfDeck = 0;
    
    for(NSMutableArray* array in self.solvingDecksButtons){
        for(DeckButton* deckButton in array){
            //So let's get the minimum distance..
            //First, let's get the center of the deck
            CGPoint playingDeckButtonCenter = [deckButton center];
            
            //Now, let's get the distance between the location of the touch and the center of the deck..
            NSInteger distance = sqrt(pow(touchLocation.x - playingDeckButtonCenter.x, 2) + pow(touchLocation.y - playingDeckButtonCenter.y, 2));
            
            //Now, let's see if this distance is smaller than the min distance..
            if(distance < minDistanceBetweenSolvingDecks){
                //We save the current distance as the min distance and
                //the index of the current deck..
                minDistanceBetweenSolvingDecks = distance;
                indexOfSolvingDeckWithMinDistance = indexOfDeck;
            }
        }
        indexOfDeck++;
    }
    
    //Now, we're gonna get the min distance from the touch location(which is from one solving deck) to the solved decks..
    
    //So let's create a variable to hold the current min distance between the touch and the solved deck buttons and intialize it to infinite..
    NSInteger minDistanceBetweenTouchAndSolvedDecks = NSIntegerMax;
    
    //And a variable to hold the index of the solved deck with the minimum distance.. we initialize it to -1..
    NSInteger indexOfSolvedDeckWithMinDistance = -1;
    
    //And we reset the index of deck to 0
    indexOfDeck = 0;
    
    for(UIButton* solvedDeckButton in self.solvedDecksButtons){
        //Let's get the center point of the deck..
        CGPoint centerOfSolvedDeck = [solvedDeckButton center];
        
        //Let's calculate the distance between the touch and the center of deck..
        NSInteger distance = sqrt(pow(touchLocation.x - centerOfSolvedDeck.x, 2) + pow(touchLocation.y - centerOfSolvedDeck.y, 2));
        
        //Let's see if this distance is smaller than our min distance..
        if(distance < minDistanceBetweenTouchAndSolvedDecks){
            //We store the value and the index of the deck..
            minDistanceBetweenTouchAndSolvedDecks = distance;
            indexOfSolvedDeckWithMinDistance = indexOfDeck;
        }
        
        indexOfDeck++;
    }
    
    //After that, we just call what ever method is apropiate.. to move from 1 solving deck to another or to move from solving deck to solved deck..
    if(minDistanceBetweenSolvingDecks < minDistanceBetweenTouchAndSolvedDecks){
        [self.game moveCardsFromSolvingDeck:sender.deckIndex toSolvingDeck:indexOfSolvingDeckWithMinDistance startingFromCard:sender.cardIndex];
    }else{
        [self.game moveCardFromSolvingDeck:sender.deckIndex toSolvedDeck:indexOfSolvedDeckWithMinDistance];
    }
    [self updateUI];
}

- (IBAction)btnResetTouchUpInside:(UIButton *)sender {
    [self viewDidLoad];
}

-(IBAction)solvingDecksButtonsTouchDown:(DeckButton*)sender{
    if(sender.deckIndex < self.game.numberOfSolvingDecks && sender.cardIndex < [[self.game getSolvingDeck:sender.deckIndex] numberOfCards] && [[self.game getSolvingDeck:sender.deckIndex] cardAtIndex:sender.cardIndex]){
        for(NSUInteger i = sender.cardIndex; ;i--){
            [[[self.game getSolvingDeck:sender.deckIndex] cardAtIndex:i] choose];
            if(!i){
                break;
            }
        }
    }
}

-(void)updateDeckButton:(UIButton*)deckButton withCard:(Card*)card{
    if(card){
        [deckButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[deckButton titleLabel] setFont:[UIFont systemFontOfSize:13]];
        if(card.isFlipped){
            [deckButton setTitle:[card description] forState:UIControlStateNormal];
            [deckButton setBackgroundImage:[UIImage imageNamed:@"cardfront"] forState:UIControlStateNormal];
        }else{
            [deckButton setTitle:@"" forState:UIControlStateNormal];
            [deckButton setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
        }
    }else{
        [deckButton setTitle:@"" forState:UIControlStateNormal];
        [deckButton setBackgroundImage: nil forState:UIControlStateNormal];
        [deckButton setBackgroundColor:[UIColor whiteColor]];
    }
}

- (IBAction)mainDeckButtonTouchUpInside:(UIButton *)sender {
    [self.game getCardFromMainDeck];
    [self updateUI];
}
- (IBAction)secondaryDeckButtonTouchUpOutside:(UIButton *)sender forEvent:(UIEvent *)event {
    //First, we get the location of the touch
    NSSet* touchesSet = [event touchesForView:sender];
    UITouch* touch = [touchesSet anyObject];
    CGPoint touchLocation = [touch locationInView:sender.superview];
    
    //Then, lets find out what deck the user wanted to drop the
    //card...
    //First, we get the minimum distance between touch location
    //and the solved decks
    
    //Let's initialize the minimum distance to inf.
    NSInteger minDistanceOfSolvedDecks = NSIntegerMax;
    //And the index of the solved deck to -1;
    NSInteger indexOfSolvedDeck = -1;
    //Let's make a variable to count the index of the current
    //solved deck
    NSInteger index = 0;
    for(UIButton* solvedDeckButton in self.solvedDecksButtons){
        //Let's get the center of each deck
        CGPoint centerOfDeck = [solvedDeckButton center];
        //Then, let's calculate the pitagorean distance
        //between the secondary deck and the current solved
        //deck...
        NSInteger distance = sqrt(pow(touchLocation.x - centerOfDeck.x, 2) + pow(touchLocation.y - centerOfDeck.y, 2));
        
        //Let's check if the current distance is smaller than the one we got
        if(distance < minDistanceOfSolvedDecks){
            //We save the current distance and the index of the
            //solved deck...
            minDistanceOfSolvedDecks = distance;
            indexOfSolvedDeck = index;
        }
        
        index++;
    }
    
    //Now, let's get the minimum distance between the secondary deck and the solving decks...
    
    //First, let's reset the index to 0
    index = 0;
    
    //Then, we create the variable to store the index of the minimum distance between the secondary deck and the solving decks and the variable to store the minimum distance between the secondary deck and the solving decks...
    
    //Let's initilize it to infinite
    NSInteger minDistanceOfSolvingDecks = NSIntegerMax;
    
    //And the index of the solving deck to -1
    NSInteger indexOfSolvingDeck = -1;
    
    //Let's iterate throught the solving decks...
    for(NSMutableArray* array in self.solvingDecksButtons){
        for(DeckButton* solvingDeckButton in array){
            //Let's get the center of the current secondary deck..
            CGPoint centerOfDeck = [solvingDeckButton center];
            
            //Now, let's calculate the distance between the touch and the center of the deck...
            
            NSInteger distance = sqrt(pow(touchLocation.x - centerOfDeck.x, 2) + pow(touchLocation.y - centerOfDeck.y, 2));
            
            //Now, let's find out if the current distance is smaller than the one we got..
            if(distance < minDistanceOfSolvingDecks){
                //If so, we store the current distance and the index of the current deck..
                minDistanceOfSolvingDecks = distance;
                indexOfSolvingDeck = index;
            }
        }
        index++;
    }
    
    //Now, let's see which one of the minimum distances is the smaller one..
    if(minDistanceOfSolvedDecks < minDistanceOfSolvingDecks){
        [self.game moveCardFromSecondaryDeckToSolvedDeck:indexOfSolvedDeck];
    }else{
        [self.game moveCardFromSecondaryDeckToSolvingDeck:indexOfSolvingDeck];
    }
    
    [self updateUI];
}

- (IBAction)secondaryDeckButtonTouchDown:(UIButton *)sender {
    if([self.game getFirstCardFromSecondaryDeck]){
        [[self.game getFirstCardFromSecondaryDeck] choose];
    }
}
- (IBAction)secondaryDeckButtonTouchUpInside:(UIButton *)sender forEvent:(UIEvent *)event {
    [self secondaryDeckButtonTouchUpOutside:sender forEvent:event];
}

@end
