//
//  Options.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/20/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "Options.h"
#import "GameManager.h"
#import "SKLabelNode+CommonAnimations.h"
#import "SKLabelNode+Background.h"

@interface Options()

@property (strong, nonatomic) SKLabelNode *backToMainMenu;
@property (strong, nonatomic) SKSpriteNode *backToMainMenuBcg;
@property (strong, nonatomic) SKLabelNode *optionsTitle;

@property (strong, nonatomic) SKSpriteNode *headerBck;

// Speed option related properties

@property (strong, nonatomic) SKLabelNode *speedLabel;
@property (strong, nonatomic) SKLabelNode *speedSlowLabel;
@property (strong, nonatomic) SKLabelNode *speedNormalLabel;
@property (strong, nonatomic) SKLabelNode *speedFastLabel;

@property (strong, nonatomic) SKSpriteNode *speedSlowBcg;
@property (strong, nonatomic) SKSpriteNode *speedNormalBcg;
@property (strong, nonatomic) SKSpriteNode *speedFastBcg;

// Difficulty option related properties

@property (strong, nonatomic) SKLabelNode *difficultyLevelLabel;
@property (strong, nonatomic) SKLabelNode *difficultyLevelValueLabel;
@property (strong, nonatomic) SKLabelNode *difficultyLevelValueAdd;
@property (strong, nonatomic) SKLabelNode *difficultyLevelValueRemove;

@property (strong, nonatomic) SKSpriteNode *difficultyLevelValueAddBcg;
@property (strong, nonatomic) SKSpriteNode *difficultyLevelValueRemoveBcg;

// Level duration option related properties

@property (strong, nonatomic) SKLabelNode *durationLabel;
@property (strong, nonatomic) SKLabelNode *durationValueLabel;
@property (strong, nonatomic) SKLabelNode *durationValueAdd;
@property (strong, nonatomic) SKLabelNode *durationValueRemove;

@property (strong, nonatomic) SKSpriteNode *durationValueAddBcg;
@property (strong, nonatomic) SKSpriteNode *durationValueRemoveBcg;
@property (assign, nonatomic) NSUInteger difficultyOption;

@property (nonatomic, strong) SKVideoNode *videoBackgroundNode;
@end

@implementation Options

#pragma mark - Initialization Code

- (void)didMoveToView:(SKView *)view {
    
    self.speedLabel = (SKLabelNode *)[self childNodeWithName:@"chooseSpeed"];
    self.speedSlowLabel = (SKLabelNode *)[self childNodeWithName:@"speedSlow"];
    self.speedNormalLabel = (SKLabelNode *)[self childNodeWithName:@"speedNormal"];
    self.speedFastLabel = (SKLabelNode *)[self childNodeWithName:@"speedFast"];
    
    self.difficultyLevelLabel = (SKLabelNode *)[self childNodeWithName:@"difficultyLevel"];
    self.difficultyLevelValueLabel = (SKLabelNode *)[self childNodeWithName:@"difficultyValue"];
    self.difficultyLevelValueAdd = (SKLabelNode *)[self childNodeWithName:@"difficultyAdd"];
    self.difficultyLevelValueRemove = (SKLabelNode *)[self childNodeWithName:@"difficultyRemove"];
    
    self.durationLabel = (SKLabelNode *)[self childNodeWithName:@"durationLabel"];
    self.durationValueLabel = (SKLabelNode *)[self childNodeWithName:@"durationValue"];
    self.durationValueAdd = (SKLabelNode *)[self childNodeWithName:@"durationAdd"];
    self.durationValueRemove = (SKLabelNode *)[self childNodeWithName:@"durationRemove"];
    
    self.backToMainMenu = (SKLabelNode *)[self childNodeWithName:@"back"];
    self.optionsTitle = (SKLabelNode *)[self childNodeWithName:@"options"];
    self.headerBck = (SKSpriteNode *)[self childNodeWithName:@"headerBck"];
    
    [self prepareSpeedOption];
    [self prepareTitleAndBackToMainMenu];
    [self prepareDifficultyOption];
    [self prepareDurationOption];
    
    [self setColorsOnScreen];
    [self setupVideoBackground];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionsUpdated:) name:(NSString *)OptionsChangedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString *)OptionsChangedNotification object:nil];
}

