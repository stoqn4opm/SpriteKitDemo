//
//  GameManager.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

extern uint32_t const MainCharacterBitMask;
extern uint32_t const BlocksBitMask;

@interface GameManager : NSObject

+ (id)sharedManager;

@property (strong, nonatomic)SKView *spriteKitView;

- (void)loadMainMenuScene;
- (void)loadLevelScene;
- (void)loadGameOverScene;
- (void)loadDynamicLevelScene;

- (SKSpriteNode *)mainCharacterWithSize:(CGSize)size;
- (void)mainCharacter:(SKSpriteNode *)character animateWalkLeftNotRightDirection:(BOOL)leftDirection;
- (void)moveMainCharacter:(SKSpriteNode *)mainCharacter ToTouch:(UITouch *)touch;

@end
