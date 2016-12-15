//
//  CycleImageView.h
//  WYKT
//
//  Created by busylife on 16/9/8.
//  Copyright © 2016年 BusyLife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PageControllPositionType){
    PageControllPositionTypeOfCenter,
    PageControllPositionTypeOfLeft,
    PageControllPositionTypeOfRight
};

@class BLCycleImageView;

@protocol CycleImageViewDelegate <NSObject>

@optional
- (void)cycleImageView:(BLCycleImageView *)cycleImageView didClickImage:(NSUInteger)imageIndex;

@end

@interface BLCycleImageView : UIView

@property(nonatomic,copy)  NSArray *imageUrlArr;
@property(nonatomic,copy) NSArray *imageTitles;
@property(nonatomic,strong) UIImage *placeholderImg;
@property(nonatomic,getter=isShowPageControll) BOOL showPageControll;
@property(nonatomic,getter=isAutoMoving) BOOL autoMoving;
@property(nonatomic,assign) NSNumber *autoMoveInterval;
@property(nonatomic,weak) id<CycleImageViewDelegate> delegate;
@property(nonatomic,assign) PageControllPositionType pagecontrollPosition;

+ (instancetype)cycleImageViewWithFrame:(CGRect)frame imageUrlGroup:(NSArray *)imageUrlGroup;

+ (instancetype)cycleImageViewWithFrame:(CGRect)frame imageUrlGroup:(NSArray *)imageUrlGroup placeHodlerImage:(UIImage*)placeHolerImg delegate:(id<CycleImageViewDelegate>)delegate;

@end
