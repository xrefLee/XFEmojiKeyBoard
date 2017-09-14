//
//  XFEmojiKeyBoardView.m
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//


#import "XFEmojiKeyBoardView.h"
#import "XFEmojiHeader.h"
#import "XFEmojiFlowLayout.h"
//#import "XFEmojiModel.h"
#import "XFEmojiCell.h"
//#import "CALayer+YYAdd.h"
#import "XFBottomBarView.h"
#import "XFKeyBoardDeleCell.h"

@interface XFEmojiKeyBoardView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSUInteger _group;
    NSMutableArray *_changeGropPageCount;
    NSMutableArray * _everyGroupPageCount;
    NSMutableArray *_allDataArr;
    int _emoticonGroupTotalPageCount;
    NSArray *_emoticonGroupPageIndexs;
    NSMutableArray *_sectionCount;
    NSMutableArray *_sizeValueArr;
    NSMutableArray *_sectionInset_itemSpace;
    
}
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property(nonatomic, strong) UIView *pageControl;
@property (nonatomic, strong) XFBottomBarView *bottomBarView;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageCounts;
@end

@implementation XFEmojiKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViewsWithFrame:frame];
        
    }
    return self;
}

- (void)setUpViewsWithFrame:(CGRect)frame{
    [self addSubview:self.mainCollectionView];
    [self addSubview:self.pageControl];
    
    self.pageControl = [UIView new];
    self.pageControl.frame = CGRectMake(0, self.mainCollectionView.bottom, kScreenW, pageControlH);
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.centerX = frame.size.width/2;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    _currentPageIndex = NSNotFound;
    
    self.bottomBarView = [[XFBottomBarView alloc]initWithFrame:CGRectMake(0, self.pageControl.bottom, kScreenW, bottomBarH)];
    
    [self addSubview:self.bottomBarView];
    
    __weak typeof(self)wself = self;
    __typeof (&*self) __weak weakSelf = self;
    self.bottomBarView.selectBlock = ^(NSUInteger item) {
          __typeof (&*self)  strongSelf = weakSelf;
        NSNumber *numb = strongSelf -> _emoticonGroupPageIndexs[item];
        wself.mainCollectionView.contentOffset = CGPointMake(kScreenW*numb.intValue, 0);

    };
    
    [self.bottomBarView.sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
  
}

- (void)sendBtnAction{
    if ([self.delegate respondsToSelector:@selector(sendAction)]) {
        [self.delegate sendAction];
    }
}

- (void)setCustomCountArr:(NSArray *)customCountArr{
    _customCountArr = customCountArr;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    _group = dataArr.count;
    _allDataArr = [NSMutableArray array];
    _changeGropPageCount = [NSMutableArray array];
    _everyGroupPageCount = [NSMutableArray array];
    _sectionCount = [NSMutableArray array];
    _sizeValueArr = [NSMutableArray array];
    _sectionInset_itemSpace = [NSMutableArray array];
    NSMutableArray *bottomImageArr = [NSMutableArray array];
    
    NSMutableArray *indexs = [NSMutableArray new];
    NSUInteger index = 0;
    NSMutableArray *pageCounts = [NSMutableArray new];
    _emoticonGroupTotalPageCount = 0;
    for (int i = 0; i<dataArr.count; i++) {
        NSArray *arr = dataArr[i];
        NSValue *customValue = self.customCountArr[i];
        XFCount customCount;
        [customValue getValue:&customCount];
        int pagCount = customCount.numOfRow * customCount.rowCount;
        XFEmojiModel *model = arr[0];
        CGFloat width = (kScreenW - (customCount.numOfRow + 1)*itemSpace)/customCount.numOfRow;
        CGFloat height = (self.mainCollectionView.height - (customCount.rowCount + 1)*itemSpace)/customCount.rowCount;
        [bottomImageArr addObject:model.image];
        [indexs addObject:@(index)];
        NSUInteger count = ceil(arr.count / (float)(pagCount - 1));
        if (count == 0) count = 1;
        index += count;
        [pageCounts addObject:@(count)];
        for (int i = 0; i<count; i++) {
            [_sectionCount addObject:@(pagCount)];
            [_sizeValueArr addObject:[NSValue valueWithCGSize:CGSizeMake(width, height)]];
        }
        _emoticonGroupTotalPageCount += count;
    }
    _emoticonGroupPageIndexs = indexs;
    _emoticonGroupPageCounts = pageCounts;
    [self.mainCollectionView reloadData];
    [self scrollViewDidScroll:self.mainCollectionView];
    self.bottomBarView.dataArr = bottomImageArr;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _emoticonGroupTotalPageCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSNumber *num = _sectionCount[section];
    return num.integerValue;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XFEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFEmojiCell" forIndexPath:indexPath];
    XFEmojiModel *model = [self _emoticonForIndexPath:indexPath];
    NSNumber *num = _sectionCount[indexPath.section];
    if (indexPath.row == num.intValue - 1) {
        XFKeyBoardDeleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFKeyBoardDeleCell" forIndexPath:indexPath];
        cell.deleImageView.image = [UIImage imageNamed:@"expression_delete"];
        cell.imageWidth.constant = itemW;
        cell.imageHeigth.constant = itemW;
        return cell;

    }else{
        cell.emojiImageView.image = model.image;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *num = _sectionCount[indexPath.section];
    if (indexPath.row == num.intValue - 1) {
        if ([self.delegate respondsToSelector:@selector(deletAction)]) {
            [self.delegate deletAction];
        }
    }else{
        XFEmojiModel *model = [self _emoticonForIndexPath:indexPath];
        NSLog(@"%@",model.emojiStr);
        if (!model) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(insertEmoji:)]) {
            [self.delegate insertEmoji:model];
        }
    }
}
//
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSValue *itemV = _sizeValueArr[indexPath.section];
    return itemV.CGSizeValue;
}


