//
//  DynamicLevelScene.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/17/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "DynamicLevelScene.h"

#define SINGLE_BLOCK_FLAG @1
#define NO_BLOCK_FLAG @0
#define DYNAMIC_BLOCK_FLAG @2

NSUInteger const ObstacleFreeZone = 220;

static NSUInteger const MainCharacterBitMask    = 0b01;
static NSUInteger const BlocksBitMask           = 0b10;

@interface DynamicLevelScene()

// properties
@property (nonatomic, assign) CGFloat levelLength;
@property (nonatomic, assign) LevelSpeed levelSpeed;
@property (assign, nonatomic) NSUInteger fillProbability;

// important nodes
@property (strong, nonatomic) SKSpriteNode *rootNode;
@property (strong, nonatomic) SKNode *cameraNode;
@property (assign, nonatomic) CGFloat blockSize;

// characters, enemies, points
@property (strong, nonatomic) SKSpriteNode *mainCharacter;
@end

@implementation DynamicLevelScene

#pragma mark - Initialization Code

- (instancetype)initWithSceneSize:(CGSize)size levelLength:(CGFloat)levelLength levelSpeed:(LevelSpeed)speed levelDificulty:(NSUInteger)dificultyLevel {
    self = [super initWithSize:size];
    if (self) {
        self.levelLength = levelLength;
        self.levelSpeed = speed;
        self.blockSize = self.size.width / 10.;
        self.fillProbability = dificultyLevel;
        [self createLevelRootNode];
        [self createCameraNode];
        [self generateStaticBlockObtacles];
        
        [self mainCharacter];
        self.mainCharacter.position = CGPointMake(140, 600);

        DynamicLevelScene __weak *weakSelf = self;
        [self beginStartCountDownWithCompletion:^{
            [weakSelf beginAnimation];
        }];
        self.backgroundColor = [UIColor colorWithRed:92/255. green:147/255. blue:252/255. alpha:1];
    }
    return self;
}

- (void)beginStartCountDownWithCompletion:(void (^)())completionBlock {
    
    // initializing labelNode
    SKLabelNode *countDownLabel = [SKLabelNode labelNodeWithFontNamed:@"3Dventure"];
    countDownLabel.text = @"3";
    countDownLabel.position = CGPointMake(self.frame.size.width / 2., self.frame.size.height * 8. / 10.);
    countDownLabel.fontSize = 125;
    
    // setting up actions
    SKAction *waitAction = [SKAction waitForDuration:1];
    SKAction *scaleDownAction = [SKAction scaleTo:0 duration:0.5];
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.5];
    SKAction *groupActions = [SKAction group:@[scaleDownAction, fadeOutAction]];
    
    [countDownLabel runAction:[SKAction sequence:@[waitAction, groupActions]] completion:^{
        
        countDownLabel.text = @"2";
        countDownLabel.xScale = countDownLabel.yScale = 1;
        countDownLabel.alpha = 1;
        
        [countDownLabel runAction:[SKAction sequence:@[waitAction, groupActions]] completion:^{
            
            countDownLabel.text = @"1";
            countDownLabel.xScale = countDownLabel.yScale = 1;
            countDownLabel.alpha = 1;
            
            [countDownLabel runAction:[SKAction sequence:@[waitAction, groupActions]] completion:^{
                
                countDownLabel.text = @"START!";
                countDownLabel.xScale = countDownLabel.yScale = 1;
                countDownLabel.alpha = 1;
                countDownLabel.fontSize = 80;
                [countDownLabel runAction:[SKAction sequence:@[waitAction, fadeOutAction]] completion:^{
                    [countDownLabel removeFromParent];
                    if (completionBlock) {
                        completionBlock();
                    }
                }];
            }];
        }];
    }];
    
    [self addChild:countDownLabel];
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

    NSArray<NSNumber *> *randomlyPopulatedAvailabillityOfBlocksOnVerticalRows = [self randomlyPopulateStaticBlocksForVerticalNumberOfRows:verticalRows];
    
    for (NSUInteger verRow = 0; verRow < randomlyPopulatedAvailabillityOfBlocksOnVerticalRows.count - 1; verRow++) {
        if (!randomlyPopulatedAvailabillityOfBlocksOnVerticalRows[verRow].boolValue) {
            continue;
        }
        
        NSArray<NSNumber *> *randomlyPopulatedAvailabillityOfBlocksOnHorizontalRows =  [self randomlyPopulateStaticBlocksForHorizontalNumberOfRows:horizontalRows];
        for (NSUInteger horRow = 0; horRow < randomlyPopulatedAvailabillityOfBlocksOnHorizontalRows.count; horRow++) {
            if ([randomlyPopulatedAvailabillityOfBlocksOnHorizontalRows[horRow] isEqualToNumber:SINGLE_BLOCK_FLAG]) {
                [self drawStaticBlockAtVerticalRow:verRow horizontalRow:horRow blockIsDynamic:NO];
            }
            else if ([randomlyPopulatedAvailabillityOfBlocksOnHorizontalRows[horRow] isEqualToNumber:DYNAMIC_BLOCK_FLAG]) {
                [self drawStaticBlockAtVerticalRow:verRow horizontalRow:horRow blockIsDynamic:YES];
            }
        }
    }
    
    // Last Line handling
    for (NSUInteger horRow = 0; horRow < horizontalRows.integerValue; horRow++) {
            [self drawStaticBlockAtVerticalRow:verticalRows.integerValue - 1 horizontalRow:horRow blockIsDynamic:NO];
    }
}

