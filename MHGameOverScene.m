//
//  MHGameOverScene.m
//  FootBall
//
//  Created by Mansoor on 3/27/2014.
//  Copyright (c) 2014 Mansoor. All rights reserved.
//

#import "MHGameOverScene.h"
#import "MHMyScene.h"

@implementation MHGameOverScene
{
    int HighScore;
    

    SKLabelNode *label;
}



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor greenColor];
        [self addChild:[self gamOverNode]];
        
        
        NSString * retrymessage;
        retrymessage = @"Replay Game";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor redColor];
        retryButton.position = CGPointMake(self.size.width/2, 50);
        retryButton.name = @"retry";
        [retryButton setScale:.5];
        
        [self addChild:retryButton];
        
        
        //highscore
        
        HighScore  = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
        label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = [NSString stringWithFormat:@"%d",HighScore];
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/1, self.size.height/2);
        [self addChild:label];
    
        
        
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"retry"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        
        SKScene * scene = [MHMyScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
}

-(void)drawScoreBoard
{
    [self addChild:[self gamOverNode]];
    [self addChild:[self hitLabel]];
    [self addChild:[self takenLabel]];
    
}
- (SKLabelNode*)gamOverNode
{
    SKLabelNode* labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelNode.text=@"Game Over!";
    labelNode.position=CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/4);
    return labelNode;
}
- (SKLabelNode*)hitLabel
{
    SKLabelNode* labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelNode.text=[NSString stringWithFormat:@"balls hit:  %i",self.ballsHits];
    labelNode.position=CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/2);
    return labelNode;
}
- (SKLabelNode*)takenLabel
{
    SKLabelNode* labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    labelNode.text=[NSString stringWithFormat:@"Taken hits:  %i",self.takenHits];
    labelNode.position=CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/4);
    return labelNode;
}




@end
