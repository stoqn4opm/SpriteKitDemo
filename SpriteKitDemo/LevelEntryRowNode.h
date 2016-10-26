//
//  LevelEntryRow.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/26/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "UIColor+AppColors.h"

@interface LevelEntryRowNode : SKSpriteNode
- (void)configureWithNumberEntry:(NSNumber *)numberEntry textEntry:(NSString *)textEntry;
@end
