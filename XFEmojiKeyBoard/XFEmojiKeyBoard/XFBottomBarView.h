//
//  XFBottomBarView.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFBottomBarView : UIView

@property (nonatomic, assign) NSUInteger selectRow;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong)  void(^selectBlock)(NSUInteger item);

@property (nonatomic, strong) UIButton *sendBtn;


@end
