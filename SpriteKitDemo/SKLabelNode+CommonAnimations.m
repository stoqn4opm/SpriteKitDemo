//
//  SKNode+CommonAnimations.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/20/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "SKLabelNode+CommonAnimations.h"
#import "UIColor+AppColors.h"

@implementation SKLabelNode (CommonAnimations)

- (void)makeLabelGrowWithColor:(UIColor *)color {
    [self removeAllActions];
    
    SKAction *scaleUp = [SKAction scaleTo:2 duration:0.1];
    SKAction *colorize = [SKAction runBlock:^{
        self.fontColor = color;
    }];
    [self runAction:[SKAction group:@[scaleUp, colorize]]];
}

- (void)makeLabelShrink {
    [self removeAllActions];
    SKAction *scaleDown = [SKAction scaleTo:1 duration:0.1];
    SKAction *colorize = [SKAction runBlock:^{
        self.fontColor = NonSelectedColor;
    }];
    [self runAction:[SKAction group:@[scaleDown, colorize]]];
}

- (void)makeControlPopWithCompletion:(void (^)())completionBlock {
    [self removeAllActions];
    SKAction *scaleUp = [SKAction scaleTo:1.5 duration:0.05];
    SKAction *wait = [SKAction waitForDuration:0.2];
    SKAction *scaleDown = [SKAction scaleTo:1 duration:0.2];
    
    [self runAction:[SKAction sequence:@[scaleUp, wait, scaleDown]] completion:completionBlock];
}

- (void)stackLetterByLetterFromString:(NSString *)string withCompletion:(void (^)())completionblock {
    
    SKAction *waitAction = [SKAction waitForDuration:0.2];
    NSMutableArray<SKAction *> *actions = [NSMutableArray new];
    
    SKLabelNode __weak *weakSelf = self;
    for (NSUInteger i = 0; i < string.length; i++) {
        NSString *currentSubString = [string substringToIndex:i + 1];
        
        SKAction *addSubstringAction = [SKAction runBlock:^{
            weakSelf.text = currentSubString;
        }];
        [actions addObject:addSubstringAction];
        [actions addObject:waitAction];
    }
    
    [self runAction:[SKAction sequence:actions] completion:completionblock];
}


@end
