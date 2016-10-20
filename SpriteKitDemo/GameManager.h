//
//  GameManager.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, LevelSpeed) {
    LevelSpeedSlow,
    LevelSpeedNormal,
    LevelSpeedFast
};

extern uint32_t const MainCharacterBitMask;
extern uint32_t const BlocksBitMask;
extern NSString const * OptionsChangedNotification;

@interface GameManager : NSObject

+ (id)sharedManager;

#pragma mark - Properties

@property (strong, nonatomic)SKView *spriteKitView;
- (CGSize)screenSize;

#pragma mark - Loading Scenes

- (void)loadMainMenuScene;
- (void)loadLevelScene;
- (void)loadGameOverScene;
- (void)loadDynamicLevelScene;
- (void)loadOptionsScene;

#pragma mark - Options

@property (assign, nonatomic) LevelSpeed levelSpeedOption;
@property (assign, nonatomic) NSUInteger difficultyOption; // from 1 to 10
@property (assign, nonatomic) CGFloat levelDurationOption;

- (void)makeDifficultyOptionGoUpIfPossible;
- (void)makeDifficultyOptionGoDownIfPossible;
- (void)makeDurationOptionGoUpIfPossible;
- (void)makeDurationOptionGoDownIfPossible;

#pragma mark - Main Character

- (SKSpriteNode *)mainCharacterWithSize:(CGSize)size;
- (void)mainCharacter:(SKSpriteNode *)character animateWalkLeftNotRightDirection:(BOOL)leftDirection;
- (void)moveMainCharacter:(SKSpriteNode *)mainCharacter ToTouch:(UITouch *)touch;

@end
