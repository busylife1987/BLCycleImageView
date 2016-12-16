//
//  CycleImageView.m
//  WYKT
//
//  Created by busylife on 16/9/8.
//  Copyright © 2016年 BusyLife. All rights reserved.
//

#import "BLCycleImageView.h"
#import "UIView+Extend.h"
#import "UIImageView+WebCache.h"

#define PAGECONTROLL_W 100
#define PAGECONTROLL_H 10
#define IMAGETITLELABEL_H 30

@interface BLCycleImageView()<UIScrollViewDelegate>{
    CGSize _viewSize;
}

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic) NSTimer *cycleTimer;
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic) BOOL showTitle;

@property(nonatomic,strong) UIImageView *lastImageView;
@property(nonatomic,strong) UIImageView *currnetImageView;
@property(nonatomic,strong) UIImageView *nextImageView;

@end

@implementation BLCycleImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.frame = frame;
        _viewSize = frame.size;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _imageUrlArr = [NSArray array];
    _imageTitles = [NSArray array];
    _currentIndex = 0;
    _autoMoveInterval = [NSNumber numberWithFloat:3.0];
    _autoMoving = YES;
    _showPageControll = YES;
    _showTitle = NO;
    _pagecontrollPosition = PageControllPositionTypeOfCenter;
    
    self.backgroundColor = [UIColor grayColor];
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self addSubview:self.titleView];
    
    _lastImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _viewSize.width, _viewSize.height)];
    [_scrollView addSubview:_lastImageView];
    _currnetImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_viewSize.width, 0, _viewSize.width, _viewSize.height)];
    _currnetImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUIImagerView)];
    [_currnetImageView addGestureRecognizer:tapImageView];
    [_scrollView addSubview:_currnetImageView];
    _nextImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*_viewSize.width, 0, _viewSize.width, _viewSize.height)];
    [_scrollView addSubview:_nextImageView];
}

+ (instancetype)cycleImageViewWithFrame:(CGRect)frame imageUrlGroup:(NSArray *)imageUrlGroup{
    BLCycleImageView *cycleImageView = [[self alloc] initWithFrame:frame];
    if (imageUrlGroup.count > 0) {
        cycleImageView.imageUrlArr = imageUrlGroup;
    }
    
    return cycleImageView;
}

+ (instancetype)cycleImageViewWithFrame:(CGRect)frame imageUrlGroup:(NSArray *)imageUrlGroup placeHodlerImage:(UIImage *)placeHolerImg delegate:(id<CycleImageViewDelegate>)delegate{
    BLCycleImageView *cycleImageView = [[self alloc] initWithFrame:frame];
    if (imageUrlGroup.count > 0) {
        cycleImageView.imageUrlArr = imageUrlGroup;
    }
    cycleImageView.delegate = delegate;
    cycleImageView.placeholderImg = placeHolerImg;
    return cycleImageView;
}

- (void)layoutSubviews{
    if (_imageTitles.count == _imageUrlArr.count && _pagecontrollPosition!=PageControllPositionTypeOfCenter) {
        _showTitle = YES;
    }
    
    _scrollView.frame = CGRectMake(0, 0, _viewSize.width, _viewSize.height);
    _titleView.frame = CGRectMake(0, _scrollView.bottom - IMAGETITLELABEL_H, _viewSize.width, IMAGETITLELABEL_H);
    CGFloat titleLabelW = _viewSize.width - PAGECONTROLL_W - 30;
    CGFloat pagectrollY = _scrollView.bottom - 20;
    switch (_pagecontrollPosition) {
        case PageControllPositionTypeOfCenter:
            _pageControl.frame = CGRectMake((_viewSize.width - PAGECONTROLL_W)*.5, pagectrollY, PAGECONTROLL_W, PAGECONTROLL_H);
            break;
        case PageControllPositionTypeOfLeft:
            _pageControl.frame = CGRectMake(10, pagectrollY, PAGECONTROLL_W, PAGECONTROLL_H);
            _titleLabel.frame = CGRectMake(_pageControl.right + 10, 0, titleLabelW, IMAGETITLELABEL_H);
            if (_showTitle) {
                _titleLabel.textAlignment = NSTextAlignmentRight;
                _titleLabel.hidden = NO;
                _titleView.hidden = NO;
            }
            break;
        default:
            _pageControl.frame = CGRectMake(_scrollView.width - PAGECONTROLL_W - 10, pagectrollY, PAGECONTROLL_W, PAGECONTROLL_H);
            _titleLabel.frame = CGRectMake(10, 0, titleLabelW, IMAGETITLELABEL_H);
            if (_showTitle) {
                _titleLabel.textAlignment = NSTextAlignmentLeft;
                _titleLabel.hidden = NO;
                _titleView.hidden = NO;
            }
            break;
    }
}

- (UIView *)titleView{
    if(!_titleView){
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor blackColor];
        _titleView.alpha = 0.6;
        _titleView.hidden = YES;
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.hidden = YES;
    }
    [_titleView addSubview:_titleLabel];
    return _titleView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = NO;//控件遇到边框是否反弹
        _scrollView.showsVerticalScrollIndicator = NO;//是否显示滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;//是否整页翻动
        _scrollView.delegate = self;
    }
    _scrollView.contentSize = CGSizeMake(_viewSize.width * 3, _viewSize.height);
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, PAGECONTROLL_W, PAGECONTROLL_H)];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
        [_pageControl setNumberOfPages:_imageUrlArr.count];
    }
    return _pageControl;
}

