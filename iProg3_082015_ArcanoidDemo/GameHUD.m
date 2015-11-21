//
//  GameHUD.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameHUD.h"
#import "ArcanoidConstants.h"


@interface GameHUD ()

@property (nonatomic,strong) SKLabelNode *scoreLabel;
@property (nonatomic,strong) SKLabelNode *hightScoreLabel;
@property (nonatomic,strong) SKLabelNode *lifeCountLabel;

@end

@implementation GameHUD

#pragma mark - Properties

-(void)setScore:(NSInteger)score {
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.score];
    
    if(self.hightScore < self.score)
        self.hightScore = self.score;
}

-(void)setHightScore:(NSInteger)hightScore {
    _hightScore = hightScore;
    self.hightScoreLabel.text = [NSString stringWithFormat:@"Hight: %ld", (long)self.hightScore];
}

-(void)setLifeCount:(NSInteger)lifeCount {
    _lifeCount=  lifeCount;
    self.lifeCountLabel.text = [NSString stringWithFormat:@"Life: %ld", (long)self.lifeCount];
}
#pragma mark - Init

-(instancetype)initWithSize:(CGSize)size {
    
    self = [super initWithColor:[UIColor clearColor] size:size];

   // CGFloat scale = [UIScreen mainScreen].scale;
   // CGSize backSize = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));
    
   // size = backSize;
    
    SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    score.fontSize = 14;
    self.scoreLabel = score;
    
    SKLabelNode *hightScore = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    hightScore.fontSize = 14;
    self.hightScoreLabel = hightScore;
    
    SKLabelNode *lifeCount = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    lifeCount.fontSize = 14;
    self.lifeCountLabel = lifeCount;
    
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.hightScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.lifeCountLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    
    self.scoreLabel.position        = CGPointMake(-size.width/2,  -size.height / 2);
    self.hightScoreLabel.position   = CGPointMake(size.width/2,  -size.height /2);
    self.lifeCountLabel.position    = CGPointMake(0,  -size.height /2);

    [self addChild:self.scoreLabel];
    [self addChild:self.hightScoreLabel];
    [self addChild:self.lifeCountLabel];
    
//   self.score = 555;
//  self.hightScore = 777;
//  self.lifeCount = 5;
    
    self.hightScore = [[NSUserDefaults standardUserDefaults] integerForKey:kHightScoreKey];
    
    return self;
    
}

@end
