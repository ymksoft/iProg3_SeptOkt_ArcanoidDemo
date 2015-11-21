//
//  Brick.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "Brick.h"
#import "ArcanoidConstants.h"

@implementation Brick

+(instancetype)brickAtPoint:(CGPoint)point {
    
    Brick *brick = [self spriteNodeWithImageNamed:@"brick"];
    
    SKPhysicsBody *brickBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.size];
    brickBody.dynamic = 0;  // для ракетки было бы не плохо 1 поставить )) если 0 - то бесконечно большая масса
    brickBody.friction = 0;
    brickBody.restitution = 1;  // отпружинивание
    brickBody.linearDamping = 0;
    brickBody.angularDamping = 0;
    brickBody.allowsRotation = NO;
    brickBody.affectedByGravity = 0;
    
    brickBody.categoryBitMask = PhysicsCategoryBrick;
    
    
    brick.physicsBody = brickBody;
    brick.position = point;
    
    brick.name = @"brick";
    
    return brick;
    
}

@end
