//
//  NavigationScene.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/26/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "RootNavigationScene.h"
#import "SKLabelNode+CommonAnimations.h"
#import "SKLabelNode+Background.h"
#import "UIColor+AppColors.h"

@interface NavigationScene : RootNavigationScene

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger fontSize;
@end
