//
//  Layer.m
//  MGWUMinigameTemplate
//
//  Created by Justin Williams on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Layer.h"

@implementation Layer
{
    Item *item;
    NSMutableArray* _itemArray;
    Class elementClass;
    Item *LastItem; //Last Item touched
}

- (id) init
{
    if ((self = [super init]))
    {
        // Initialize any arrays, dictionaries, etc in here
        item = [[Item alloc] init];
        
        _itemArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}



- (void)onEnter
{
    [super onEnter];
    
    // accept touches on the layer(upper part of screen)
    self.userInteractionEnabled = YES;
    
    
}

-(void)spawnItems:(CCTime)delta
{
    //Loads the Item.ccb
    item = (Item*)[CCBReader load:@"Item"];
    
    // Generate a random number that will be either 0 or 1 or 2
    int randomNumber = arc4random() % 3;
    
    //randomNumber = 0;
    //If its a 0, then the bacteria will be the item. With any other number, the energy will be the item
    [item setType:randomNumber];
    
    //Creates a random x and y position
    CGFloat x = [self generateRandomNumberBetweenMin:self.positionInPoints.x Max:self.contentSizeInPoints.width];
    CGFloat y = [self generateRandomNumberBetweenMin:self.positionInPoints.y Max:self.contentSizeInPoints.height];
    
    //New position for the new item
    item.position = ccp(x, y);
    
    //Add the item to our item array so we can track them
    [_itemArray addObject: item];
    
    //Makes Item a child of layer so that it appears in the layer
    [self addChild: item];
    
    //Indexes of item to remove
    int removeIndex[[_itemArray count] + 1];
    int i = 0;
    
    for(Item *itemLoop in _itemArray)
    {
        if([itemLoop isDone])//Gets the index of the item that is done
        {
            removeIndex[i] = ([_itemArray indexOfObject:itemLoop]);
            i++;
        }
    }
    
    //Removes the items at indexes that are done from the _itemArray
    for(int r = 0; r < i;r++)
    {
        [[_itemArray objectAtIndex:r] removeFromParentAndCleanup:YES]; //Removes from the array
        [_itemArray removeObjectAtIndex: removeIndex[r]];
    }
}

-(CGFloat)generateRandomNumberBetweenMin:(CGFloat)min Max:(CGFloat)max
{
    return ( CCRANDOM_0_1() * (max - min) + min);
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    int pos;
    BOOL found = NO;
    
    //The Item that is closest to the touch location. It is initilzed at 100.f
    float closeDis = 100.f;
    
    //The Item that is closest to the touch location.
    Item *closeItem;
    
    for(Item *itemFind in _itemArray)
    {
        float distance = pow(itemFind.position.x - touchLocation.x, 2) + pow(itemFind.position.y - touchLocation.y, 2); //Using distance formula
        
        distance = sqrt(distance);
        
        //If the distance is less than 43 and the item is a bacteria, or distance is less than 50 and the item is energy
        if (((distance <= 15) && (itemFind.tag == 10))  || (((distance <= 20) && (itemFind.tag == 11))))
        {
            found = YES;
            
            if(distance < closeDis)
            {
                closeDis = distance;
                closeItem = itemFind;
            }
        }
    }
    
    if(found)
    {
        //The Last item touched
        LastItem = closeItem;
        
        //Removes the Item
        pos = [_itemArray indexOfObject:closeItem];
        self.touchedTag = closeItem.tag; //Gets the tag of the item that was touched
        [_itemArray removeObjectAtIndex: pos]; //Removes from the array
        [closeItem removeFromParentAndCleanup:YES]; //Removes from the layer
        found = NO;
        closeDis= 0;
    }

}

-(void)cleanup
{
    for(Item *itemLoop in _itemArray)
    {
        [itemLoop removeFromParentAndCleanup:YES];
    }
        [_itemArray removeAllObjects];
}

-(void)showBacteria
{
    [self addChild: LastItem];
}

@end