- (NSArray<NSNumber *> *)randomlyPopulateStaticBlocksForVerticalNumberOfRows:(NSNumber *)rows {
    NSMutableArray<NSNumber *> *result = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < rows.integerValue - 5; i++) {
        
        // the posibillity of adding a block is 7/2
        uint32_t shouldAddBlock = arc4random_uniform(10);
        BOOL shouldAddBlockOnGivenPlace = shouldAddBlock >= 1 && shouldAddBlock <= 7;
        
            if (i % 2 == 0) {
                if (shouldAddBlockOnGivenPlace) {
                    [result addObject:@YES];
                } else {
                    [result addObject:@NO];
                }
            } else {
                [result addObject:@NO];
            }
        
    }
    [result addObject:@NO];
    [result addObject:@NO];
    [result addObject:@NO];
    [result addObject:@NO];
    [result addObject:@YES];
    
    return [NSArray arrayWithArray:result];
}

- (NSArray<NSNumber *> *)randomlyPopulateStaticBlocksForHorizontalNumberOfRows:(NSNumber *)rows {
    NSMutableArray<NSNumber *> *result = [NSMutableArray new];
    
    BOOL thereIsAtLeastOneHole = NO;
    for (NSUInteger i = 0; i < rows.integerValue; i++) {
        
        // the posibillity of adding a block is 7/2
        uint32_t shouldAddBlock = arc4random_uniform(10);
        BOOL shouldAddBlockOnGivenPlace = shouldAddBlock <= self.fillProbability;
        
        if (shouldAddBlockOnGivenPlace) {
            [result addObject:SINGLE_BLOCK_FLAG];
        } else {
            [result addObject:NO_BLOCK_FLAG];
            thereIsAtLeastOneHole = YES;
        }
        
    }
    
    // check and clear random block if all spaces are filled
    if (!thereIsAtLeastOneHole) {
        uint32_t placeToClearBlock = arc4random_uniform((uint32_t)result.count);
        [result replaceObjectAtIndex:placeToClearBlock withObject:@NO];
    } else {
        NSNumber *blockForMoving = [self findSingleBlockAppropriateForMovingFrom:result];
        if (blockForMoving) {
            [result replaceObjectAtIndex:blockForMoving.integerValue withObject:DYNAMIC_BLOCK_FLAG];
        }
    }
    
    return [NSArray arrayWithArray:result];
}

