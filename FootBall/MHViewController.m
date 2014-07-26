//
//  MHViewController.m
//  FootBall
//
//  Created by Mansoor on 3/27/2014.
//  Copyright (c) 2014 Mansoor. All rights reserved.
//

#import "MHViewController.h"
#import "MHMyScene.h"
#import "Front.h"


@implementation MHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView* gameView= (SKView *)self.view;
    gameView.showsFPS = YES;
    gameView.showsNodeCount = YES;
    gameView.showsDrawCount=YES;
    
    // Create and configure the scene.
    SKScene* front = [Front sceneWithSize:gameView.bounds.size];
    front.scaleMode = SKSceneScaleModeAspectFill;
    [gameView presentScene:front];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
