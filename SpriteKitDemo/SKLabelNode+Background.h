//
//  SKLabelNode+Background.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/24/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKLabelNode (Background)
- (void)addBackgroundWithColor:(UIColor *)color;
- (CGSize)sizeWithScaleFactor:(CGFloat)factor;
@end
