//
//  MHMyScene.m
//  FootBall
//
//  Created by Mansoor on 3/27/2014.
//  Copyright (c) 2014 Mansoor. All rights reserved.
//

#import "MHMyScene.h"
#import "MHGameOverScene.h"


static const uint32_t netCategory=  0x1 << 1;
static const uint32_t ballCategory=  0x1 << 2;



@interface MHMyScene()<SKPhysicsContactDelegate>
{
    SKSpriteNode* player;
    int HighScore;
    SKLabelNode *label;
    
}

//number of times the ship has taken damage
@property(nonatomic) uint32_t takenHits;
//The number of asteroids hit by a missile
@property(nonatomic) uint32_t ballsHits;


@end

@implementation MHMyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        self.physicsWorld.contactDelegate=self;
        
        /* //adding the background
         SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
         background.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
         [self addChild:background];
         */
        //highscore
        HighScore  = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
        label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = [NSString stringWithFormat:@"%d",HighScore];
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/1, self.size.height/2);
        [self addChild:label];
        
        
        
        //Initialize your properties
        self.takenHits=0;
        self.ballsHits=0;
    
        [self addChild:[self createPlayer]];
        [self createBalls];
        
        
        
    }
    return self;
}

#pragma mark contact delegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //Create two physics body objects
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & netCategory) != 0)
    {
        //firstBody = player and secondBody = ball --> the net is hit by an ball
        [secondBody.node removeFromParent];
        self.takenHits++;
        self.ballsHits++;
        
       
        
    }
    
    
    
    
    if (self.takenHits >= 15)
    {
        //Game Over
        [self gameOver];
        
    }
}


#pragma mark GameOver
-(void)gameOver
{
    self.paused=YES;
       MHGameOverScene * gameOverScene = [MHGameOverScene sceneWithSize:self.scene.view.bounds.size];
    gameOverScene.scaleMode = SKSceneScaleModeAspectFill;
    //Pass your properties to display the game results
    gameOverScene.takenHits=self.takenHits;
    gameOverScene.ballsHits=self.ballsHits;
    [gameOverScene drawScoreBoard];
    SKTransition* doors = [SKTransition
                           doorsOpenHorizontalWithDuration:2.0];
    [self.scene.view presentScene:gameOverScene transition:doors];
}

#pragma mark player
-(SKSpriteNode *)createPlayer
{
    if (!player)
    {
        player = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
        player.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame)/2);
        
        player.name = @"player";
        //Add it to the physics subsystem by giving it a SKPhysicsBody object
        player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.width/2];
        player.physicsBody.dynamic = NO;
        //add the category and contact and collision mask
        player.physicsBody.categoryBitMask = netCategory;
        // player.physicsBody.contactTestBitMask = shipCategory | asteroidCategory;
        
        
    }
    return player;
}

#pragma mark player actions

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* aTouch = [touches anyObject];
    CGPoint newlocation = [aTouch locationInView:self.view];
    CGPoint prevlocation = [aTouch previousLocationInView:self.view];
    if (newlocation.x - prevlocation.x > 0)
    {
        //finger touch went right
        SKAction* moveRight = [SKAction moveToX:newlocation.x duration:0.01];
        [player runAction:moveRight];
    }
    else
    {
        //finger touch went left
        SKAction* moveLeft = [SKAction moveToX:newlocation.x duration:0.01];
        [player runAction:moveLeft];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark balls

- (CGFloat)makeRandomXWBetween:(CGFloat)low and:(CGFloat)high
{
    CGFloat randomValue = rand() / (CGFloat) RAND_MAX;
    return (randomValue * (high - low) + low);
}

- (void)addBall
{
    SKSpriteNode* ball = [SKSpriteNode spriteNodeWithImageNamed:@"net"];
    //set the position to a random X value
    ball.position=CGPointMake ([self makeRandomXWBetween:0 and:self.size.width],self.size.height);
    ball.name = @"net";
    ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.size];
    ball.physicsBody.usesPreciseCollisionDetection=YES;
    
    //Add the category and contact and collision bitmas
    ball.physicsBody.categoryBitMask=ballCategory;
    ball.physicsBody.contactTestBitMask=netCategory;
    ball.physicsBody.collisionBitMask=netCategory;
    
    [self addChild:ball];
}

-(void)createBalls
{
    SKAction* addBallAction = [SKAction sequence: @[
                                                    [SKAction performSelector:@selector(addBall) onTarget:self],
                                                    [SKAction waitForDuration:3.0 withRange:0.95]
                                                    ]];
    SKAction* runInfinite= [SKAction repeatActionForever:addBallAction];
    [self runAction:runInfinite];
    
}


#pragma mark override
-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
    
}

- (void)update:(NSTimeInterval)currentTime
{
}

- (void)didEvaluateActions
{
    
}

@end
