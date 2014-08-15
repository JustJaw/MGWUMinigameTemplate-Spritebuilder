//
//  Item.m
//  MGWUMinigameTemplate
//
//  Created by Justin Williams on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Item.h"

@implementation Item
{
    BOOL _appear;
    BOOL _move;
    BOOL _disappear;
    BOOL _done; //If all animations are done
    
   CCNode *_bacteria;
   CCNode *_energy;
   CCNode *_letterE;
  
}

-(id)init
{
    
    if ((self = [super init]))
    {
        // Initialize any arrays, dictionaries, etc in here
        _appear = NO;
        
        
    }
    return self;
}

-(void)didLoadFromCCB
{
    // Set up anything connected to Sprite Builder here
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
}

/**
 If the number is 0, only the bacteria animation will be visible. If it is any other number, the energy will apear
 instead
 
 */
-(void)setType:(int)visible
{
    if(visible == 0)
    {
        [_letterE setVisible:NO];
        [_energy setVisible:NO];
        self.tag = 10;
    }
    else
    {
        [_bacteria setVisible:NO];
        self.tag = 11;
    }
}

-(void)animate:(CCTime)delta
{
    [self update:delta];
}

-(void)update:(CCTime)delta
{
    [self updateAnimations:delta];
}

-(void)updateAnimations:(CCTime)delta
{
    
    if(!_appear)
    {
        [self.animationManager runAnimationsForSequenceNamed:@"Appear"];
        _appear = YES;
    }
    else if([self.animationManager.lastCompletedSequenceName  isEqual: @"Appear"] && !_move)
    {
        [self.animationManager runAnimationsForSequenceNamed:@"Move"];
        _move = YES;
    }
    else if([self.animationManager.lastCompletedSequenceName  isEqual: @"Move"] && !_disappear)
    {
        [_letterE setVisible:NO]; //Makes the letter E invisble
        [self.animationManager runAnimationsForSequenceNamed:@"Disappear"];
        _disappear = YES;
    }
    else if ([self.animationManager.lastCompletedSequenceName  isEqual: @"Disappear"] && !_done)
    {
        _done = YES;
    }
}

-(BOOL)isDone
{
    return _done;
}

-(void)touched
{
    
}

@end
