//
//  GameManager.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GameManager : NSObject

+ (id)sharedManager;

@property (strong, nonatomic)SKView *spriteKitView;

- (void)loadMainMenuScene;
- (void)loadLevelScene;
- (void)loadGameOverScene;
- (void)loadDynamicLevelScene;

@end
