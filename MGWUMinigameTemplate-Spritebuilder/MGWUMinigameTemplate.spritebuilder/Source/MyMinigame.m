//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/6/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MyMinigame.h"





@class CCBSequence;
@implementation MyMinigame
{

    //For moving the ground
    CCNode *_ground1;
    CCNode *_ground2;
    NSArray *_grounds;
    
    //For the moving background
    CCNode *_back1;
    CCNode *_back2;

    //The phyics
    CCPhysicsNode* physicsNode;
    
    NSTimeInterval _footForward;
    NSTimeInterval _count;
    
    float _speed;
    CGFloat _distance;
    
    Layer *_layer;
    
    BOOL _gameisOver;
    float _score;
    
    CCLabelTTF* _timer;
    CCLabelTTF* _endScore;
}

-(id)init
{
    if ((self = [super init]))
    {
        // Initialize any arrays, dictionaries, etc in here
        _speed = 1;
        _gameisOver = NO;
        _score = 0;
        
        //Instructions for the game
        self.instructions = @"The Hero drank an energy drink and he is ready for his run. Touch as many orange energy molecules to give the hero energy that he deserves. Don't touch the bacteria because that's definitely not the one he needs.";
        
        
        _layer = [[Layer alloc] init];
        
    }
    return self;
}

-(void)didLoadFromCCB
{
    // Set up anything connected to Sprite Builder here
    
    _grounds = @[_ground1, _ground2];
    
    [_endScore setVisible:NO];
    
    // We're calling a public method of the character that tells it to jump!
    //[self.hero jump];
}

-(void)onEnter
{
    [super onEnter];
    // Create anything you'd like to draw here
    
    //  These tell the Cocos2d scheduler to call our methods at regular intervals
    [self schedule:@selector(UpdateTime) interval:1.f];
}

- (void)cleanup
{
    
    //  cleanup is called before our minigame gets deallocated (which happens after we call endMinigameWithScore)
    //  So we need  to tell the Cocos2d scheduler that we don't need our UpdateTime method called anymore
    [self unscheduleAllSelectors];
}


-(void)update:(CCTime)delta
{
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
    
     _footForward += delta;
     _count += delta;
    if(!_gameisOver)
    {
        if(_timer.string.intValue == 0)
        {
            [self GameOver];
        }
        
        if(_layer.touchedTag == 10)
        {
            [self GameOver];
            
            //Resets the tag to 0 until something else is touched
            _layer.touchedTag = 0;
        }
        else if(_layer.touchedTag == 11)
        {
            _speed += .2f;
            
            //Resets the tag to 0 until something else is touched
            _layer.touchedTag = 0;
        }
        
        if(_speed <= 0)
        {
            [self GameOver];
        }
        
        //Sets the speed and spawn items every .5 seconds
        if(_count >= .25f)
        {
            [self.hero setSpeed: _speed];
            [_layer spawnItems:delta];
            
             _count = 0;
        }
        
        //If a foot moves foward along with the correct interval in the timeline
        if( _footForward >= (.5f/ _speed) )
        {
            [self moveGround: delta];
            [self moveBackground];
            _footForward = 0;
        }
    }
    //If the game over animation is done
    else if(self.hero.done == YES)
    {
        [self endMinigame];
    }
    else
    {
        _count+= delta;
        if (_count >= 5.2f)
        {
            [self endMinigame];
        }
    }
}

-(void)moveGround: (CCTime)delta
{
    //Moves the PhyicsNode and character
    physicsNode.position = ccp(physicsNode.position.x - (15.f * delta), physicsNode.position.y);
    
    // loop the ground
    for (CCNode *ground in _grounds)
    {
        
        // get the world position of the ground
        CGPoint groundWorldPosition = [physicsNode convertToWorldSpace:ground.position];
        
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width))
        {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }

}

-(void)moveBackground
{
    
    _distance = 3 * _speed;
    CGPoint pointOne=CGPointMake(_back1.position.x  - _distance, _back1.position.y);
    CGPoint pointTwo=CGPointMake(_back2.position.x - _distance, _back1.position.y);
    [_back1 setPosition: pointOne];
    [_back2 setPosition: pointTwo];
    
    if(self.hero.position.x >= _back2.position.x)
    {
        CGFloat newPos = _back2.position.x + _back2.contentSize.width - 1;
        pointOne = CGPointMake(newPos, _back1.position.y);
        [_back1 setPosition: pointOne];
        
        //back 2 becomes back 1 and vice-versa to show which is first and next
        CCNode *temp = _back1;
        _back1 = _back2;
        _back2 = temp;
    }

}

-(void)UpdateTime
{

    if(!_gameisOver)
    {
    int i = _timer.string.intValue;
     _timer.string = [NSString stringWithFormat:@"%i", i - 1];
    }
}


-(void)GameOver
{
    _gameisOver = YES;
    
    //Removes all items from the layer
    [_layer cleanup];
    
    if(_layer.touchedTag == 10)
    {
        //Plays game over animation
        [self.hero gameoverAnim];
        
        //Shows the bacteria that was touched
        [_layer showBacteria];
    }
   
        //Starts a countdown of when to call endminigame
        _count = 0;
        
        
        _score = _speed;
        
        if(_score <= 1.f)
        {
            _score = 0;
        }
        else
        {
            // Gets the score according to speed as a whole number and as an increment 1 of instead of 2
            _score = (((_score - 1.f) * 10));
        }
        
        if(_score > 100)
        {
            _score = 100;
        }
    
    [self createScoreLabel];
}

-(void)createScoreLabel
{
    
    _endScore.string = [NSString stringWithFormat:@"Score: %.0f", _score];
    [_endScore setVisible:YES];
}


-(void)endMinigame
{
    // Be sure you call this method when you end your minigame!
    // Of course you won't have a random score, but your score *must* be between 1 and 100 inclusive
    [self endMinigameWithScore:_score];
    
}

// DO NOT DELETE!
-(MyCharacter *)hero
{
    return (MyCharacter *)self.character;
}
// DO NOT DELETE!

@end
