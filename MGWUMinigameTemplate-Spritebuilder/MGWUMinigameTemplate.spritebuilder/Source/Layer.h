//
//  Layer.h
//  MGWUMinigameTemplate
//
//  Created by Justin Williams on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Item.h"

@interface Layer : CCNode

@property int touchedTag;

-(void)spawnItems:(CCTime)delta;
-(void)cleanup;
-(void)showBacteria;

@end
