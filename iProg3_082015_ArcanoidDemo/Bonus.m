//
//  Bonus.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import "Bonus.h"
#import "ArcanoidConstants.h"


@implementation Bonus

-(instancetype)init {
    self = [super initWithColor:[UIColor yellowColor]
                           size:CGSizeMake(30, 30)];
    
    if(self) {
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        body.restitution = 1;
        body.linearDamping = 0;
        body.angularDamping = 0;
        body.dynamic = YES;
        body.categoryBitMask = PhysicsCategoryBouns;
        
        // от кого будет объект отскакивать - по умолчанию х32 1111....1111
        body.collisionBitMask = PhysicsCategoryBall; // не с кем не взаимодействовать, ""
        //body.contactTestBitMask = PhysicsCategoryBall;
        // "проходить сквозь стены"
        
        
        self.physicsBody = body;
        
    }
    
    return self;
}

+(instancetype)bonusOfType:(BonusType)type {
    
    NSParameterAssert(type==BonusTypeFire);
    
    Bonus *aBonus = [[self alloc]init];
    aBonus.type = type;
    
    return aBonus;
}

@end
