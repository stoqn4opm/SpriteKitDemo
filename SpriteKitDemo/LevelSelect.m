//
//  LevelSelect.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/25/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "LevelSelect.h"
#import "LevelEntryRowNode.h"

@implementation LevelSelect

#pragma mark - Initialization

- (void)didMoveToView:(SKView *)view {
    self.title = @"LEVEL SELECT";
    self.fontSize = 90;
    [super didMoveToView:view];
    
    [self setupLevelListBackground];
    [self setupLevelListEntries];
}

- (void)setupLevelListBackground {
    SKSpriteNode *levelListBackground = (SKSpriteNode *)[self childNodeWithName:@"levelListBackground"];
    levelListBackground.color = [UIColor levelListBackgroundColor];
    levelListBackground.alpha = 0.6;
}

- (void)setupLevelListEntries {
    LevelEntryRowNode *firstLevelEntryNode = (LevelEntryRowNode *)[self childNodeWithName:@"levelEntyRowNode1"];
    [firstLevelEntryNode configureWithNumberEntry:@1 textEntry:@"Static"];
    
    LevelEntryRowNode *secondLevelEntryNode = (LevelEntryRowNode *)[self childNodeWithName:@"levelEntyRowNode2"];
    [secondLevelEntryNode configureWithNumberEntry:@2 textEntry:@"Dynamic"];
}

#pragma mark - User Input

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    
    [self hitTestFirstEntryWithTouchedNode:touchedNode];
    [self hitSecondEntryWithTouchedNode:touchedNode];
}

- (void)hitTestFirstEntryWithTouchedNode:(SKNode *)node {
    LevelEntryRowNode *firstLevelEntryNode = (LevelEntryRowNode *)[self childNodeWithName:@"levelEntyRowNode1"];
    if ([self isNode:node equalToNodeOrSomeChild:firstLevelEntryNode]) {
        [[GameManager sharedManager] loadSimpleLevelScene];
    }
}

- (void)hitSecondEntryWithTouchedNode:(SKNode *)node {
    LevelEntryRowNode *secondLevelEntryNode = (LevelEntryRowNode *)[self childNodeWithName:@"levelEntyRowNode2"];
    if ([self isNode:node equalToNodeOrSomeChild:secondLevelEntryNode]) {
        [[GameManager sharedManager] loadDynamicLevelScene];
    }
}

#pragma mark - Helper Methods

- (BOOL)isNode:(SKNode *)firstNode equalToNodeOrSomeChild:(SKNode *)secondNode {
    if ([firstNode isEqualToNode:secondNode]) {
        return YES;
    }
    
    for (SKNode *child in secondNode.children) {
        if ([firstNode isEqualToNode:child]) {
            return YES;
        }
    }
    return NO;
}

@end
