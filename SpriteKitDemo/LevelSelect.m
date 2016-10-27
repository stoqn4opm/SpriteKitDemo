//
//  LevelSelect.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/25/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "LevelSelect.h"
#import "LevelEntryRowNode.h"

@interface LevelSelect()

@property (strong, nonatomic) LevelEntryRowNode *firstLevelNode;
@property (strong, nonatomic) LevelEntryRowNode *secondLevelNode;

@end

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
    self.firstLevelNode = (LevelEntryRowNode *)[self childNodeWithName:@"levelEntyRowNode1"];
    [self.firstLevelNode configureWithNumberEntry:@1 textEntry:@"Static"];
    
    self.secondLevelNode = (LevelEntryRowNode *)[self childNodeWithName:@"levelEntyRowNode2"];
    [self.secondLevelNode configureWithNumberEntry:@2 textEntry:@"Dynamic"];
}

#pragma mark - User Input

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    
    [self hitTestNodes:@[self.firstLevelNode] withTouchedNode:touchedNode withYESHandler:^{
        [[GameManager sharedManager] loadSimpleLevelScene];
    }];
    [self hitTestNodes:@[self.secondLevelNode] withTouchedNode:touchedNode withYESHandler:^{
        [[GameManager sharedManager] loadDynamicLevelScene];
    }];
}

@end
