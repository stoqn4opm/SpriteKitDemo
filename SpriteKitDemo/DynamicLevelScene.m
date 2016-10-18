//
//  DynamicLevelScene.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/17/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "DynamicLevelScene.h"

NSUInteger const ObstacleFreeZone = 220;


@interface DynamicLevelScene()

@property (nonatomic, assign) CGFloat levelLength;
@property (nonatomic, assign) LevelSpeed levelSpeed;

@property (strong, nonatomic) SKSpriteNode *rootNode;
@property (strong, nonatomic) SKNode *cameraNode;
@property (assign, nonatomic) CGFloat blockSize;
@end

@implementation DynamicLevelScene

#pragma mark - Initialization Code

- (void)didMoveToView:(SKView *)view {
    
}

- (instancetype)initWithSceneSize:(CGSize)size levelLength:(CGFloat)levelLength levelSpeed:(LevelSpeed)speed {
    self = [super initWithSize:size];
    if (self) {
        self.levelLength = levelLength;
        self.levelSpeed = speed;
        self.blockSize = self.size.width / 10.;
        [self createLevelRootNode];
        [self createCameraNode];
        [self generateStaticBlockObtacles];
        [self beginAnimation];
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)beginAnimation {
    CGFloat moveDownAmmount = self.rootNode.size.height - self.frame.size.height;
    SKAction *moveDown = [SKAction moveByX:0 y:-moveDownAmmount duration:self.levelLength];
    [self.cameraNode runAction:moveDown];
}

- (void)createLevelRootNode {
    
    CGFloat multiplier;
    switch (self.levelSpeed) {
        case LevelSpeedSlow:
            multiplier = 1.5;
            break;
        case LevelSpeedNormal:
            multiplier = 2;
            break;
        case LevelSpeedFast:
            multiplier = 2.5;
            break;
            default:
            multiplier = 2;
    }
    
    CGFloat height = self.levelLength * multiplier * self.blockSize + ObstacleFreeZone;
    self.rootNode = [SKSpriteNode spriteNodeWithTexture:nil size:CGSizeMake(self.size.width, height)];
    [self addChild:self.rootNode];
}

- (void)createCameraNode {
    self.cameraNode = [SKCameraNode new];
    [self.rootNode addChild:self.cameraNode];
}

#pragma mark - Static Blocks Generation

- (void)generateStaticBlockObtacles {
    NSDictionary *playableAreaRows = [self getPlayableAreaNumberOfRows];
    
    if (!playableAreaRows) {
        return;
    }
    
    NSNumber *horizontalRows = [playableAreaRows valueForKey:@"horRows"];
    NSNumber *verticalRows = [playableAreaRows valueForKey:@"verRows"];

    NSArray<NSNumber *> *randomlyPopulatedAvailabillityOfBlocksOnVerticalRows = [self randomlyPopulateStaticBlocksForNumberOfRows:verticalRows evenOnly:YES];
    
    for (NSUInteger verRow = 0; verRow < randomlyPopulatedAvailabillityOfBlocksOnVerticalRows.count; verRow++) {
        if (!randomlyPopulatedAvailabillityOfBlocksOnVerticalRows[verRow].boolValue) {
            continue;
        }
        NSArray<NSNumber *> *randomlyPopulatedAvailabillityOfBlocksOnHorizontalRows = [self randomlyPopulateStaticBlocksForNumberOfRows:horizontalRows evenOnly:NO];
        for (NSUInteger horRow = 0; horRow < randomlyPopulatedAvailabillityOfBlocksOnHorizontalRows.count; horRow++) {
            if (randomlyPopulatedAvailabillityOfBlocksOnHorizontalRows[horRow].integerValue) {
                [self drawStaticBlockAtVerticalRow:verRow horizontalRow:horRow];
            }
        }
    }
}

- (NSArray<NSNumber *> *)randomlyPopulateStaticBlocksForNumberOfRows:(NSNumber *)rows evenOnly:(BOOL)evensOnly {
    NSMutableArray<NSNumber *> *result = [NSMutableArray new];
    for (NSUInteger i = 0; i < rows.integerValue; i++) {
        
        // the posibillity of adding a block is 7/2
        uint32_t shouldAddBlock = arc4random_uniform(10);
        BOOL shouldAddBlockOnGivenPlace = YES;// shouldAddBlock >= 1 && shouldAddBlock <= 7;
        
        if (evensOnly) {
            if (i % 2 == 0) {
                if (shouldAddBlockOnGivenPlace) {
                    [result addObject:@YES];
                } else {
                    [result addObject:@NO];
                }
            } else {
                [result addObject:@NO];
            }
        } else {
            if (shouldAddBlockOnGivenPlace) {
                [result addObject:@YES];
            } else {
                [result addObject:@NO];
            }
        }
        
    }
    return [NSArray arrayWithArray:result];
}

#pragma mark - Helper Methods

- (NSDictionary *)getPlayableAreaNumberOfRows {
    CGFloat gameFieldHeight = self.rootNode.size.height - ObstacleFreeZone;
    CGFloat gameFieldWidth = self.rootNode.size.width;
    
    CGFloat gameFieldNumberOfVerticalRows = gameFieldHeight / self.blockSize;
    CGFloat gameFieldNumberOfHorizontalRows = gameFieldWidth / self.blockSize;
    
    if (gameFieldNumberOfVerticalRows <= 1 || gameFieldNumberOfHorizontalRows <= 1) {
        NSLog(@"Number of rows of atleast one dimension is <= 1");
        return nil;
    }
    return @{@"horRows" : @(gameFieldNumberOfHorizontalRows),
             @"verRows" : @(gameFieldNumberOfVerticalRows)};
}

- (void)drawStaticBlockAtVerticalRow:(NSUInteger)verRow horizontalRow:(NSUInteger)horRow {
    
    NSLog(@"drawing block at ver:%ld hor:%ld", verRow, horRow);
    SKTexture *blockTexture = [SKTexture textureWithImageNamed:@"block"];
    SKSpriteNode *staticBlock = [SKSpriteNode spriteNodeWithTexture:blockTexture size:CGSizeMake(self.blockSize, self.blockSize)];
    staticBlock.anchorPoint = CGPointMake(0, 0);
    staticBlock.position = CGPointMake(horRow * self.blockSize, self.frame.size.height - self.blockSize - verRow * self.blockSize - ObstacleFreeZone);
    
    [self.rootNode addChild:staticBlock];
}


- (void)didFinishUpdate {
    [self centerOnCameraNode];
}

- (void) centerOnCameraNode {
    CGPoint cameraPositionInScene = [self.cameraNode.scene convertPoint:self.cameraNode.position fromNode:self.cameraNode.parent];
    self.cameraNode.parent.position = CGPointMake(self.cameraNode.parent.position.x - cameraPositionInScene.x, self.cameraNode.parent.position.y - cameraPositionInScene.y);
}

@end
