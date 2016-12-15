//
//  CycleImageViewCell.m
//  WYKT
//
//  Created by busylife on 16/9/8.
//  Copyright © 2016年 BusyLife. All rights reserved.
//

#import "BLCycleImageViewCell.h"

@implementation BLCycleImageViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    _cycleImageView = [BLCycleImageView cycleImageViewWithFrame:CGRectMake(0, 0, SCREENT_WIDTH, 180) imageUrlGroup:@[] placeHodlerImage:nil delegate:self];
    [self.contentView addSubview:_cycleImageView];
}

- (void)setImageArr:(NSArray *)imageArr{
    _cycleImageView.imageUrlArr = imageArr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- CycleImageViewDelegate
- (void)cycleImageView:(BLCycleImageView *)cycleImageView didClickImage:(NSUInteger)imageIndex{
    if ([self.delegate respondsToSelector:@selector(cycleImageViewCell:didClickImage:)]) {
        [self.delegate cycleImageViewCell:self didClickImage:imageIndex];
    }
}


@end
