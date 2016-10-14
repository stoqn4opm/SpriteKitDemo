//
//  MainMenu.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "MainMenu.h"
#import "GameManager.h"

@interface MainMenu()

@property (nonatomic, strong) SKSpriteNode *titleNode;
@property (nonatomic, strong) SKSpriteNode *startGameNode;
@property (nonatomic, strong) SKSpriteNode *flashNode;
@property (nonatomic, strong) SKSpriteNode *startGameBckgNode;

@end

@implementation MainMenu

-(void)didMoveToView:(SKView *)view {
    self.titleNode = (SKSpriteNode *)[self childNodeWithName:@"titleNode"];
    self.flashNode = (SKSpriteNode *)[self childNodeWithName:@"flashNode"];
    
    self.startGameNode = (SKSpriteNode *)[self childNodeWithName:@"startGameNode"];
    self.startGameBckgNode = (SKSpriteNode *)[self childNodeWithName:@"startGameBckgNode"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    
    if ([touchedNode isEqualToNode:self.startGameNode] ||
        [touchedNode isEqualToNode:self.startGameBckgNode]) {
        [[GameManager sharedManager] loadLevelScene];
    } else {
        SKAction *fadeInAction = [SKAction fadeInWithDuration:0.5];
        SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.5];
        [self.flashNode runAction:[SKAction sequence:@[fadeInAction, fadeOutAction]]];
    }
}

@end