- (XFEmojiModel *)_emoticonForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
        if (section >= pageIndex.unsignedIntegerValue) {
            NSValue *customValue = self.customCountArr[i];
            XFCount customCount;
            [customValue getValue:&customCount];
            
            int pagCount = customCount.numOfRow * customCount.rowCount - 1;
            
            NSArray *group = self.dataArr[i];
            NSUInteger page = section - pageIndex.unsignedIntegerValue;
            NSUInteger index = page * pagCount + indexPath.row;

            // transpose line/row
            NSUInteger ip = index / pagCount;
            NSUInteger ii = index % pagCount;
            NSUInteger reIndex = (ii % customCount.rowCount) * customCount.numOfRow + (ii / customCount.rowCount);
            index = reIndex + ip * pagCount;

            if (index < group.count) {
                return group[index];
            } else {
                return nil;
            }
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = round(scrollView.contentOffset.x / scrollView.width);
    if (page < 0) page = 0;
    else if (page >= _emoticonGroupTotalPageCount) page = _emoticonGroupTotalPageCount - 1;
    if (page == _currentPageIndex) return;
    _currentPageIndex = page;
    NSInteger curGroupIndex = 0, curGroupPageIndex = 0, curGroupPageCount = 0;
    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
        if (page >= pageIndex.unsignedIntegerValue) {
            curGroupIndex = i;
            curGroupPageIndex = ((NSNumber *)_emoticonGroupPageIndexs[i]).integerValue;
            curGroupPageCount = ((NSNumber *)_emoticonGroupPageCounts[i]).integerValue;
            self.bottomBarView.selectRow = (NSUInteger)curGroupIndex;
            
            break;
        }
    }
    [_pageControl removeAllSubviews];
    CGFloat padding = 5, width = 6, height = 2;
    CGFloat pageControlWidth = (width + 2 * padding) * curGroupPageCount;
    for (NSInteger i = 0; i < curGroupPageCount; i++) {
        UIView *layer = [UIView new];
        layer.size = CGSizeMake(width, height);
        layer.layer.cornerRadius = 1;
        if (page - curGroupPageIndex == i) {
            layer.backgroundColor = [UIColor redColor];
        } else {
            layer.backgroundColor = [UIColor blueColor];
        }
        layer.centerY = _pageControl.height / 2;
        layer.left = (_pageControl.width - pageControlWidth) / 2 + i * (width + 2 * padding) + padding;
        [_pageControl addSubview:layer];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}



