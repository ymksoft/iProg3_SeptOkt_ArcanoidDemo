//
//  GameViewController.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 08/08/15.
//  Copyright (c) 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"


@implementation SKScene (Unarchive)



@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = NO;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
