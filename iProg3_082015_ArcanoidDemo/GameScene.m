//
//  GameScene.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Nikolay Shubenkov on 08/08/15.
//  Copyright (c) 2015 Nikolay Shubenkov. All rights reserved.
//

#import "GameScene.h"
#import "ArcanoidConstants.h"
#import "GameOverScene.h"
#import "Brick.h"
#import "GameHUD.h"
#import "Bonus.h"

static const CGFloat kBallMinAllowedSpeed = 20;
static const CGFloat kBallXYSpeedToSet = 60;

@interface GameScene() <SKPhysicsContactDelegate>

@property (nonatomic,strong) SKSpriteNode *desk;
@property (nonatomic,strong) SKSpriteNode *gameOverLine;
@property (nonatomic,strong) SKSpriteNode *ball;
@property (nonatomic,strong) Bonus *currentBonus;
@property (nonatomic,strong) SKEmitterNode *fire;

@property (nonatomic) BOOL isTouchDesk;
@property (nonatomic,strong) GameHUD *hud;

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
        _desk.physicsBody.contactTestBitMask = PhysicsCategoryBouns;
    }
    return _desk;
}

-(SKSpriteNode *)ball {
    if(!_ball) {
        _ball = [self setupBall];
    }
    return _ball;
}

-(void)setCurrentBonus:(Bonus *)currentBonus {
    _currentBonus = currentBonus;
    [self applyBonus:_currentBonus];
}

-(void)applyBonus:(Bonus *)bonus {
    [bonus runAction:[SKAction fadeOutWithDuration:0.4] completion:^{
        [bonus removeFromParent];
    }];
    
    switch (bonus.type) {
        case BonusTypeFire: {
            NSString *pathToFile = [[NSBundle mainBundle] pathForResource:@"fire" ofType:@"sks"];
            SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToFile];
            
            [self.fire removeFromParent];
            
            self.fire = fire;
            self.fire.particleBirthRate = 150;
            [self addChild:self.fire];
            
            self.fire.position = self.ball.position;
            // чтобы агонь бегал за шаром
            //self.fire.targetNode = self; // какая то проблемма тут
            
            break;
        }
            
        default:
            break;
    }
    
}

#pragma mark - Init

+ (instancetype)unarchiveFromFile:(NSString *)file {
    
    // перенсли из gameviewcontroller!!!
    
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    return (GameScene *)scene;
}

#pragma mark - GameScene life cycle

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
    
    [self loadBricks];
    
    [self addHUD];
}

-(void)addHUD {
    
    if( !self.hud) {
        self.hud = [[GameHUD alloc] initWithSize:CGSizeMake(self.size.width, self.size.height/20)];
        self.hud.position = CGPointMake(self.size.width /2, self.size.height);
        [self addChild:self.hud];
    }
    
}

-(void)loadBricks {
    
    CGFloat y = CGRectGetHeight(self.frame) - 35;
    int rowsCount = 6;

    for(int i = 0; i < rowsCount; i++) {
        
        CGFloat margin = i % 2 ? 35 : 15;
        
        for( CGFloat x = margin; x < CGRectGetWidth(self.frame)-margin; x+= 40) {
            Brick *aBrick = [Brick brickAtPoint:CGPointMake(x, y)];
            [self addChild:aBrick];
        }
        
        y-=35;
    }
    
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
    ball.physicsBody.contactTestBitMask = PhysicsCategoryGameOverLine | PhysicsCategoryBrick | PhysicsCategoryBouns;  // битовая маска объектов взаимодействия - например линия выхода за пределы игрового поля
    
    ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)/4);
    
    [ball.physicsBody applyImpulse:CGVectorMake(15, -10)];
    
    ball.physicsBody.usesPreciseCollisionDetection = YES;
    
    return ball;
    
}

#pragma mark - Touches events

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
    
    self.fire.position = self.ball.position;
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
    
    [self testForGameOver:bodyA bodyB:bodyB];
    [self testForBrickCollision:bodyA bodyB:bodyB];
    [self testForGettingBonus:bodyA bodyB:bodyB];
    
}

-(void)testForBonusKill:(SKPhysicsBody *)bodyA bodyB:(SKPhysicsBody *)bodyB {
    if(PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryBall) &&
       PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryBouns)) {
        NSLog(@"show bonus kill");
        [self removeBrick:bodyB];
    }
}

-(void)testForGameOver:(SKPhysicsBody *)bodyA bodyB:(SKPhysicsBody *)bodyB {
    if(PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryBall) &&
       PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryGameOverLine)) {
        NSLog(@"show gameover");
        [self showGameOver];
    }
}

-(void)testForBrickCollision:(SKPhysicsBody *)bodyA bodyB:(SKPhysicsBody *)bodyB {
    if(PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryBall) &&
       PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryBrick)) {
        NSLog(@"show brick collision");
        
        self.hud.score += 10;

        if(self.fire) {
            // удалить несколько кирпичей рядом
            
        }
        
        [self addBonusFromPoint:bodyB.node.position];
        [self removeBrick:bodyB];
        
        
    }
}

-(void)testForGettingBonus:(SKPhysicsBody *)bodyA bodyB:(SKPhysicsBody *)bodyB {
    if(PhysicsCategoryIs(bodyA.categoryBitMask, PhysicsCategoryDesk) &&
       PhysicsCategoryIs(bodyB.categoryBitMask, PhysicsCategoryBouns)) {
        NSLog(@"show bonus");
        
        self.currentBonus = (Bonus *)bodyB.node;
        self.currentBonus.physicsBody = nil;
        
    }
}

-(void)addBonusFromPoint:(CGPoint)point {
    
    // рандом сила
    int posibility = 2;
    if( arc4random() % posibility != 0) {
        return;
    }
    
    Bonus *myBonus = [Bonus bonusOfType:BonusTypeFire];
    myBonus.position = point;
    
    [self addChild:myBonus];
    [myBonus.physicsBody applyImpulse:CGVectorMake(0, -10)];
    
}

-(void)removeBrick:(SKPhysicsBody *)brick {
    
    SKAction *fade = [SKAction fadeOutWithDuration:0.3];
    SKAction *removeFromParent = [SKAction runBlock:^{
            [brick.node removeFromParent];
        }];
    SKAction *sequence = [SKAction sequence:@[fade,removeFromParent]];
    [brick.node runAction:sequence];
}

-(void)showGameOver {
    
    SetHightScore(self.hud.hightScore);
    
    GameOverScene *scene =[[GameOverScene alloc] initWithSize:self.size victory:NO score:self.hud.score];
    
    SKTransition *transition = [SKTransition doorsCloseVerticalWithDuration:1];
    [self.view  presentScene:scene
                  transition:transition];
    
    
    
}




@end