#pragma mark - ### 懒加载
- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        
        // 给每一个下组件(item)一个大小
//        flow.itemSize = CGSizeMake(itemW , itemW);
        // 每两个item的最小间隔(横向滚动和垂直滚动两个方向)
        
        CGFloat scale = [UIScreen mainScreen].scale;
        
        flow.minimumInteritemSpacing = round(itemSpace * scale) / scale;
        // 每行的最小间隔(横向滚动和垂直滚动两个方向)
        flow.minimumLineSpacing = round(itemSpace * scale) / scale  ;
        
        // 滚动方向设置
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 布局的头部尺寸
        //    flow.headerReferenceSize = CGSizeMake(100, 40);
        // 尾部尺寸
        //    flow.footerReferenceSize = CGSizeMake(100, 40);
        // 视图的内边距(上,左,下,右)
        flow.sectionInset = UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace,itemSpace);
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, keyBoardViewH) collectionViewLayout:flow];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
#pragma mark - 允许选择多个
        //        _mainCollectionView.allowsMultipleSelection= YES;
        
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        
        // cell 注册
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"XFEmojiCell" bundle:nil] forCellWithReuseIdentifier:@"XFEmojiCell"];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"XFKeyBoardDeleCell" bundle:nil] forCellWithReuseIdentifier:@"XFKeyBoardDeleCell"];
        
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.pagingEnabled = YES;
    }
    
    
    return _mainCollectionView;
}


@end

