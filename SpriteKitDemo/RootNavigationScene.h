//
//  RootNavigatonScene.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/26/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameManager.h"

@interface RootNavigationScene : SKScene

@property (nonatomic, strong) SKVideoNode *videoBackgroundNode;
- (void)fadeOutVideoBackgroundWithCompletion:(void (^)())completionBlock;
- (void)fadeInVideoBackgroundWithCompletion:(void (^)())completionBlock;
@end
