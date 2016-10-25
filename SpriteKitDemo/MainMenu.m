//
//  MainMenu.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "MainMenu.h"
#import "GameManager.h"
#import "SKLabelNode+CommonAnimations.h"
#import "SKLabelNode+Background.h"

#define GAME_TITLE @"SpriteKit"
#define GAME_TITLE_SECOND_LINE @"DEMO"
#define MAIN_MENU_ENTRANCE_ANIMATIONS_DURATION 10
@interface MainMenu()

@property (nonatomic, strong) SKLabelNode *titleNode;
@property (nonatomic, strong) SKLabelNode *titleSecondNode;
@property (nonatomic, strong) SKLabelNode *startGameNode;
@property (nonatomic, strong) SKSpriteNode *startGameBckgNode;

@property (nonatomic, strong) SKLabelNode *optionNode;
@property (nonatomic, strong) SKSpriteNode *optionBckgNode;

@property (nonatomic, strong) SKVideoNode *videoBackgroundNode;

@property (nonatomic, strong) NSDate *entranceAnimationsStartTime;
@property (nonatomic, assign) BOOL entranceAnimationsAlreadySkipped;
@end

@implementation MainMenu

#pragma mark - Initialization Code

-(void)didMoveToView:(SKView *)view {
    self.titleNode = (SKLabelNode *)[self childNodeWithName:@"gameTitle"];
    self.titleSecondNode = (SKLabelNode *)[self childNodeWithName:@"gameTitleSecond"];
    
    self.startGameNode = (SKLabelNode *)[self childNodeWithName:@"startGameNode"];
    self.startGameBckgNode = (SKSpriteNode *)[self childNodeWithName:@"startGameBckgNode"];
    self.optionNode = (SKLabelNode *)[self childNodeWithName:@"optionNode"];
    self.optionBckgNode = (SKSpriteNode *)[self childNodeWithName:@"optionBckgNode"];
    
    self.titleNode.fontName = @"3Dventure";
    self.titleSecondNode.fontName = @"3Dventure";
    self.startGameNode.fontName = @"3Dventure";
    self.optionNode.fontName = @"3Dventure";
    
    [self setupVideoBackground];
    
    if (self.enableEntranceAnimations) {
        [self executeGameTitleAnimation];
    } else {
        [self presentControlsWithNoAnimation];
    }
}

#pragma mark - User Input

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    MainMenu __weak  *weakSelf = self;
    
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    
    if ([touchedNode isEqualToNode:self.startGameNode] ||
        [touchedNode isEqualToNode:self.startGameBckgNode]) {
        [self.startGameNode makeControlPopWithCompletion:^{
            [[GameManager sharedManager] loadDynamicLevelScene];
        }];
    }
    else if ([touchedNode isEqualToNode:self.optionNode] ||
             [touchedNode isEqualToNode:self.optionBckgNode]) {
        [self.optionNode makeControlPopWithCompletion:^{
            
            SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:1 duration:0.8];
            [weakSelf runAction:colorizeAction completion:^{
                
                SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
                [weakSelf.videoBackgroundNode runAction:fadeOut completion:^{
                    [weakSelf.videoBackgroundNode removeFromParent];
                    [[GameManager sharedManager] loadOptionsScene];
                }];
            }];
        }];
    } else {
        [self handleAnimationsSkipTouch];
    }
}

- (void)handleAnimationsSkipTouch {
    NSDate *now = [NSDate date];
    BOOL nowIsBeforeEntranceAnimationsAreCompleted =
    [now timeIntervalSinceDate:self.entranceAnimationsStartTime] < MAIN_MENU_ENTRANCE_ANIMATIONS_DURATION;
    
    if (nowIsBeforeEntranceAnimationsAreCompleted && !self.entranceAnimationsAlreadySkipped) {
        
        self.entranceAnimationsAlreadySkipped = YES;
        
        [self flashScreenWithCompletion:^{
            [self presentControlsWithNoAnimation];
        }];
    }
}

#pragma mark - Video Background

