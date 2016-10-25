//
//  GameViewController.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/14/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameManager.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[GameManager sharedManager] setSpriteKitView:(SKView *)self.view];
    [[GameManager sharedManager] loadMainMenuSceneWithEntranceAnimationsEnabled:YES];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
