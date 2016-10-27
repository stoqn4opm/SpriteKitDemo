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

@property (nonatomic, strong) NSDate *entranceAnimationsStartTime;
@property (nonatomic, assign) BOOL entranceAnimationsAlreadySkipped;
@property (nonatomic, assign) BOOL screenAlreadyFlashed;
@end

@implementation MainMenu

#pragma mark - Initialization Code

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
   
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
    
    if (self.enableEntranceAnimations) {
        [self executeGameTitleAnimation];
    } else {
        [self presentControlsWithNoAnimation];
    }
}

#pragma mark - User Input

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!self.entranceAnimationsAlreadySkipped) {
        
        NSDate *now = [NSDate date];
        BOOL nowIsBeforeEntranceAnimationsAreCompleted =
        [now timeIntervalSinceDate:self.entranceAnimationsStartTime] < MAIN_MENU_ENTRANCE_ANIMATIONS_DURATION;
        
        if (nowIsBeforeEntranceAnimationsAreCompleted) {
            [self handleAnimationsSkipTouch];
            return;
        }
    }
    
    MainMenu __weak  *weakSelf = self;
    
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    
    [self hitTestNodes:@[self.startGameNode, self.startGameBckgNode] withTouchedNode:touchedNode withYESHandler:^{
        [weakSelf.startGameNode makeControlPopWithCompletion:^{
            [weakSelf fadeOutVideoBackgroundWithCompletion:^{
                [weakSelf.videoBackgroundNode removeFromParent];
                [[GameManager sharedManager] loadLevelSelectScene];
            }];
        }];
    }];
    
    [self hitTestNodes:@[self.optionNode, self.optionBckgNode] withTouchedNode:touchedNode withYESHandler:^{
        [self.optionNode makeControlPopWithCompletion:^{
            [weakSelf fadeOutVideoBackgroundWithCompletion:^{
                [weakSelf.videoBackgroundNode removeFromParent];
                [[GameManager sharedManager] loadOptionsScene];
            }];
        }];
    }];
}

- (void)handleAnimationsSkipTouch {
        
    self.entranceAnimationsAlreadySkipped = YES;
    
    [self flashScreenWithCompletion:^{
        [self presentControlsWithNoAnimation];
    }];
}

#pragma mark - Animations

- (void)executeGameTitleAnimation {
    MainMenu __weak *weakSelf = self;

    self.entranceAnimationsStartTime = [NSDate date];
    
    [self.titleNode stackLetterByLetterFromString:GAME_TITLE withCompletion:^{
        [weakSelf scaleUpAndMoveDownGameTitleWithCompletion:^{
            [weakSelf presentSecondLineWithCompletionWithCompletion:^{
                self.entranceAnimationsAlreadySkipped = YES;
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
    if (self.screenAlreadyFlashed) {
        return;
    }
    
    self.screenAlreadyFlashed = YES;
    SKAction *colorizeToWhite = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1 duration:0.3];
    SKAction *colorizeToBlack = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:1 duration:0.3];
    SKAction *flash = [SKAction sequence:@[colorizeToWhite, colorizeToBlack]];
    
    [self runAction:flash completion:completionBlock];
}

- (void)showControls {
    MainMenu __weak *weakSelf = self;
    
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.8];
    [self.startGameNode runAction:fadeInAction completion:^{
        [self.startGameNode addBackgroundWithColor:[UIColor labelBackgroundColor] animate:YES duration:1];
         [weakSelf fadeInVideoBackgroundWithCompletion:nil];
    }];
    
    [self.optionNode runAction:fadeInAction completion:^{
        [self.optionNode addBackgroundWithColor:[UIColor labelBackgroundColor] animate:YES duration:1];
    }];
    
        self.titleNode.alpha = 1;
        self.titleSecondNode.alpha = 1;
}

- (void)presentControlsWithNoAnimation {
    
    for (SKNode *node in self.children) {
        [node removeAllActions];
    }
    self.titleNode.text = GAME_TITLE;
    self.titleNode.position = CGPointMake(0, 407.6879);
    self.titleNode.xScale = self.titleNode.yScale = 1.305;
    self.titleSecondNode.text = GAME_TITLE_SECOND_LINE;
    self.titleSecondNode.position = CGPointMake(0, 200);
    SKAction *fadeInAction = [SKAction fadeInWithDuration:0.8];
    [self.titleNode runAction:fadeInAction];
    [self.titleSecondNode runAction:fadeInAction];

    [self showControls];
}

@end
