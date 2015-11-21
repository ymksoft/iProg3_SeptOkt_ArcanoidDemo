//
//  ArcanoidConstants.h
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ArcanoidConstants_h
#define ArcanoidConstants_h

typedef NS_OPTIONS(uint32_t, PhysicsCategory) {
        PhysicsCategoryBall         = 1,
        PhysicsCategoryGameOverLine = 1 << 1,
        PhysicsCategoryDesk         = 1 << 2,
        PhysicsCategoryBrick        = 1 << 3,
        PhysicsCategoryBouns        = 1 << 4
        
};

BOOL PhysicsCategoryIs(PhysicsCategory categoryToTest, PhysicsCategory refCategory);
void SetHightScore(long newHightScore);

extern NSString * const kArcanoidGameSceneName;
extern NSString * const kHightScoreKey;
extern NSInteger hightScore;


#endif /* ArcanoidConstants_h */
