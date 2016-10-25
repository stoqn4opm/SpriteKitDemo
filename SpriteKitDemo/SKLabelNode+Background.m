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

- (void)addBackgroundWithColor:(UIColor *)color animate:(BOOL)shouldAnimate duration:(NSTimeInterval)duration {
    SKNode *parent = self.parent;
    [self removeFromParent];
    
    SKShapeNode *startGameBckg = [SKShapeNode node];
//    startGameBckg.anchorPoint = CGPointMake(0.485, 0.2);
    startGameBckg.path = [self paralelogramPathForBackground];
    startGameBckg.position = CGPointMake(self.position.x + 0, self.position.y - 20);
    startGameBckg.fillColor = color;
    startGameBckg.strokeColor = color;
    [parent addChild:startGameBckg];
    [parent addChild:self];
    if (shouldAnimate) {
        startGameBckg.alpha = 0;
        [startGameBckg runAction:[SKAction fadeInWithDuration:duration]];
    }
    
//    CGPathCloseSubpath(p);
    
//    SKShapeNode *shape = [SKShapeNode node];
//    shape.path = [self paralelogramPathForBackground];
//    shape.fillColor = [UIColor redColor];
//    shape.strokeColor = [UIColor redColor];
//    [self addChild:shape];
}

- (CGSize)sizeWithScaleFactor:(CGFloat)factor {
    return CGSizeMake(self.frame.size.width * factor, self.frame.size.height * factor);
}

- (CGMutablePathRef)paralelogramPathForBackground {
    CGMutablePathRef p = CGPathCreateMutable();
    
    CGFloat deltaUpperPointsXStretch = 30;
    CGFloat deltaUpperPointsYPushDown = self.frame.size.height / 2.75;
    
    CGPoint firstPoint = CGPointMake(- self.frame.size.width / 2, 0);
    CGPoint secondPoint = CGPointMake(self.frame.size.width / 2, 0);
    CGPoint thirdPoint = CGPointMake(self.frame.size.width / 2  + deltaUpperPointsXStretch, self.frame.size.height - deltaUpperPointsYPushDown);
    CGPoint fourthPoint = CGPointMake(- self.frame.size.width / 2 - deltaUpperPointsXStretch, self.frame.size.height - deltaUpperPointsYPushDown);
    
    CGPathMoveToPoint(p, NULL, firstPoint.x, firstPoint.y);
    CGPathAddLineToPoint(p, NULL, secondPoint.x, secondPoint.y);
    CGPathAddLineToPoint(p, NULL, thirdPoint.x, thirdPoint.y);
    CGPathAddLineToPoint(p, NULL, fourthPoint.x, fourthPoint.y);
    
    return p;
}

@end
