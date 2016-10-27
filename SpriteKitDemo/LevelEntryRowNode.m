//
//  LevelEntryRow.m
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/26/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import "LevelEntryRowNode.h"

@implementation LevelEntryRowNode

- (void)configureWithNumberEntry:(NSNumber *)numberEntry textEntry:(NSString *)textEntry {
    SKSpriteNode *rowBck = (SKSpriteNode *)[self childNodeWithName:@"levelEntryBackground"];
    rowBck.color = [UIColor backgroundColor];
    rowBck.alpha = 0.5;
    
    SKSpriteNode *numberEntryBckg = (SKSpriteNode *)[self childNodeWithName:@"numberBackground"];
    numberEntryBckg.color = [UIColor labelBackgroundColor];
    numberEntryBckg.alpha = 0.5;
    
    SKLabelNode *numberLabel = (SKLabelNode *)[self childNodeWithName:@"numberLabel"];
    numberLabel.fontName = @"3Dventure";
    numberLabel.text = [NSString stringWithFormat:@"%@", numberEntry];
    
    SKLabelNode *nameLabel = (SKLabelNode *)[self childNodeWithName:@"nameLabel"];
    nameLabel.fontName = @"3Dventure";
    nameLabel.text = textEntry;
}

@end
