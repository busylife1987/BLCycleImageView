//
//  UIView+Extend.h
//  MyApp
//
//  Created by busylife on 16/8/1.
//  Copyright © 2016年 BLProject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

- (id) initWithParent:(UIView *)parent;
+ (id) viewWithParent:(UIView *)parent;
- (void)removeAllSubViews;
- (UIViewController*)viewController;

@property CGPoint position;
@property CGFloat x;
@property CGFloat y;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;

// makes hiding more logical
@property BOOL	visible;


// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

@end