- (void)setupVideoBackground {
    self.videoBackgroundNode = [[GameManager sharedManager] videoBackgroundNode];
    self.videoBackgroundNode.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    [self addChild:self.videoBackgroundNode];
    
    [self.titleNode removeFromParent];
    [self addChild:self.titleNode];
    
    [self.titleSecondNode removeFromParent];
    [self addChild:self.titleSecondNode];
}

#pragma mark - Animations

- (void)presentControlsWithNoAnimation {
    
    for (SKNode *node in self.children) {
        [node removeAllActions];
    }
    self.titleNode.text = GAME_TITLE;
    self.titleNode.position = CGPointMake(0, 407.6879);
    self.titleNode.xScale = self.titleNode.yScale = 1.305;
    self.titleSecondNode.text = GAME_TITLE_SECOND_LINE;
    self.titleSecondNode.alpha = 1;
    self.titleSecondNode.position = CGPointMake(0, 200);
    [self showControls];
}

- (void)executeGameTitleAnimation {
    MainMenu __weak *weakSelf = self;

    self.entranceAnimationsStartTime = [NSDate date];
    
    [self.titleNode stackLetterByLetterFromString:GAME_TITLE withCompletion:^{
        [weakSelf scaleUpAndMoveDownGameTitleWithCompletion:^{
            [weakSelf presentSecondLineWithCompletionWithCompletion:^{
                [weakSelf flashScreenWithCompletion:^{
                    [weakSelf showControls];
                }];
            }];
        }];
    }];
}

- (void)scaleUpAndMoveDownGameTitleWithCompletion:(void (^)())completionBlock {
    SKAction *moveDownAction = [SKAction moveByX:0 y:-100 duration:0.4];
    SKAction *scaleUpAction = [SKAction scaleBy:1.45 duration:0.4];
    
    SKAction *growGroup = [SKAction group:@[moveDownAction, scaleUpAction]];
    
    SKAction *waitAction = [SKAction waitForDuration:0.1];
    SKAction *scaleDownAction = [SKAction scaleBy:0.9 duration:0.1];
    
    [self.titleNode runAction:[SKAction sequence:@[growGroup, waitAction, scaleDownAction]] completion:completionBlock];
}

- (void)presentSecondLineWithCompletionWithCompletion:(void (^)())completionBlock {

    self.titleSecondNode.text = GAME_TITLE_SECOND_LINE;
    
    SKAction *moveUp = [SKAction moveByX:0 y:200 duration:1];
    SKAction *fadeIn = [SKAction fadeInWithDuration:1];
    
    [self.titleSecondNode runAction:[SKAction group:@[moveUp, fadeIn]] completion:completionBlock];
}

- (void)flashScreenWithCompletion:(void (^)())completionBlock {
    SKSpriteNode *flashNode = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:self.frame.size];
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.3];
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.3];
    SKAction *removeAction = [SKAction removeFromParent];
    
    [self addChild:flashNode];
    [flashNode runAction:[SKAction sequence:@[fadeInAction, fadeOutAction, removeAction]] completion:completionBlock];
}

- (void)showControlsWithCompletion:(void (^)())completionBlock {
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.8];
    [self.startGameNode runAction:fadeInAction completion:^{
        [self.startGameNode addBackgroundWithColor:[UIColor labelBackgroundColor] animate:YES duration:1];
        if (completionBlock) {
            completionBlock();
        }
    }];
    
    [self.optionNode runAction:fadeInAction completion:^{
        [self.optionNode addBackgroundWithColor:[UIColor labelBackgroundColor] animate:YES duration:1];
    }];
}

- (void)showControls {
    MainMenu __weak *weakSelf = self;
    [weakSelf showControlsWithCompletion:^{
        
        [weakSelf.videoBackgroundNode setPaused:NO];
        
        SKAction *fadeInVideo = [SKAction fadeAlphaTo:0.8 duration:2];
        [weakSelf.videoBackgroundNode runAction:fadeInVideo completion:^{
            
            SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor labelBackgroundColor] colorBlendFactor:1 duration:0.8];
            [weakSelf runAction:colorizeAction];
        }];
        
    }];
}
@end
