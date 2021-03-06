//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MyCharacter.h"

@implementation MyCharacter
{
    float _velYPrev; // this tracks the previous velocity, it's used for animation
    BOOL _isIdling; // these BOOLs track what animations have been triggered.  By default, they're set to NO
    BOOL _isJumping;
    BOOL _isFalling;
    BOOL _isLanding;
    
    BOOL _isWalking;
    BOOL _isRunning;
    BOOL _isFlying;
    
    //The speed of the character moving
    float _speed;
}

-(id)init
{
    
    if ((self = [super init])) {
        // Initialize any arrays, dictionaries, etc in here
        
        // We initialize _isIdling to be YES, because we want the character to start idling
        // (Our animation code relies on this)
        _isWalking = YES;
        // by default, a BOOL's value is NO, so the other BOOLs are NO right now
        
        //Same goes for this minigame's idle
        
        //Inital speed
        _speed = 0;
        self.done = NO;
    }
    return self;
}

-(void)didLoadFromCCB {
    // Set up anything connected to Sprite Builder here
}

-(void)onEnter {
    [super onEnter];
    // Create anything you'd like to draw here
}

-(void)update:(CCTime)delta
{
    // Called each update cycle
    // n.b. Lag and other factors may cause it to be called more or less frequently on different devices or sessions
    // delta will tell you how much time has passed since the last cycle (in seconds)
    
    // This sample method is called every update to handle character animation
    [self updateAnimations:delta];
}

-(void)updateAnimations:(CCTime)delta
{
    if((_speed >= 1.f) && (_speed < 5.f) && !_isWalking)
    {
        [self resetBools];
        _isWalking = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimSideWalking"];
        self.animationManager.playbackSpeed = _speed;
    }
    
    else if ((_speed >= 5.f) && (_speed < 8.f) && !_isRunning)
    {
        [self resetBools];
        _isRunning = YES;
        [self.animationManager runAnimationsForSequenceNamed: @"AnimSideRunning"];
        self.animationManager.playbackSpeed = _speed;
    }
    else if((_speed >= 8.f) && !_isFlying)
    {
        [self resetBools];
        _isFlying = YES;
        [self.animationManager runAnimationsForSequenceNamed: @"AnimSideFly"];
        self.animationManager.playbackSpeed = 2;
    }
    else if((_speed <= 8.f) && (_speed >= 1) && (!_isFlying))
    {
          self.animationManager.playbackSpeed = _speed;
    }
    else if([self.animationManager.lastCompletedSequenceName  isEqual: @"GameOver"])
    {
        _done = YES;
    }
    
    
    /**
    // IDLE
    // The animation should be idle if the character was and is stationary
    // The character may only start idling if he or she was not already idling or falling
    if (_velYPrev == 0 && self.physicsBody.velocity.y == 0 && !_isIdling && !_isFalling)
    {
        [self resetBools];
        _isIdling = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimIsoIdling"];
        NSLog(@"In Idle");
    }
    // JUMP
    // The animation should be jumping if the character wasn't moving up, but now is
    // The character may only start jumping if he or she was idling and isn't jumping
    else if (_velYPrev == 0 && self.physicsBody.velocity.y > 0 && _isIdling && !_isJumping)
    {
        [self resetBools];
        _isJumping = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimIsoJump"];
    }
    // FALLING
    // The animation should be falling if the character's moving down, but was moving up or stalled
    // The character may only start falling if he or she was jumping and isn't falling
    else if (_velYPrev >= 0 && self.physicsBody.velocity.y < 0 && _isJumping && !_isFalling) {
        [self resetBools];
        _isFalling = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimIsoFalling" tweenDuration:0.5f];
    }
    // LANDING
    // The animation sholud be landing if the character's stopped moving down (hit something)
    // The character may only start landing if he or she was falling and isn't landing
    else if (_velYPrev < 0 && self.physicsBody.velocity.y >= 0 && _isFalling && !_isLanding) {
        [self resetBools];
        _isLanding = YES;
        [self.animationManager runAnimationsForSequenceNamed:@"AnimIsoLand"];
    }
    // We track the previous velocity, since it's important to determining how the character is and was moving for animations
    _velYPrev = self.physicsBody.velocity.y;
     */
    
}
    

// This method is called before setting one to YES, so that only one is ever YES at a time
-(void)resetBools
{
    _isIdling = NO;
    _isJumping = NO;
    _isFalling = NO;
    _isLanding = NO;
    _isWalking = NO;
    _isRunning = NO;
    _isFlying = NO;
}

// This method is called before setting one to NO, so that no animation will play when the game is done
-(void)Bools_Are_Over
{
    _isIdling = YES;
    _isJumping = YES;
    _isFalling = YES;
    _isLanding = YES;
    _isWalking = YES;
    _isRunning = YES;
    _isFlying = YES;
}

// This method tells the character to jump by giving it an upward velocity.
// It's been added to a physics node in the main scene, like the penguins Peeved Penguins, so it will fall automatically!
-(void)jump
{
    self.physicsBody.velocity = ccp(0,122);
}

-(void)setSpeed:(float) speedPerTouch
{
    _speed = speedPerTouch;
}

-(void)gameoverAnim
{
    [self Bools_Are_Over];
    self.animationManager.playbackSpeed = 1;
    [self.animationManager runAnimationsForSequenceNamed: @"GameOver"];
}

@end
