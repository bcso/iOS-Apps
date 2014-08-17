//
//  Grid.m
//  GameOfLife
//
//  Created by Brian So on 8/17/2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid{
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
    
}

- (void)onEnter{
    [super onEnter];
    [self setupGrid];
    
    // accept touches on the grid
    self.userInteractionEnabled = YES;
}

- (void)setupGrid
{
    // divide the grid's size by the number of columns/rows to figure out the right width and height of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    // initialize Creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        // this is how you create two dimensional arrays in Objective-C. You put arrays into arrays.
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0, 0);
            creature.position = ccp(x, y);
            [self addChild:creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            

            
            x+=_cellWidth;
        }
        
        y += _cellHeight;
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    //get the Creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    //invert it's state - kill it if it's alive, bring it to life if it's dead.
    creature.isAlive = !creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition{
     //get the row and column that was touched, return the Creature inside the corresponding cell
    int row = touchPosition.y/_cellHeight;
    int column = touchPosition.x/_cellWidth;
    return _gridArray[row][column];
}

- (void)evolveStep{
    //update each Creatures neighbor count
    [self countNeighbours];

    //update each Creatres state
    [self updateCreatures];
    
    //update the generation
    _generation++;
}

-(BOOL)isIndexValidForX:(int)x andY:(int)y{
    BOOL isIndexValid = YES;
    if (x<0 || y<0 || x>=GRID_ROWS || y>GRID_COLUMNS){
        isIndexValid = NO;
    }
    return isIndexValid;
}

-(void)countNeighbours{
    //iterate through the rows
    //note that NSArray has a method 'count' that will return the number of elements in it
    for (int i=0; i<[_gridArray count]; i++) {
        for (int j=0; i<[_gridArray[i] count]; j++){
            Creature *currentCreature = _gridArray[i][j];
            
            currentCreature.livingNeighbours = 0;
            
            for (int x = (i-1); x<=(i+1); x++){
                for (int y = (j-1); x<=(j+1); y++){
                    BOOL isIndexValid = [self isIndexValidForX:x andY:y];
                    if (!((x == i && y == j)) && isIndexValid){
                        Creature *neighbour = _gridArray[x][y];
                        if (neighbour.isAlive){
                            currentCreature.livingNeighbours += 1;
                        }
                    }
                }
            }
        }
    }
}

-(void)updateCreatures{
    int numAlive = 0;
    for(int i = 0; i<[_gridArray count]; i++){
        for(int j = 0; j<[_gridArray[i] count]; j++){
            Creature *currentCreature = _gridArray[i,j];
            int neighbours = currentCreature.livingNeighbours;
            if (neighbours == 3){
                currentCreature.isAlive = TRUE;
                numAlive ++;
            }
            else if ((neighbours == 1) || (neighbours >= 4)){
                currentCreature.isAlive = FALSE;
            }
        }
    }
    _totalAlive = numAlive;
}

@end