- (NSNumber *)findSingleBlockAppropriateForMovingFrom:(NSArray<NSNumber *> *)blocks {
    
    for (NSUInteger i = 1; i + 1 < blocks.count; i++) {
        // search for  - + - , where "-" - no block, "+" - block
        if (!blocks[i - 1].boolValue && blocks[i].boolValue && !blocks[i + 1].boolValue) {
            return @(i);
        }
    }
    return nil;
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

- (void)drawStaticBlockAtVerticalRow:(NSUInteger)verRow horizontalRow:(NSUInteger)horRow blockIsDynamic:(BOOL)blockIsDynamic {
    //    NSLog(@"drawing block at ver:%ld hor:%ld", verRow, horRow);
    
    SKShapeNode *shape = [self grassBlockShapeNode];
    shape.position = [self coordinatesOfVerticalRow:verRow horizontalRow:horRow];
    
    if (blockIsDynamic) {
        SKAction *moveToLeftStartingPositionAction = [SKAction moveByX:-shape.frame.size.width*0.95 y:0 duration:0.5];
        
        SKAction *waitAction = [SKAction waitForDuration:1];
        SKAction *moveRightAction = [SKAction moveByX:2 * shape.frame.size.width*0.95 y:0 duration:0.5];
        SKAction *moveLeftAction = [SKAction moveByX:-2 * shape.frame.size.width*0.95 y:0 duration:0.5];
        
        SKAction *wholeMovingAnimation = [SKAction sequence:@[waitAction, moveRightAction, waitAction, moveLeftAction]];
        
        [shape runAction:[SKAction sequence:@[moveToLeftStartingPositionAction, [SKAction repeatActionForever:wholeMovingAnimation]]]];
    }
    
    
    SKPhysicsBody *physics = [SKPhysicsBody bodyWithTexture:shape.fillTexture size:shape.frame.size];
    physics.categoryBitMask = BlocksBitMask;
    physics.contactTestBitMask = MainCharacterBitMask;
    physics.collisionBitMask = MainCharacterBitMask;
    physics.dynamic = NO;
    shape.physicsBody = physics;
    
    [self.rootNode addChild:shape];
}

- (SKShapeNode *)grassBlockShapeNode {
    SKTexture *blockTexture = [SKTexture textureWithImageNamed:@"grassPlatform"];
    SKShapeNode *shape = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.blockSize, self.blockSize) cornerRadius:self.blockSize / 4];
    shape.fillTexture = blockTexture;
    shape.fillColor = [UIColor whiteColor];
    return shape;
}

- (CGPoint)coordinatesOfVerticalRow:(NSUInteger)verRow horizontalRow:(NSUInteger)horRow {
    CGFloat xCoordinate = horRow * self.blockSize + self.blockSize / 2.;
    CGFloat yCoordinate = self.frame.size.height - self.blockSize - verRow * self.blockSize - ObstacleFreeZone + self.blockSize / 2.;
    return CGPointMake(xCoordinate, yCoordinate);
}

- (void) centerOnCameraNode {
    CGPoint cameraPositionInScene = [self.cameraNode.scene convertPoint:self.cameraNode.position fromNode:self.cameraNode.parent];
    self.cameraNode.parent.position = CGPointMake(self.cameraNode.parent.position.x - cameraPositionInScene.x, self.cameraNode.parent.position.y - cameraPositionInScene.y);
}

#pragma mark - Main Loop callbacks

- (void)didFinishUpdate {
    [self centerOnCameraNode];
}

#pragma mark - Main Character

- (SKSpriteNode *)mainCharacter {
    if (_mainCharacter) {
        return _mainCharacter;
    }
    SKTexture *standTexture = [SKTexture textureWithImageNamed:@"stand"];
    CGSize characterSize = CGSizeMake(self.blockSize, self.blockSize);
    _mainCharacter = [SKSpriteNode spriteNodeWithTexture:standTexture size:characterSize];
    [self addChild:_mainCharacter];
//    _mainCharacter.anchorPoint = CGPointZero;
    _mainCharacter.yScale =_mainCharacter.xScale = 1.2;
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.blockSize * 0.4, self.blockSize * 0.7)];
    physicsBody.categoryBitMask = MainCharacterBitMask;
    physicsBody.collisionBitMask = BlocksBitMask;
    physicsBody.contactTestBitMask = BlocksBitMask;
    physicsBody.affectedByGravity = YES;
    physicsBody.allowsRotation = NO;
    _mainCharacter.physicsBody = physicsBody;
    return _mainCharacter;
}

- (void)mainCharacterAnimateWalkLeft {
    [self mainCharacterAnimateWalkLeftDirection:YES];
}

- (void)mainCharacterAnimateWalkRight {
    [self mainCharacterAnimateWalkLeftDirection:NO];
}

- (void)mainCharacterAnimateWalkLeftDirection:(BOOL)leftDirection {
    SKSpriteNode *character = [self mainCharacter];
    
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

@end
