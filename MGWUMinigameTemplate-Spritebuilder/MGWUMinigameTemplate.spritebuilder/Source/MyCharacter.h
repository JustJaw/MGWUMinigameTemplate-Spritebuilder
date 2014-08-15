//
//  MGWUMinigameTemplate
//
//  Created by Zachary Barryte on 6/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MGWUCharacter.h"

@interface MyCharacter : MGWUCharacter

@property BOOL done;

-(void)jump;
-(void)setSpeed: (float) speedPerTouch;
-(void)gameoverAnim;




@end
