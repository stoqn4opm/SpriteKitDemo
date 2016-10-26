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
#import "MainMenu.h"

uint32_t const MainCharacterBitMask    = 0b01;
uint32_t const BlocksBitMask           = 0b10;

NSString const * OptionsChangedNotification = @"optionsChanged";

NSString const * OptionsChangedKey = @"optionsChangedKey";
NSString const * OptionsChangedDifficulty = @"optionsChangedDiff";
NSString const * OptionsChangedSpeed = @"optionsChangedSpeed";
NSString const * OptionsChangedOldSpeedValue = @"optionsChangedSpeedOld";
NSString const * OptionsChangedNewSpeedValue = @"optionsChangedSpeedNew";
NSString const * OptionsChangedDuration = @"optionsChangedDuration";

@interface GameManager()

@property (strong, nonatomic) SKVideoNode *videoBackgroundNode;

@end

@implementation GameManager

+ (id)sharedManager {
    static GameManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
        // option defaults
        sharedMyManager.difficultyOption = 5;
        sharedMyManager.levelDurationOption = 60;
    });
    return sharedMyManager;
}

- (void)setSpriteKitView:(SKView *)spriteKitView {
    spriteKitView.showsFPS = YES;
    spriteKitView.showsNodeCount = YES;
    spriteKitView.showsPhysics = YES;
    
    _spriteKitView = spriteKitView;
}

- (CGSize)screenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size;
}

#pragma mark - Levels Loading

- (void)loadIntroScene {
    SKScene *introScene = [SKScene nodeWithFileNamed:@"Intro"];
    [self loadScene:introScene];
}

- (void)loadSimpleLevelScene {
    SKScene *gameScene = [SKScene nodeWithFileNamed:@"GameScene"];
    [self loadScene:gameScene];
}

- (void)loadGameOverScene {
    SKScene *gameOverScene = [SKScene nodeWithFileNamed:@"GameOverScene"];
    [self loadScene:gameOverScene];
}

- (void)loadLevelSelectScene {
    SKScene *levelSelectScene = [SKScene nodeWithFileNamed:@"LevelSelect"];
    [self loadScene:levelSelectScene];
}

- (void)loadMainMenuSceneWithEntranceAnimationsEnabled:(BOOL)animationsEnabled {
    MainMenu *gameScene = (MainMenu *)[SKScene nodeWithFileNamed:@"MainMenu"];
    gameScene.enableEntranceAnimations = animationsEnabled;
    [self loadScene:gameScene];
}

- (void)loadDynamicLevelScene {
    
    DynamicLevelScene *dLevel = [[DynamicLevelScene alloc] initWithSceneSize:[self screenSize] levelLength:self.levelDurationOption levelSpeed:self.levelSpeedOption levelDificulty:self.difficultyOption];
    [self loadScene:dLevel];
}

- (void)loadOptionsScene {
    SKScene *options = [SKScene nodeWithFileNamed:@"Options"];
    [self loadScene:options];
}

- (void)loadScene:(SKScene *)scene {
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition fadeWithColor:[UIColor blackColor] duration:0.5];
    [self.spriteKitView presentScene:scene transition:transition];
}

#pragma mark - Video Background

- (SKVideoNode *)videoBackgroundNode {
    if (_videoBackgroundNode) {
        return _videoBackgroundNode;
    }
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    _videoBackgroundNode = [SKVideoNode videoNodeWithVideoFileNamed:@"planetEarthSpinning.mp4"];
    _videoBackgroundNode.size = CGSizeMake(screenSize.height, screenSize.width);
    _videoBackgroundNode.zRotation =  - M_PI_2;
    
    _videoBackgroundNode.alpha = 0;
    _videoBackgroundNode.paused = YES;
    
    return _videoBackgroundNode;
}

- (void)playVideoBackgroundIfNeeded {
    _videoBackgroundNode.paused = NO;
}

#pragma mark - Options Setting

- (void)setLevelSpeedOption:(LevelSpeed)levelSpeedOption {
    if (_levelSpeedOption != levelSpeedOption) {
        NSNumber *oldValue = @(_levelSpeedOption);
        _levelSpeedOption = levelSpeedOption;
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)OptionsChangedNotification object:nil userInfo:@{OptionsChangedKey : OptionsChangedSpeed,
                                                                                                                                OptionsChangedOldSpeedValue : oldValue,
                                                                                                                                OptionsChangedNewSpeedValue : @(_levelSpeedOption)}];
    }
}

