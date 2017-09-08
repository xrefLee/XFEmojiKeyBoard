//
//  XFBottomBarView.m
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import "XFBottomBarView.h"
#import "XFEmojiHeader.h"
#import "XFBottomBarCell.h"
@interface XFBottomBarView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@end

@implementation XFBottomBarView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainCollectionView];
        [self addSubview:self.sendBtn];
        self.sendBtn.right = frame.size.width;
    }
    return self;
}


- (void)setSelectRow:(NSUInteger)selectRow{
    
    _selectRow = selectRow;
    [self.mainCollectionView reloadData];
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.mainCollectionView reloadData];
}




#pragma mark - ### 懒加载

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendBtn.frame = CGRectMake(0, 0, bottomBarH*1.4, bottomBarH);
        _sendBtn.backgroundColor = [UIColor blueColor];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    }
    
    return _sendBtn;
}

- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        
        // 给每一个下组件(item)一个大小
        flow.itemSize = CGSizeMake(bottomBarH * 2 , bottomBarH);
        // 每两个item的最小间隔(横向滚动和垂直滚动两个方向)
        
        flow.minimumInteritemSpacing = 1;
        // 每行的最小间隔(横向滚动和垂直滚动两个方向)
        flow.minimumLineSpacing = 1  ;
        
        // 滚动方向设置
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 布局的头部尺寸
        //    flow.headerReferenceSize = CGSizeMake(100, 40);
        // 尾部尺寸
        //    flow.footerReferenceSize = CGSizeMake(100, 40);
        // 视图的内边距(上,左,下,右)
//        flow.sectionInset = UIEdgeInsetsMake(3, 3, 3,3);
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, bottomBarH) collectionViewLayout:flow];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
#pragma mark - 允许选择多个
        //        _mainCollectionView.allowsMultipleSelection= YES;
        
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        
        // cell 注册
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"XFBottomBarCell" bundle:nil] forCellWithReuseIdentifier:@"XFBottomBarCell"];
        
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.pagingEnabled = YES;
    }
    
    
    return _mainCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XFBottomBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XFBottomBarCell" forIndexPath:indexPath];
    
    UIImage *image = self.dataArr[indexPath.row];
    cell.emojiCataImageView.image = image;
    
    if (indexPath.row == self.selectRow) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectRow = indexPath.row;
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
    
}

@end