- (void)setImageUrlArr:(NSArray *)imageUrlArr{
    if ([imageUrlArr count] == 0) {
        return;
    }
    _imageUrlArr = imageUrlArr;
    _pageControl.numberOfPages = _imageUrlArr.count;
    _pageControl.currentPage = _currentIndex;
    
    NSUInteger nextImageindex = 0;
    NSUInteger lastImageindex = 0;
    if (_currentIndex == _imageUrlArr.count - 1) {
        nextImageindex = 0;
    }else if (_currentIndex == 0){
        lastImageindex = _imageUrlArr.count - 1;
    }else{
    }
    
    [_lastImageView sd_setImageWithURL:[NSURL URLWithString:[_imageUrlArr objectAtIndex:lastImageindex]] placeholderImage:_placeholderImg];
    [_currnetImageView sd_setImageWithURL:[NSURL URLWithString:[_imageUrlArr objectAtIndex:_currentIndex]] placeholderImage:_placeholderImg];
    [_nextImageView sd_setImageWithURL:[NSURL URLWithString:[_imageUrlArr objectAtIndex:nextImageindex]] placeholderImage:_placeholderImg];
    
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(_viewSize.width, 0) animated:NO];

    
    if (_imageTitles.count > _currentIndex) {
        _titleLabel.text = _imageTitles[_currentIndex];
    }
    
    if (_autoMoving && !_cycleTimer.valid) {
        self.cycleTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(viewNextImage) userInfo:nil repeats:YES];
    }
}

- (void)reloadImageView{
    //加载图片
    NSUInteger lastImageIndex = _currentIndex - 1;
    NSUInteger nextImageViewIndex = _currentIndex + 1;
    NSUInteger imageCount = _imageUrlArr.count;
    
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x > _viewSize.width) { //向右滑动
        _currentIndex = (_currentIndex + 1) % imageCount;
    }else if(offset.x < _viewSize.width){ //向左滑动
        _currentIndex = (_currentIndex + imageCount-1) % imageCount;
    }
    
    lastImageIndex = (_currentIndex + imageCount-1) % imageCount;
    nextImageViewIndex = (_currentIndex + 1) % imageCount;
    
    [_lastImageView sd_setImageWithURL:[NSURL URLWithString:[_imageUrlArr objectAtIndex:lastImageIndex]] placeholderImage:_placeholderImg];
    [_currnetImageView sd_setImageWithURL:[NSURL URLWithString:[_imageUrlArr objectAtIndex:_currentIndex]] placeholderImage:_placeholderImg];
    [_nextImageView sd_setImageWithURL:[NSURL URLWithString:[_imageUrlArr objectAtIndex:nextImageViewIndex]] placeholderImage:_placeholderImg];
    
    if (_imageTitles.count > _currentIndex) {
        _titleLabel.text = _imageTitles[_currentIndex];
    }
}

- (void)viewNextImage{
    if (_currentIndex == _imageUrlArr.count - 1) {
        self.currentIndex = 0;
    }
    else{
        self.currentIndex = _currentIndex + 1;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    _pageControl.currentPage = currentIndex;

    [self reloadImageView];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(_viewSize.width, 0) animated:NO];
}


- (void)setShowPageControll:(BOOL)showPageControll{
    _pageControl.hidden = !showPageControll;
}

- (void)setAutoMoving:(BOOL)autoMoving{
    if (autoMoving) {
        if(![_cycleTimer isValid]){
            [self startTimer];
        }
    }
    else{
        [self stopTimer];
    }
    _autoMoving = autoMoving;
}

- (void)setAutoMoveInterval:(NSNumber *)autoMoveInterval{
    _autoMoveInterval = autoMoveInterval;
}

- (void)setPagecontrollPosition:(PageControllPositionType)pagecontrollPosition{
    if (_showPageControll) {
        _pagecontrollPosition = pagecontrollPosition;
        [self setNeedsLayout];
    }
}

- (void)setImageTitles:(NSArray *)imageTitles{
    _imageTitles = imageTitles;
    [self setNeedsLayout];
}

#pragma mark -- tap UIImageView
- (void)tapUIImagerView{
    if ([self.delegate respondsToSelector:@selector(cycleImageView:didClickImage:)]) {
        [self.delegate cycleImageView:self didClickImage:_currentIndex];
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self reloadImageView];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(_viewSize.width, 0) animated:NO];
    //设置分页
    _pageControl.currentPage = _currentIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_autoMoving) {
        [self startTimer];
    }
}

- (void)dealloc{
    _scrollView.delegate = nil;
    [self stopTimer];
}

- (void)stopTimer{
    if([_cycleTimer isValid]){
        [_cycleTimer invalidate];
        _cycleTimer = nil;
    }
}

- (void)startTimer{
    self.cycleTimer = [NSTimer scheduledTimerWithTimeInterval:[_autoMoveInterval doubleValue] target:self selector:@selector(viewNextImage) userInfo:nil repeats:YES];
}

@end
