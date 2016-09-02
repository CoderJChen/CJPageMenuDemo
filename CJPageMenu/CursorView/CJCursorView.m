//
//  CJCursorView.m
//  CJPageMenu
//
//  Created by chenjie on 16/8/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "CJCursorView.h"
#import "CJSelectorCell.h"

static NSString * const cellIdentifer = @"selectorCell";

@interface CJCursorView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIScrollView * rootScrollView;
@end

@implementation CJCursorView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        _normalColor = [UIColor blackColor];
        _selectColor = [UIColor redColor];
        _normalFont = _selectFont = [UIFont systemFontOfSize:14.0];
        
        self.lineEdgeInset = UIEdgeInsetsMake(0, 3, 2, 3);
        self.cursorEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _currentIndex = 0;
    }
    return self;
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.cursorEdgeInset.left, self.cursorEdgeInset.top, CGRectGetWidth(self.bounds)-self.cursorEdgeInset.left-self.cursorEdgeInset.right, CGRectGetHeight(self.bounds)-self.cursorEdgeInset.top-self.cursorEdgeInset.bottom) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[CJSelectorCell class] forCellWithReuseIdentifier:cellIdentifer];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
-(UIView *)lineView{
    if (_lineView ==nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor redColor];
        [self.collectionView addSubview:_lineView];
    }
    return _lineView;
}
-(UIScrollView *)rootScrollView{
    
    if (_rootScrollView == nil) {
        _rootScrollView = [[UIScrollView alloc]init];
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), _contentViewHeight);
        _rootScrollView.pagingEnabled = YES;
        _rootScrollView.delegate = self;
        [self.parentViewController.view addSubview:_rootScrollView];
    }
    return _rootScrollView;
}
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    self.rootScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*_titles.count, _contentViewHeight);
    
}
- (void)reloadPages{
    [self.collectionView reloadData];
    [self addChildController];
}

- (void)addChildController{
    
    UIViewController * viewController = self.controllers[_currentIndex];
    
    CGFloat startX = CGRectGetWidth(self.rootScrollView.bounds)*_currentIndex;
    
    NSLog(@"parentViewController-%@",viewController.parentViewController);
    if (!viewController.parentViewController) {
        [self.parentViewController addChildViewController:viewController];
        CGRect rect = self.rootScrollView.bounds;
        rect.origin.x = startX;
        viewController.view.frame = rect;
        [self.rootScrollView addSubview:viewController.view];
        
        [viewController didMoveToParentViewController:self.parentViewController];
    }
    [self.rootScrollView setContentOffset:CGPointMake(startX, 0) animated:NO];
    
}

- (void)resizeLineWithCellFrame:(CGRect)frame animation:(BOOL)animation{
    CGFloat height = 3.0f;
    CGRect rect = CGRectMake(CGRectGetMinX(frame)+self.lineEdgeInset.left, CGRectGetHeight(self.bounds)-height-self.lineEdgeInset.bottom, CGRectGetWidth(frame)-self.lineEdgeInset.left*2, height-self.lineEdgeInset.top);
    if (animation) {
        [UIView animateWithDuration:3.0f animations:^{
            self.lineView.frame = rect;
        }];
    }else{
        self.lineView.frame = rect;
    }
}
- (void)setContentViewWithCellFrame:(CGRect)frame{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds)/2;
    
//    NSLog(@"self-%@",NSStringFromCGRect(self.bounds));
//     NSLog(@"collection-%@",NSStringFromCGRect(self.collectionView.bounds));
    
    CGFloat offSetX = 0;
    if (CGRectGetMidX(frame)<=width) {
        
        offSetX = 0;
    }else if (CGRectGetMidX(frame)+width>= self.collectionView.contentSize.width){
        
        offSetX = self.collectionView.contentSize.width-CGRectGetWidth(self.collectionView.bounds);
        
    }else if(CGRectGetMidX(frame)>width){
        
        offSetX = CGRectGetMidX(frame)-width;
    }
    [self.collectionView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}
//取消选中
- (void)deselectItemAtIndexPath:(NSInteger )index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CJSelectorCell * cell = (CJSelectorCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}
//选中item
- (void)selectItemAtIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self selectItemAtIndexPath:indexPath];
    
}
- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath{
    CJSelectorCell * cell = (CJSelectorCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    CGRect frame = cell.frame;
    if (!cell) {
        UICollectionViewLayoutAttributes * attribute = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
        frame = attribute.frame;
    }
    [self resizeLineWithCellFrame:frame animation:NO];
    [self addChildController];
    [self setContentViewWithCellFrame:frame];
    
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    if ([self.rootScrollView isEqual:scrollView]) {
//        CGFloat index = scrollView.contentOffset.x/scrollView.frame.size.width;
//        if (index >= 0) {
//            if (_currentIndex != index) {
//                [self deselectItemAtIndexPath:index];
//                self.currentIndex = index;
//                [self selectItemAtIndex:_currentIndex];
//            }
//        }
//    }
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.rootScrollView isEqual:scrollView]) {
        CGFloat index = scrollView.contentOffset.x/scrollView.frame.size.width;
        if (index >= 0) {
            if (_currentIndex != index) {
                [self deselectItemAtIndexPath:index];
                self.currentIndex = index;
                [self selectItemAtIndex:_currentIndex];
            }
        }
    }

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CJSelectorCell * cell = (CJSelectorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.content = _titles[indexPath.item];
    cell.normalFont = self.normalFont;
    cell.normalColor = self.normalColor;
    cell.selectFont = self.selectFont;
    cell.selectColor = self.selectColor;
    cell.selected = (_currentIndex == indexPath.item);
    if (collectionView.indexPathsForSelectedItems.count<=0) {
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self resizeLineWithCellFrame:cell.frame animation:NO];
    }
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentIndex == indexPath.item) {
        return;
    }
    self.currentIndex = indexPath.item;
    
    [self selectItemAtIndexPath:indexPath];
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    CJSelectorCell * cell = (CJSelectorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}
//设置cell的尺寸
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = _titles[indexPath.item];
   CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:self.selectFont}];
    size = CGSizeMake(size.width+36, self.bounds.size.height);
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




@end
