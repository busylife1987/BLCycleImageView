//
//  CycleImageViewCell.h
//  WYKT
//
//  Created by busylife on 16/9/8.
//  Copyright © 2016年 BusyLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCycleImageView.h"

@class BLCycleImageViewCell;
@protocol CycleImageViewCellDelegate <NSObject>

@optional
- (void)cycleImageViewCell:(BLCycleImageViewCell*)cycleImageViewCell didClickImage:(NSUInteger)imageIndex;

@end

@interface BLCycleImageViewCell : UITableViewCell<CycleImageViewDelegate>

@property(nonatomic, weak) id<CycleImageViewCellDelegate> delegate;
@property(nonatomic, strong) BLCycleImageView *cycleImageView;
@property(nonatomic, copy) NSArray *imageArr;
@property(nonatomic, assign) CGFloat height;

@end
