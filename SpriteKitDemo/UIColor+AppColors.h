//
//  UIColor+AppColors.h
//  SpriteKitDemo
//
//  Created by Stoyan Stoyanov on 10/20/16.
//  Copyright © 2016 Stoyan Stoyanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SelectedSlowColor [UIColor colorWithRed:0/255. green:125/255. blue:0/255. alpha:1]
#define SelectedNormalColor [UIColor colorWithRed:252/255. green:158/255. blue:3/255. alpha:1]
#define SelectedFastColor [UIColor colorWithRed:238/255. green:40/255. blue:47/255. alpha:1]
#define NonSelectedColor [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1]

@interface UIColor (AppColors)

+ (UIColor *)backgroundColor;
+ (UIColor *)optionsHeadingColor;

@end
