//
//  Item.h
//  MGWUMinigameTemplate
//
//  Created by Justin Williams on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "MGWUCharacter.h"


@interface Item: CCNode

//tag '10' represents bacteria
//tag '11' represents energy
@property int tag;

-(void)setType:(int)visible;
-(BOOL)isDone;

@end
