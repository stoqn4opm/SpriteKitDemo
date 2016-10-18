//
//  DynamicLevelScene.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/17/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, LevelSpeed) {
    LevelSpeedSlow,
    LevelSpeedNormal,
    LevelSpeedFast
};

@interface DynamicLevelScene : SKScene
- (instancetype)initWithSceneSize:(CGSize)size levelLength:(CGFloat)levelLength levelSpeed:(LevelSpeed)speed;

@end
