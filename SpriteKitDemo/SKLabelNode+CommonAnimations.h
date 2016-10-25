//
//  SKNode+CommonAnimations.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/20/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKLabelNode (CommonAnimations)

- (void)makeLabelGrowWithColor:(UIColor *)color;
- (void)makeLabelShrink;
- (void)makeControlPopWithCompletion:(void (^)())completionBlock;
- (void)stackLetterByLetterFromString:(NSString *)string withCompletion:(void (^)())completionblock;
@end
