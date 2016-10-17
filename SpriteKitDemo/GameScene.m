//
//  GameScene.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "GameScene.h"
#import "GameManager.h"

static const NSInteger SpikeHitCategory     = 0b1;
static const NSInteger PlayerHitCategory    = 0b10;
static const NSInteger LevelEndCategory     = 0b100;

static const NSInteger LevelTimeLength = 10; // in seconds

@interface GameScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKSpriteNode *backgroundNode;
@property (strong, nonatomic) SKSpriteNode *player;
@property (strong, nonatomic) SKSpriteNode *swipeControl;
@property (strong, nonatomic) SKSpriteNode *swipeIcon;
@property (strong, nonatomic) SKLabelNode *swipeStartLabel;

@property (strong, nonatomic) SKSpriteNode *topSpikes;
@property (strong, nonatomic) SKSpriteNode *bottomSpikes;

@property (strong, nonatomic) SKSpriteNode *endLabel;
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
    
    self.topSpikes = (SKSpriteNode *)[self childNodeWithName:@"topSpikes"];
    self.bottomSpikes = (SKSpriteNode *)[self childNodeWithName:@"bottomSpikes"];

    self.endLabel = (SKSpriteNode *)[self.endLabel childNodeWithName:@"end"];
    
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.contactDelegate = self;
    
    [self setupCollisionDetection];
}

#pragma mark - Collision Detecting

- (void)setupCollisionDetection {
    self.player.physicsBody.categoryBitMask = PlayerHitCategory;
    self.player.physicsBody.contactTestBitMask = SpikeHitCategory | LevelEndCategory;
    self.player.physicsBody.collisionBitMask = SpikeHitCategory | LevelEndCategory;
    
    self.bottomSpikes.physicsBody.categoryBitMask = SpikeHitCategory;
    self.bottomSpikes.physicsBody.contactTestBitMask = PlayerHitCategory;
    self.bottomSpikes.physicsBody.collisionBitMask = PlayerHitCategory;
    
    self.topSpikes.physicsBody.categoryBitMask = SpikeHitCategory;
    self.topSpikes.physicsBody.contactTestBitMask = PlayerHitCategory;
    self.topSpikes.physicsBody.collisionBitMask = PlayerHitCategory;
    
    self.endLabel.physicsBody.categoryBitMask = LevelEndCategory;
    self.endLabel.physicsBody.contactTestBitMask = PlayerHitCategory;
    self.endLabel.physicsBody.collisionBitMask = PlayerHitCategory;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody = contact.bodyA;
    SKPhysicsBody *secondBody = contact.bodyB;
    
    if(firstBody.categoryBitMask == SpikeHitCategory || secondBody.categoryBitMask == SpikeHitCategory) {
        [self stopLevel];
        [self blinkPlayerWithCompletion:^{
            [[GameManager sharedManager] loadGameOverScene];
        }];
    }
    else if (firstBody.categoryBitMask == LevelEndCategory || secondBody.categoryBitMask == LevelEndCategory) {
        [[GameManager sharedManager] loadMainMenuScene];
    }
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

- (void)blinkPlayerWithCompletion:(void (^)())completionBlock {
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.1];
    SKAction *waitAction = [SKAction waitForDuration:0.5];
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.1];
    SKAction *blinkAnimation = [SKAction sequence:@[fadeOutAction, waitAction, fadeInAction, waitAction]];

    [self.player runAction:[SKAction repeatAction:blinkAnimation count:4] completion:completionBlock];
}

- (void)startLevel {
    
    GameScene __weak *weakSelf = self;
    SKAction *waitAction = [SKAction waitForDuration:2];
    SKAction *moveDownAction = [SKAction moveToY:1540 duration:LevelTimeLength];
    [self.backgroundNode runAction:[SKAction sequence:@[waitAction, moveDownAction]] completion:^{
        
        SKAction *waitToHideBottomSpikes = [SKAction waitForDuration:LevelTimeLength - 1];
        SKAction *hideDown = [SKAction moveByX:0 y:-200 duration:1];
        [weakSelf.bottomSpikes runAction:[SKAction sequence:@[waitToHideBottomSpikes, hideDown]]];
    }];
    
    [self.player runAction:waitAction completion:^{
        weakSelf.player.physicsBody.affectedByGravity = YES;
        weakSelf.player.physicsBody.dynamic = YES;
        _gameIsStarted = YES;
    }];
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
    [self.swipeStartLabel runAction:fadeOut];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:1];
    [self.swipeIcon runAction:fadeIn];
    
}

- (void)stopLevel {
    [self.backgroundNode removeAllActions];
    self.player.physicsBody.affectedByGravity = NO;
    self.player.physicsBody.dynamic = NO;
    _gameIsStarted = NO;
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
