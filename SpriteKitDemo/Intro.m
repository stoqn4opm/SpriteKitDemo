//
//  Intro.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/25/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "Intro.h"
#import <SpriteKit/SpriteKit.h>
#import "SKLabelNode+Background.h"
#import "UIColor+AppColors.h"
#import "GameManager.h"

@interface Intro()

@property (nonatomic, strong) SKLabelNode *continueNode;
@property (nonatomic, strong) SKSpriteNode *continueNodeBck;

@end

@implementation Intro

#pragma mark - Initialization Code

- (void)didMoveToView:(SKView *)view {
    self.continueNode = (SKLabelNode *)[self childNodeWithName:@"continueNode"];
    
    self.continueNodeBck = [SKSpriteNode spriteNodeWithTexture:nil size:[self.continueNode sizeWithScaleFactor:2]];
    self.continueNodeBck.position = self.continueNode.position;
    
    SKAction *initialWait = [SKAction waitForDuration:15];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
    SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
    
    SKAction *sequence = [SKAction repeatActionForever:[SKAction sequence:@[fadeIn, wait, fadeOut]]];
    
    [self.continueNode runAction:[SKAction sequence:@[initialWait, sequence]]];
}

#pragma mark - User Input Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    
    if ([touchedNode isEqualToNode:self.continueNode] ||
        [touchedNode isEqualToNode:self.continueNodeBck]) {
        [[GameManager sharedManager] loadMainMenuSceneWithEntranceAnimationsEnabled:YES];
    }
}

@end