#pragma mark - Initialization Helpers

- (void)setColorsOnScreen {
//    self.backgroundColor = [UIColor backgroundColor];
    self.headerBck.color = [UIColor optionsHeadingColor];
}

- (void)prepareSpeedOption {
    
    self.speedLabel.fontName = @"3Dventure";
    self.speedSlowLabel.fontName = @"3Dventure";
    self.speedNormalLabel.fontName = @"3Dventure";
    self.speedFastLabel.fontName = @"3Dventure";

    [self selectNewSpeedValueUI:@([[GameManager sharedManager] levelSpeedOption])];
    
    self.speedSlowBcg = [SKSpriteNode spriteNodeWithTexture:nil size:self.speedSlowLabel.frame.size];
    self.speedSlowBcg.position = self.speedSlowLabel.position;
    [self addChild:self.speedSlowBcg];
    
    self.speedNormalBcg = [SKSpriteNode spriteNodeWithTexture:nil size:self.speedNormalLabel.frame.size];
    self.speedNormalBcg.position = self.speedNormalLabel.position;
    [self addChild:self.speedNormalBcg];
    
    self.speedFastBcg = [SKSpriteNode spriteNodeWithTexture:nil size:self.speedFastLabel.frame.size];
    self.speedFastBcg.position = self.speedFastLabel.position;
    [self addChild:self.speedFastBcg];
}

- (void)prepareDifficultyOption {
    
    self.difficultyLevelLabel.fontName = @"3Dventure";
    self.difficultyLevelValueLabel.fontName = @"3Dventure";
    self.difficultyLevelValueAdd.fontName = @"3Dventure";
    self.difficultyLevelValueRemove.fontName = @"3Dventure";

    self.difficultyLevelValueLabel.text = [NSString stringWithFormat:@"%ld", [[GameManager sharedManager] difficultyOption]];
    
    self.difficultyLevelValueAddBcg = [SKSpriteNode spriteNodeWithTexture:nil size:[self.difficultyLevelValueAdd sizeWithScaleFactor:4]];
    self.difficultyLevelValueAddBcg.anchorPoint = CGPointMake(0.5, 0.5);
    self.difficultyLevelValueAddBcg.position = self.difficultyLevelValueAdd.position;
    [self addChild:self.difficultyLevelValueAddBcg];
    
    self.difficultyLevelValueRemoveBcg = [SKSpriteNode spriteNodeWithTexture:nil size:[self.difficultyLevelValueRemove sizeWithScaleFactor:4]];
    self.difficultyLevelValueRemoveBcg.anchorPoint = CGPointMake(0.5, 0.5);
    self.difficultyLevelValueRemoveBcg.position = self.difficultyLevelValueRemove.position;
    [self addChild:self.difficultyLevelValueRemoveBcg];
}

- (void)prepareDurationOption {
    
    self.durationLabel.fontName = @"3Dventure";
    self.durationValueLabel.fontName = @"3Dventure";
    self.durationValueAdd.fontName = @"3Dventure";
    self.durationValueRemove.fontName = @"3Dventure";
    
    self.durationValueLabel.text = [NSString stringWithFormat:@"%.0f", [[GameManager sharedManager] levelDurationOption]];
    
    self.durationValueAddBcg = [SKSpriteNode spriteNodeWithTexture:nil size:[self.durationValueAdd sizeWithScaleFactor:4]];
    self.durationValueAddBcg.anchorPoint = CGPointMake(0.5, 0.5);
    self.durationValueAddBcg.position = self.durationValueAdd.position;
    [self addChild:self.durationValueAddBcg];
    
    self.durationValueRemoveBcg = [SKSpriteNode spriteNodeWithTexture:nil size:[self.durationValueRemove sizeWithScaleFactor:4]];
    self.durationValueRemoveBcg.anchorPoint = CGPointMake(0.5, 0.5);
    self.durationValueRemoveBcg.position = self.durationValueRemove.position;
    [self addChild:self.durationValueRemoveBcg];
}

