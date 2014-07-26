//
//  MHGameOverScene.h
//  FootBall
//
//  Created by Mansoor on 3/27/2014.
//  Copyright (c) 2014 Mansoor. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MHGameOverScene : SKScene

@property(nonatomic,assign) uint32_t ballsHits;
@property(nonatomic,assign) uint32_t takenHits;

-(void)drawScoreBoard;




@end
