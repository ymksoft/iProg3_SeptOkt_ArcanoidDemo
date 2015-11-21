//
//  GameHUD.h
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameHUD : SKSpriteNode

-(instancetype)initWithSize:(CGSize)size;

@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger hightScore;
@property (nonatomic) NSInteger lifeCount;

@end