- (void)prepareTitleAndBackToMainMenu {
    self.backToMainMenu.fontName = @"3Dventure";
    self.optionsTitle.fontName = @"3Dventure";
    
    [self.optionsTitle stackLetterByLetterFromString:@"OPTIONS" withCompletion:nil];
    [self.backToMainMenu addBackgroundWithColor:[UIColor labelBackgroundColor] animate:NO duration:0];
    
    self.backToMainMenuBcg = [SKSpriteNode spriteNodeWithTexture:nil size:[self.backToMainMenu sizeWithScaleFactor:2.5]];
    self.backToMainMenuBcg.position = self.backToMainMenu.position;
    [self addChild:self.backToMainMenuBcg];
}

#pragma mark - Video Background

- (void)setupVideoBackground {
    self.videoBackgroundNode = [[GameManager sharedManager] videoBackgroundNode];
    self.videoBackgroundNode.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    [self addChild:self.videoBackgroundNode];
    
    for (SKNode *node in self.children) {
        if (![node isEqual:self.videoBackgroundNode]) {
            [node removeFromParent];
            [self addChild:node];
        }
    }
    
    Options __weak *weakSelf = self;
    SKAction *fadeInAction = [SKAction fadeAlphaTo:0.8 duration:0.2];
    [self.videoBackgroundNode runAction:fadeInAction completion:^{
        SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor labelBackgroundColor] colorBlendFactor:1 duration:0.8];
        [weakSelf runAction:colorizeAction];
    }];
}

#pragma mark - User Input Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touches.anyObject locationInNode:self];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    
    [self hitTestSpeedControlsWithTouchedNode:touchedNode];
    [self hitTestDifficultyControlsWithTouchedNode:touchedNode];
    [self hitTestDurationControlsWithTouchedNode:touchedNode];
    [self hitTestBackToMainMenuWithTouchedNode:touchedNode];
}

#pragma mark - User Input Helper Methods

- (void)hitTestSpeedControlsWithTouchedNode:(SKNode *)touchedNode {
    
    if ([touchedNode isEqualToNode:self.speedSlowLabel] ||
        [touchedNode isEqualToNode:self.speedSlowBcg]) {
        [[GameManager sharedManager] setLevelSpeedOption:LevelSpeedSlow];
    }
    else if ([touchedNode isEqualToNode:self.speedNormalLabel] ||
             [touchedNode isEqualToNode:self.speedNormalBcg]) {
        [[GameManager sharedManager] setLevelSpeedOption:LevelSpeedNormal];
    }
    else if ([touchedNode isEqualToNode:self.speedFastLabel] ||
             [touchedNode isEqualToNode:self.speedFastBcg]) {
        [[GameManager sharedManager] setLevelSpeedOption:LevelSpeedFast];
    }
}

- (void)hitTestDifficultyControlsWithTouchedNode:(SKNode *)touchedNode {
    
    if ([touchedNode isEqualToNode:self.difficultyLevelValueAdd] ||
        [touchedNode isEqualToNode:self.difficultyLevelValueAddBcg]) {
        [[GameManager sharedManager] makeDifficultyOptionGoUpIfPossible];
        [self.difficultyLevelValueAdd makeControlPopWithCompletion:nil];
    }
    else if ([touchedNode isEqualToNode:self.difficultyLevelValueRemove] ||
             [touchedNode isEqualToNode:self.difficultyLevelValueRemoveBcg]) {
        [[GameManager sharedManager] makeDifficultyOptionGoDownIfPossible];
        [self.difficultyLevelValueRemove makeControlPopWithCompletion:nil];
    }
}

