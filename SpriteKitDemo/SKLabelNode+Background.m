//
//  SKLabelNode+Background.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/24/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "SKLabelNode+Background.h"
#import "UIColor+AppColors.h"

@implementation SKLabelNode (Background)

- (void)addBackgroundWithColor:(UIColor *)color {
    SKNode *parent = self.parent;
    [self removeFromParent];
    
    SKSpriteNode *startGameBckg = [SKSpriteNode spriteNodeWithColor:color size:self.frame.size];
    startGameBckg.anchorPoint = CGPointMake(0.485, 0.2);
    startGameBckg.position = self.position;
    
    [parent addChild:startGameBckg];
    [parent addChild:self];
}

- (CGSize)sizeWithScaleFactor:(CGFloat)factor {
    return CGSizeMake(self.frame.size.width * factor, self.frame.size.height * factor);
}

@end
