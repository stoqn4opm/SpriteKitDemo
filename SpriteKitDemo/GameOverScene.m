//
//  GameOverScene.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "GameOverScene.h"

@interface GameOverScene()

@property (strong, nonatomic) SKSpriteNode *gameOver;
@end

@implementation GameOverScene

- (void)didMoveToView:(SKView *)view {
    self.gameOver = (SKSpriteNode *)[self childNodeWithName:@"gameOver"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:2];
    [self.gameOver runAction:fadeOutAction completion:^{
        
    }];
}

@end