- (void)hitTestDurationControlsWithTouchedNode:(SKNode *)touchedNode {
    
    if ([touchedNode isEqualToNode:self.durationValueAdd] ||
        [touchedNode isEqualToNode:self.durationValueAddBcg]) {
        [[GameManager sharedManager] makeDurationOptionGoUpIfPossible];
        [self.durationValueAdd makeControlPopWithCompletion:nil];
    }
    else if ([touchedNode isEqualToNode:self.durationValueRemove] ||
             [touchedNode isEqualToNode:self.durationValueRemoveBcg]) {
        [[GameManager sharedManager] makeDurationOptionGoDownIfPossible];
        [self.durationValueRemove makeControlPopWithCompletion:nil];
    }
}

- (void)hitTestBackToMainMenuWithTouchedNode:(SKNode *)touchedNode {
    Options __weak *weakSelf = self;
    
    if ([touchedNode isEqualToNode:self.backToMainMenu] ||
        [touchedNode isEqualToNode:self.backToMainMenuBcg]) {
        [self.backToMainMenu makeControlPopWithCompletion:^{
            
            SKAction *colorizeAction = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:1 duration:0.8];
            [weakSelf runAction:colorizeAction completion:^{
                
                SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
                [weakSelf.videoBackgroundNode runAction:fadeOut completion:^{
                    [weakSelf.videoBackgroundNode removeFromParent];
                    [[GameManager sharedManager] loadMainMenuScene];
                }];
            }];
        }];
    }
}

#pragma mark - UI Update

- (void)optionsUpdated:(NSNotification *)notif {
    NSString *updatedValue = [notif.userInfo valueForKey:(NSString *)OptionsChangedKey];
    
    if ([updatedValue isEqualToString:(NSString *)OptionsChangedSpeed]) {
        NSNumber *oldValue = [notif.userInfo valueForKey:(NSString *)OptionsChangedOldSpeedValue];
        NSNumber *newValue = [notif.userInfo valueForKey:(NSString *)OptionsChangedNewSpeedValue];
        [self animateSpeedValueSelectionWithOldValue:oldValue newValue:newValue];
    }
    else if ([updatedValue isEqualToString:(NSString *)OptionsChangedDifficulty]) {
        self.difficultyLevelValueLabel.text = [NSString stringWithFormat:@"%ld", [[GameManager sharedManager] difficultyOption]];
        [self.difficultyLevelValueLabel makeControlPopWithCompletion:nil];
    }
    else if ([updatedValue isEqualToString:(NSString *)OptionsChangedDuration]) {
        self.durationValueLabel.text = [NSString stringWithFormat:@"%.0f", [[GameManager sharedManager] levelDurationOption]];
        [self.durationValueLabel makeControlPopWithCompletion:nil];
    }
}

- (void)animateSpeedValueSelectionWithOldValue:(NSNumber *)oldValue newValue:(NSNumber *)newValue {
    [self deselectOldSpeedValue:oldValue];
    [self selectNewSpeedValueUI:newValue];
}

- (void)selectNewSpeedValueUI:(NSNumber *)newValue {
    switch (newValue.integerValue) {
        case LevelSpeedSlow: {
            [self.speedSlowLabel makeLabelGrowWithColor:SelectedSlowColor];
            break;
        }
        case LevelSpeedNormal: {
            [self.speedNormalLabel makeLabelGrowWithColor:SelectedNormalColor];
            break;
        }
        case LevelSpeedFast: {
            [self.speedFastLabel makeLabelGrowWithColor:SelectedFastColor];
            break;
        }
        default:
            break;
    }
}

- (void)deselectOldSpeedValue:(NSNumber *)oldValue {
    switch (oldValue.integerValue) {
        case LevelSpeedSlow: {
            [self.speedSlowLabel makeLabelShrink];
            break;
        }
        case LevelSpeedNormal: {
            [self.speedNormalLabel makeLabelShrink];
            break;
        }
        case LevelSpeedFast: {
            [self.speedFastLabel makeLabelShrink];
            break;
        }
        default:
            break;
    }
}

@end
