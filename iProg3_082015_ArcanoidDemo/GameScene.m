//
//  GameScene.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 08/08/15.
//  Copyright (c) 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameScene.h"
#import "ArcanoidConstants.h"

static const CGFloat kBallMinAllowedSpeed = 20;
static const CGFloat kBallXYSpeedToSet = 60;

@interface GameScene() <SKPhysicsContactDelegate>

@property (nonatomic,strong) SKSpriteNode *desk;
@property (nonatomic,strong) SKSpriteNode *gameOverLine;
@property (nonatomic) BOOL isTouchDesk;
@property (nonatomic,strong) SKSpriteNode *ball;

@end

@implementation GameScene

-(SKSpriteNode *)gameOverLine {
    if(!_gameOverLine) {
        _gameOverLine = [SKSpriteNode new];
        
        CGRect bodyRect = CGRectMake(0,
                                     0,
                                     CGRectGetWidth(self.frame),
                                     1);
        
        _gameOverLine.physicsBody  = [SKPhysicsBody bodyWithEdgeLoopFromRect:bodyRect];
        _gameOverLine.physicsBody.categoryBitMask = PhysicsCategoryGameOverLine;
       // _gameOverLine.physicsBody.contactTestBitMask = PhysicsCategoryBall; - достаточно описать только для мяча
        _gameOverLine.name = @"game over line";
        
    }
    return _gameOverLine;
}

-(SKSpriteNode *)desk {
    if(!_desk) {
        _desk = (SKSpriteNode *)[self childNodeWithName:@"desk"];
        NSParameterAssert(_desk);
        _desk.physicsBody.friction = 0;
        _desk.physicsBody.restitution = 1;
        _desk.physicsBody.linearDamping = 0;
        _desk.physicsBody.angularDamping = 0;
        _desk.physicsBody.categoryBitMask = PhysicsCategoryDesk;
    }
    return _desk;
}

-(SKSpriteNode *)ball {
    if(!_ball) {
        _ball = [self setupBall];
    }
    return _ball;
}

#pragma mark GameScene life cycle

-(void)didMoveToView:(SKView *)view {
    
    // барьер для отражения шарика
    SKPhysicsBody *border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    border.friction = 0; // трение скольжения
    self.physicsBody = border;
    //self.physicsBody.categoryBitMask = 0; - шарик улетит если так делать
    
    // управление гравитацией в мире
    self.physicsWorld.gravity = CGVectorMake(0, 0); // уровень без гравитации
    
    // делегирование
    self.physicsWorld.contactDelegate = self;
    
    // мячик
    [self setupBall];
    
    // линия контроля выхода мячика за сцену
    [self addChild:self.gameOverLine];
    
}

-(SKSpriteNode *)setupBall {
    
    SKSpriteNode *ball = (SKSpriteNode *)[self childNodeWithName:@"ball"];
    NSParameterAssert(ball);
    
    ball.physicsBody.friction = 0;          // трение
    ball.physicsBody.restitution = 1;       // упругость
    ball.physicsBody.linearDamping = 0;     // замедление при столкновении
    ball.physicsBody.angularDamping = 0;    // замеделение вращения
    ball.physicsBody.allowsRotation = NO;
    
    ball.physicsBody.categoryBitMask = PhysicsCategoryBall;             // битовая маска мячей
    ball.physicsBody.contactTestBitMask = PhysicsCategoryGameOverLine;  // битовая маска объектов взаимодействия - например линия выхода за пределы игрового поля
    
    [ball.physicsBody applyImpulse:CGVectorMake(15, -10)];
    
    return ball;
    
}

#pragma mark Touches events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    NSArray *nodesInTouchLocation = [self nodesAtPoint:touchLocation];
    
    self.isTouchDesk = [nodesInTouchLocation containsObject:self.desk];
}

- (void)updateDeskPosition:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    if(self.isTouchDesk == NO) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInNode:self];
    CGPoint prevPoint = [touch previousLocationInNode:self];
    
    CGFloat dx = curPoint.x - prevPoint.x;
    CGFloat newDeskX = self.desk.position.x + dx;
    
    CGPoint newPosition = self.desk.position;
    newPosition.x = newDeskX;
    
    CGFloat deskWidth = CGRectGetWidth(self.desk.frame);
    //      left border
    if( newPosition.x < deskWidth / 2) {
        newPosition.x = deskWidth / 2;
    }
    //      right boreder
    if( newPosition.x > CGRectGetWidth(self.frame) - deskWidth/2) {
        newPosition.x = CGRectGetWidth(self.frame) - deskWidth/2;
    }
    
    self.desk.position = newPosition;
    
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self updateDeskPosition:touches withEvent:event];
}

#pragma mark Updates

-(void)didSimulatePhysics {
    [self fixBallBug];
}

-(void)fixBallBug {
    // перемещение мяча
    if( fabs(self.ball.physicsBody.velocity.dx) < kBallMinAllowedSpeed) {
        CGVector velocity = self.ball.physicsBody.velocity;
        velocity.dx = self.ball.position.x > CGRectGetWidth(self.frame)/2 ? -kBallXYSpeedToSet : kBallXYSpeedToSet ;
        
        SKPhysicsBody *body = self.ball.physicsBody;
        self.ball.physicsBody = nil;
        body.velocity = velocity;
        self.ball.physicsBody = body;
    }
    
    if( fabs(self.ball.physicsBody.velocity.dy) < kBallMinAllowedSpeed) {
        CGVector velocity = self.ball.physicsBody.velocity;
        velocity.dy =  -kBallXYSpeedToSet;
        
        SKPhysicsBody *body = self.ball.physicsBody;
        self.ball.physicsBody = nil;
        body.velocity = velocity;
        self.ball.physicsBody = body;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
}

#pragma mark - Physics

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *bodyA;
    SKPhysicsBody *bodyB; // больше А по условию
    
    if( contact.bodyB.categoryBitMask > contact.bodyA.categoryBitMask ) {
        bodyB = contact.bodyB;
        bodyA = contact.bodyA;
    }
    else {
        bodyA = contact.bodyB;
        bodyB = contact.bodyA;
    }
    
    if(PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryBall) &&
       PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryGameOverLine)) {
        NSLog(@"show gameover");
        [self showGameOver];
    }
    
}

-(void)showGameOver {
    
    
    
    
}




@end
