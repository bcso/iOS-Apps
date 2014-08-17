//
//  Grid.h
//  GameOfLife
//
//  Created by Brian So on 8/17/2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Grid : CCSprite

@property (nonatomic, assign)int totalAlive;
@property (nonatomic, assign)int generation;

-(void)setupGrid;
-(void)evolveStep;
-(void)countNeighbours;
-(void)updateCreatures;
@end
