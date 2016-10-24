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

@interface MainMenu()

@property (nonatomic, strong) SKLabelNode *titleNode;
@property (nonatomic, strong) SKLabelNode *titleSecondNode;
@property (nonatomic, strong) SKLabelNode *startGameNode;
@property (nonatomic, strong) SKSpriteNode *startGameBckgNode;

@property (nonatomic, strong) SKLabelNode *optionNode;
@property (nonatomic, strong) SKSpriteNode *optionBckgNode;

@property (nonatomic, strong) SKVideoNode *videoBackgroundNode;
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
    
    [self executeGameTitleAnimation];
}

#pragma mark - User Input

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
            [[GameManager sharedManager] loadOptionsScene];
        }];
    }
}

#pragma mark - Video Background

- (void)setupVideoBackground {
    self.videoBackgroundNode = [SKVideoNode videoNodeWithVideoFileNamed:@"planetEarthSpinning.mp4"];
    self.videoBackgroundNode.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    self.videoBackgroundNode.zRotation =  - M_PI_2;
    [self addChild:self.videoBackgroundNode];
    self.videoBackgroundNode.alpha = 0;
    self.videoBackgroundNode.paused = YES;
    
    [self.titleNode removeFromParent];
    [self addChild:self.titleNode];
    
    [self.titleSecondNode removeFromParent];
    [self addChild:self.titleSecondNode];
}

#pragma mark - Animations

- (void)executeGameTitleAnimation {
    MainMenu __weak *weakSelf = self;

    [self setupVideoBackground];
    
    [self.titleNode stackLetterByLetterFromString:GAME_TITLE withCompletion:^{
        [weakSelf scaleUpAndMoveDownGameTitleWithCompletion:^{
            [weakSelf presentSecondLineWithCompletionWithCompletion:^{
                [weakSelf flashScreenWithCompletion:^{
                    [weakSelf showControlsWithCompletion:^{
                        
                        [weakSelf.videoBackgroundNode setPaused:NO];
                        
                        SKAction *fadeInVideo = [SKAction fadeAlphaTo:0.8 duration:2];
                        [weakSelf.videoBackgroundNode runAction:fadeInVideo completion:^{
                            
                            SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor labelBackgroundColor] colorBlendFactor:1 duration:0.8];
                            [weakSelf runAction:colorizeAction];
                        }];
                        
                    }];
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
@end
