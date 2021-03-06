//
//  RootNavigatonScene.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/26/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "RootNavigationScene.h"

@implementation RootNavigationScene

- (void)didMoveToView:(SKView *)view {
    [self setupVideoBackground];
    for (SKNode *node in self.children) {
        if (![node isEqualToNode:self.videoBackgroundNode]) {
            [node removeFromParent];
            [self addChild:node];
        }
    }
}

#pragma mark - User Input Handling

- (void)hitTestNodes:(NSArray<SKNode *> *)entries withTouchedNode:(SKNode *)node withYESHandler:(void (^)())completionBlock {
    
    for (SKNode *currentNode in entries) {
        if ([self isNode:node equalToNodeOrSomeChild:currentNode]) {
            if (completionBlock) {
                completionBlock();
            }
            return;
        }
    }
}

- (BOOL)isNode:(SKNode *)firstNode equalToNodeOrSomeChild:(SKNode *)secondNode {
    if ([firstNode isEqualToNode:secondNode]) {
        return YES;
    }
    
    for (SKNode *child in secondNode.children) {
        if ([firstNode isEqualToNode:child]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Video Background

- (void)setupVideoBackground {
    self.videoBackgroundNode = [[GameManager sharedManager] videoBackgroundNode];
    self.videoBackgroundNode.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    [self addChild:self.videoBackgroundNode];
}

- (void)fadeOutVideoBackgroundWithCompletion:(void (^)())completionBlock {
    
    RootNavigationScene __weak *weakSelf = self;
    
    SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:1 duration:0.8];
    [self runAction:colorizeAction completion:^{
        
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
        [weakSelf.videoBackgroundNode runAction:fadeOut completion:^{
            if (completionBlock) {
                completionBlock();
            }
        }];
    }];
}

- (void)fadeInVideoBackgroundWithCompletion:(void (^)())completionBlock {
    RootNavigationScene __weak *weakSelf = self;
    
    [self.videoBackgroundNode setPaused:NO];
    
    SKAction *fadeInVideo = [SKAction fadeAlphaTo:0.8 duration:2];
    [self.videoBackgroundNode runAction:fadeInVideo completion:^{
        
        SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor labelBackgroundColor] colorBlendFactor:1 duration:0.8];
        [weakSelf runAction:colorizeAction];
    }];
}

@end
