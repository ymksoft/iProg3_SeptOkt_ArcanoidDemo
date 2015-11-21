//
//  GameOverScene.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
#import "ArcanoidConstants.h"


@implementation GameOverScene

-(instancetype)initWithSize:(CGSize)size victory:(BOOL)playerWin score:(NSInteger)score {
    self = [self initWithSize:size];
    if(self) {
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize backSize = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:backSize];
        
        [self addChild:background];
        
        SKLabelNode *victoryLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        victoryLabel.fontSize = 40;
        victoryLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));
        victoryLabel.text = playerWin ? @"You are Winner!" : @"You are looser!";
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        scoreLabel.fontSize = 40;
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame) + 50);
        
        scoreLabel.text = [NSString stringWithFormat:@"Score: %lu",score ];

        [self addChild:victoryLabel];
        [self addChild:scoreLabel];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startNewGame];
}

-(void)startNewGame {
    
    GameScene *game = [GameScene unarchiveFromFile:kArcanoidGameSceneName];
    
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1];
    [self.view  presentScene:game
                  transition:transition];
    
}

@end
