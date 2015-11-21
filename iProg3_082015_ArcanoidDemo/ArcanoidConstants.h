//
//  ArcanoidConstants.h
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#ifndef ArcanoidConstants_h
#define ArcanoidConstants_h

typedef NS_OPTIONS(uint32_t, PhysicsCategory) {
        PhysicsCategoryBall         = 1,
        PhysicsCategoryGameOverLine = 1 << 1,
        PhysicsCategoryDesk         = 1 << 2
        
};

BOOL PhysicsCategoryIs(PhysicsCategory categoryToTest, PhysicsCategory refCategory) {
    return (categoryToTest == refCategory);
}

#endif /* ArcanoidConstants_h */
