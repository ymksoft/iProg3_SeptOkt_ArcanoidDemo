//
//  ArcanoidConstants.m
//  iProg3_082015_ArcanoidDemo
//
//  Created by Юрий Куприянов on 21.11.15.
//  Copyright © 2015 Nikolay Shubenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ArcanoidConstants.h"

NSString * const kArcanoidGameSceneName = @"GameScene";
NSString * const kHightScoreKey = @"hightScores";
NSInteger hightScore = 0;

BOOL PhysicsCategoryIs(PhysicsCategory categoryToTest, PhysicsCategory refCategory) {
    return (categoryToTest == refCategory);
}

void SetHightScore(long newHightScore) {
    if( hightScore != newHightScore) {
        hightScore = newHightScore;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@(hightScore) forKey:kHightScoreKey];
    }
}