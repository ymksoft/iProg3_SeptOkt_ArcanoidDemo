//
//  GameScene.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 08/08/15.
//  Copyright (c) 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()

@property (nonatomic,strong) SKSpriteNode *desk;
@property (nonatomic) BOOL isTouchDesk;
@end

@implementation GameScene

-(SKSpriteNode *)desk {
    if(!_desk) {
        _desk = (SKSpriteNode *)[self childNodeWithName:@"desk"];
        NSParameterAssert(_desk);
        _desk.physicsBody.friction = 0;
        _desk.physicsBody.restitution = 1;
        _desk.physicsBody.linearDamping = 0;
        _desk.physicsBody.angularDamping = 0;
    }
    return _desk;
}

#pragma mark GameScene life cycle

-(void)didMoveToView:(SKView *)view {
    
    // барьер для отражения шарика
    SKPhysicsBody *border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    border.friction = 0; // трение скольжения
    self.physicsBody = border;
    
    // управление гравитацией в мире
    self.physicsWorld.gravity = CGVectorMake(0, 0); // уровень без гравитации
    
    // мячик
    [self setupBall];
    
}

-(void)setupBall {
    
    SKSpriteNode *ball = (SKSpriteNode *)[self childNodeWithName:@"ball"];
    NSParameterAssert(ball);
    
    ball.physicsBody.friction = 0;          // трение
    ball.physicsBody.restitution = 1;       // упругость
    ball.physicsBody.linearDamping = 0;     // замедление при столкновении
    ball.physicsBody.angularDamping = 0;    // замеделение вращения
    ball.physicsBody.allowsRotation = NO;
    
    [ball.physicsBody applyImpulse:CGVectorMake(15, -10)];
    
}

#pragma mark Touches events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    NSArray *nodesInTouchLocation = [self nodesAtPoint:touchLocation];
    
    self.isTouchDesk = [nodesInTouchLocation containsObject:self.desk];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if(self.isTouchDesk == NO) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInNode:self];
    CGPoint prevPoint = [touch previousLocationInNode:self];
    
    CGFloat dx = curPoint.x - prevPoint.x;
    CGFloat newDeskX = self.desk.position.x + dx;
    
    CGPoint newPosition = self.desk.position;
    newPosition.x = newDeskX;
    
    self.desk.position = newPosition;
}

-(void)update:(CFTimeInterval)currentTime {
    
}

@end
