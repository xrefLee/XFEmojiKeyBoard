//
//  XFEmojiFlowLayout.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XFEmojiFlowLayoutDelegate <UICollectionViewDelegate>

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface XFEmojiFlowLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing; //行间距

@property (nonatomic) CGFloat minimumInteritemSpacing; //item间距

@property (nonatomic) CGSize itemSize; //item大小

@property (nonatomic) UIEdgeInsets sectionInset;

@property (nonatomic, weak) id<XFEmojiFlowLayoutDelegate> delegate;

- (instancetype)init;

@end
