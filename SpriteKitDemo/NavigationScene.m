//
//  NavigationScene.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/26/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "NavigationScene.h"

@implementation NavigationScene

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self prepareTitle];
    [self prepareBackToMainMenu];
    [self fadeInVideoBackgroundWithCompletion:nil];
}

#pragma mark - Title & Back

- (void)prepareTitle {
    [self placeBackgroundNodeWithColor:[UIColor optionsHeadingColor] position:CGPointMake(0, 570)];
    [self placeTitleLabelWithName:@"SceneTitleLabel" text:self.title fontSize:self.fontSize position:CGPointMake(0, 507)];
}

- (void)prepareBackToMainMenu {
    [self placeBackgroundNodeWithColor:[UIColor optionsHeadingColor] position:CGPointMake(0, -617)];
     SKLabelNode *back = [self placeTitleLabelWithName:@"BackLabel" text:@"Back To Main Menu" fontSize:60 position:CGPointMake(0, -617)];
    
    [back addBackgroundWithColor:[UIColor labelBackgroundColor] animate:NO duration:0];
    
    SKSpriteNode *backToMainMenuBcg = [SKSpriteNode spriteNodeWithTexture:nil size:[back sizeWithScaleFactor:2.5]];
    backToMainMenuBcg.position = back.position;
    backToMainMenuBcg.name = @"BackLabelBckg";
    [self addChild:backToMainMenuBcg];
}

#pragma mark - Helpers

- (SKLabelNode *)placeTitleLabelWithName:(NSString *)name text:(NSString *)text fontSize:(NSUInteger)fontSize position:(CGPoint)position {
    SKLabelNode *sceneTitle = [SKLabelNode labelNodeWithText:text];
    sceneTitle.fontName = @"3Dventure";
    sceneTitle.fontSize = fontSize;
    sceneTitle.position = position;
    sceneTitle.name = name;
    [self addChild:sceneTitle];
    return sceneTitle;
}

- (void)placeBackgroundNodeWithColor:(UIColor *)color position:(CGPoint)position {
    SKSpriteNode *header = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(760, 195)];
    header.position = position;
    header.alpha = 0.3;
    
    [self addChild:header];
}

#pragma mark - User Input

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    [self hitTestBackToMainMenuWithTouchedNode:touchedNode];
}

- (void)hitTestBackToMainMenuWithTouchedNode:(SKNode *)touchedNode {
    NavigationScene __weak *weakSelf = self;
    
    SKLabelNode *back = (SKLabelNode *)[self childNodeWithName:@"BackLabel"];
    SKSpriteNode *backBck = (SKSpriteNode *)[self childNodeWithName:@"BackLabelBckg"];
    
    if ([touchedNode isEqualToNode:back] ||
        [touchedNode isEqualToNode:backBck]) {
        [back makeControlPopWithCompletion:^{
            
            SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:1 duration:0.8];
            [weakSelf runAction:colorizeAction completion:^{
                
                SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
                [weakSelf.videoBackgroundNode runAction:fadeOut completion:^{
                    [weakSelf.videoBackgroundNode removeFromParent];
                    [[GameManager sharedManager] loadMainMenuSceneWithEntranceAnimationsEnabled:NO];
                }];
            }];
        }];
    }
}

@end
