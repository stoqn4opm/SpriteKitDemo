//
//  GameManager.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "GameManager.h"
#import "GameScene.h"
#import "DynamicLevelScene.h"

@implementation GameManager

+ (id)sharedManager {
    static GameManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)setSpriteKitView:(SKView *)spriteKitView {
    spriteKitView.showsFPS = YES;
    spriteKitView.showsNodeCount = YES;
    _spriteKitView = spriteKitView;
}

#pragma mark - Levels Loading

- (void)loadLevelScene {
    [self loadSceneWithName:@"GameScene"];
}

- (void)loadGameOverScene {
    [self loadSceneWithName:@"GameOverScene"];
}

- (void)loadMainMenuScene {
    [self loadSceneWithName:@"MainMenu"];
}

- (void)loadDynamicLevelScene {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    DynamicLevelScene *dLevel = [[DynamicLevelScene alloc] initWithSceneSize:CGSizeMake(screenRect.size.width, screenRect.size.height)  levelLength:12 levelSpeed:LevelSpeedFast levelDificulty:6];
    [self.spriteKitView presentScene:dLevel];
    dLevel.scaleMode = SKSceneScaleModeAspectFit;
}

- (void)loadSceneWithName:(NSString *)sceneName {
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:sceneName];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.spriteKitView presentScene:scene];
}

@end
