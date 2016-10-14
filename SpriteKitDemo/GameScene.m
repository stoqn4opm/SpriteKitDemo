//
//  GameScene.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()

@property (nonatomic, strong) SKSpriteNode *backgroundNode;
@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) SKSpriteNode *swipeControl;
@property (strong, nonatomic) SKSpriteNode *swipeIcon;
@property (strong, nonatomic) SKLabelNode *swipeStartLabel;

@end

@implementation GameScene {
    BOOL __block _gameIsStarted;
}

#pragma mark - Scene Setup

- (void)didMoveToView:(SKView *)view {
    self.backgroundNode = (SKSpriteNode *)[self childNodeWithName:@"scrollingBackground"];
    self.player = (SKSpriteNode *)[self childNodeWithName:@"player"];
    self.swipeControl = (SKSpriteNode *)[self childNodeWithName:@"swipeControl"];
    self.swipeIcon = (SKSpriteNode *)[self.swipeControl childNodeWithName:@"swipeIcon"];
    self.swipeStartLabel = (SKLabelNode *)[self.swipeControl childNodeWithName:@"gameStart"];
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self isTouchInSwipeControl:touches.anyObject]) {
        [self startLevel];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self isTouchInSwipeControl:touches.anyObject] && _gameIsStarted) {
        UITouch *singleTouch = touches.anyObject;
        CGPoint coordinates = [singleTouch locationInNode:self];
        SKAction *moveAction = [SKAction moveToX:coordinates.x duration:0.1];
        [self.player runAction:moveAction];
    }
}

#pragma mark - Helper Methods

- (void)startLevel {
    
    SKAction *waitAction = [SKAction waitForDuration:2];
    SKAction *moveDownAction = [SKAction moveToY:1540 duration:10];
    [self.backgroundNode runAction:[SKAction sequence:@[waitAction, moveDownAction]]];
    
    GameScene __weak *weakSelf = self;
    [self.player runAction:waitAction completion:^{
        weakSelf.player.physicsBody.affectedByGravity = YES;
        _gameIsStarted = YES;
    }];
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
    [self.swipeStartLabel runAction:fadeOut];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:1];
    [self.swipeIcon runAction:fadeIn];
}

- (BOOL)isTouchInSwipeControl:(UITouch *)touch {
    CGPoint locationInScene = [touch locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:locationInScene];
    return [touchedNode.parent isEqualToNode:self.swipeControl] || [touchedNode isEqualToNode:self.swipeControl];
}

#pragma mark - Frame Update Callback

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