/*
#import "XFEmojiKeyBoardView.h"
#import "XFEmojiHeader.h"
#import "XFEmojiFlowLayout.h"
#import "XFEmojiModel.h"
#import "XFEmojiCell.h"
@interface XFEmojiKeyBoardView ()<UICollectionViewDataSource,UICollectionViewDelegate,XFEmojiFlowLayoutDelegate>{
    NSUInteger _group;
    NSMutableArray *_changeGropPageCount;
    NSMutableArray * _everyGroupPageCount;
    NSMutableArray *_allDataArr;
}
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property(nonatomic, strong) UIPageControl *pageControl;

@end

@implementation XFEmojiKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainCollectionView];
        [self addSubview:self.pageControl];
        self.pageControl.frame = CGRectMake(0, self.mainCollectionView.bottom, 200, 15);
        self.pageControl.centerX = frame.size.width/2;
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    _group = dataArr.count;
    
    
    _allDataArr = [NSMutableArray array];
    _changeGropPageCount = [NSMutableArray array];
    _everyGroupPageCount = [NSMutableArray array];
    for (NSArray *arr in dataArr) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        
        [tmpArr addObjectsFromArray:arr];
        int pag = ceil(tmpArr.count/(XFRows*XFKrowCount - 1));
        
        for (int i = pag - 1; i> 0; i--) {
            XFEmojiModel *model = [[XFEmojiModel alloc]init];
//            model.isDele = YES;
            [tmpArr insertObject:model atIndex:20*i];
        }
        
        [_everyGroupPageCount addObject:[NSNumber numberWithInt:pag]];
        
        for (long i = tmpArr.count; i< pag*XFRows*XFKrowCount  ; i++) {
            XFEmojiModel *model = [[XFEmojiModel alloc]init];
            [tmpArr addObject:model];
        }
        [_allDataArr addObjectsFromArray:tmpArr];
        
        [_changeGropPageCount addObject:[NSNumber numberWithInt:_allDataArr.count/(XFRows*XFKrowCount)]];
        
        if (arr == dataArr[0]) {
            self.pageControl.numberOfPages = pag;
        }
        

    }
    
    [self.mainCollectionView reloadData];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _allDataArr.count;
 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XFEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFEmojiCell" forIndexPath:indexPath];

    XFEmojiModel *model = _allDataArr[indexPath.row];
    
    cell.emojiImageView.image = model.image;
    
    
    
    if ((indexPath.row + 1)%21 == 0) {
        cell.emojiImageView.image = [UIImage imageNamed:@"expression_delete"];
    }
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}
//
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    XFEmojiModel *model = _allDataArr[indexPath.row];
    
    CGFloat width = itemW/model.image.size.width * model.image.size.width;
    
    
    
    return CGSizeMake(width, itemW);
}

//- (XFEmojiModel *)_emoticonForIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger section = indexPath.section;
//    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
//        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
//        if (section >= pageIndex.unsignedIntegerValue) {
//            YHEmoticonGroup *group = _emoticonGroups[i];
//            NSUInteger page = section - pageIndex.unsignedIntegerValue;
//            NSUInteger index = page * kOnePageCount + indexPath.row;
//            
//            // transpose line/row
//            NSUInteger ip = index / kOnePageCount;
//            NSUInteger ii = index % kOnePageCount;
//            NSUInteger reIndex = (ii % 3) * 7 + (ii / 3);
//            index = reIndex + ip * kOnePageCount;
//            
//            if (index < group.emoticons.count) {
//                return group.emoticons[index];
//            } else {
//                return nil;
//            }
//        }
//    }
//    return nil;
//}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollx = scrollView.contentOffset.x;
    int item = round(scrollx/kScreenW);
    //    NSLog(@"%f",item);
    
    
    
    for (int i = 0 ; i < _changeGropPageCount.count; i++) {
        NSNumber *numMax = _changeGropPageCount[i];
        
        
        if (i == 0) {
            if (item + 1 <= numMax.intValue) {
                self.pageControl.numberOfPages = [_everyGroupPageCount[i] intValue];
                int currentPage1 = (item % numMax.intValue);
                self.pageControl.currentPage = currentPage1 ;
                break;
            }
        }else{
            NSNumber *numMin = _changeGropPageCount[i - 1];
            if (numMin.intValue < item + 1 && item + 1 <= numMax.intValue) {
                self.pageControl.numberOfPages = [_everyGroupPageCount[i] intValue];
                
                int currentPage1 = ((item -numMin.intValue)  % numMax.intValue);
                self.pageControl.currentPage = currentPage1 ;
                break;
            }
        }
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}



#pragma mark - ### 懒加载
- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        
        XFEmojiFlowLayout *flow = [[XFEmojiFlowLayout alloc]init];
        flow.delegate = self;
        // 给每一个下组件(item)一个大小
        flow.itemSize = CGSizeMake(itemW , itemW);
        // 每两个item的最小间隔(横向滚动和垂直滚动两个方向)
        flow.minimumInteritemSpacing = itemSpace - 1;
        // 每行的最小间隔(横向滚动和垂直滚动两个方向)
        flow.minimumLineSpacing = itemSpace -1 ;
        
        // 滚动方向设置
//        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 布局的头部尺寸
        //    flow.headerReferenceSize = CGSizeMake(100, 40);
        // 尾部尺寸
        //    flow.footerReferenceSize = CGSizeMake(100, 40);
        // 视图的内边距(上,左,下,右)
        flow.sectionInset = UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace,itemSpace);
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, keyBoardViewH) collectionViewLayout:flow];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
#pragma mark - 允许选择多个
        //        _mainCollectionView.allowsMultipleSelection= YES;
        
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        
        // cell 注册
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"XFEmojiCell" bundle:nil] forCellWithReuseIdentifier:@"XFEmojiCell"];
        
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.pagingEnabled = YES;
    }
    
    
    return _mainCollectionView;
}


- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 3;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.hidesForSinglePage = NO;
    }
    return _pageControl;
}

@end
*/