- (void)makeDifficultyOptionGoUpIfPossible {
    if (self.difficultyOption < 9) {
        self.difficultyOption++;
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)OptionsChangedNotification object:nil userInfo:@{OptionsChangedKey : OptionsChangedDifficulty}];
    }
}

- (void)makeDifficultyOptionGoDownIfPossible {
    if (self.difficultyOption > 1) {
        self.difficultyOption--;
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)OptionsChangedNotification object:nil userInfo:@{OptionsChangedKey : OptionsChangedDifficulty}];
    }
}

- (void)makeDurationOptionGoUpIfPossible {
    if (self.levelDurationOption < 90) {
        self.levelDurationOption+=30;
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)OptionsChangedNotification object:nil userInfo:@{OptionsChangedKey : OptionsChangedDuration}];
    }
}

- (void)makeDurationOptionGoDownIfPossible {
    if (self.levelDurationOption > 30) {
        self.levelDurationOption-=30;
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)OptionsChangedNotification object:nil userInfo:@{OptionsChangedKey : OptionsChangedDuration}];
    }
}

#pragma mark - Main Character

- (SKSpriteNode *)mainCharacterWithSize:(CGSize)size {
    
    SKTexture *standTexture = [SKTexture textureWithImageNamed:@"stand"];
    SKSpriteNode *mainCharacter = [SKSpriteNode spriteNodeWithTexture:standTexture size:size];
    //    _mainCharacter.anchorPoint = CGPointZero;
    mainCharacter.yScale = mainCharacter.xScale = 1.2;
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(size.width * 0.4, size.height * 0.7)];
    physicsBody.categoryBitMask = MainCharacterBitMask;
    physicsBody.collisionBitMask = BlocksBitMask;
    physicsBody.contactTestBitMask = BlocksBitMask;
    physicsBody.affectedByGravity = YES;
    physicsBody.allowsRotation = NO;
    mainCharacter.physicsBody = physicsBody;
    return mainCharacter;
}

- (void)mainCharacter:(SKSpriteNode *)character animateWalkLeftNotRightDirection:(BOOL)leftDirection {

    [character removeAllActions];
    NSArray<NSString *> *textureNames = leftDirection ? @[@"left1", @"left2", @"left3", @"left4"] : @[@"right1", @"right2", @"right3", @"right4"];
    
    SKAction *leftMove1 = [SKAction runBlock:^{
        character.texture = [SKTexture textureWithImageNamed:textureNames[0]];
    }];
    SKAction *leftMove2 = [SKAction runBlock:^{
        character.texture = [SKTexture textureWithImageNamed:textureNames[1]];
    }];
    SKAction *leftMove3 = [SKAction runBlock:^{
        character.texture = [SKTexture textureWithImageNamed:textureNames[2]];
    }];
    SKAction *leftMove4 = [SKAction runBlock:^{
        character.texture = [SKTexture textureWithImageNamed:textureNames[3]];
    }];
    SKAction *waitAction = [SKAction waitForDuration:0.15];
    SKAction *wholeAnimation = [SKAction sequence:@[leftMove1, waitAction, leftMove2, waitAction, leftMove3, waitAction, leftMove4, waitAction]];
    SKAction *repeatWholeAnimationAction = [SKAction repeatActionForever:wholeAnimation];
    [character runAction:repeatWholeAnimationAction];
}

- (void)moveMainCharacter:(SKSpriteNode *)mainCharacter ToTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInNode:self.spriteKitView.scene];
    BOOL shouldAnimateLeft = touchLocation.x < mainCharacter.frame.origin.x;
    [self mainCharacter:mainCharacter animateWalkLeftNotRightDirection:shouldAnimateLeft];
    
    CGFloat walkDuration = fabs(touchLocation.x - mainCharacter.frame.origin.x);
    [mainCharacter runAction:[SKAction moveToX:touchLocation.x duration:walkDuration * 0.008] completion:^{
        [mainCharacter removeAllActions];
    }];
}

@end
