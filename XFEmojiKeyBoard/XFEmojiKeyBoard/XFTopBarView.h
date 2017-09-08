//
//  XFTopBarView.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"


@protocol XFTopBarViewDelegate <NSObject>
/*
 * 代理方法，点击表情按钮触发方法
 */
- (void)topBarEmotionBtnClicked:(UIButton *)sender;
/*
 * 代理方法 ，点击数字键盘发送的事件
 */
- (void)sendAction;
/*
 * 弹幕按钮点击切换状态
 */
- (void)danMuBtnIsSelect:(BOOL)isSelect;


@end

@interface XFTopBarView : UIView
/*
 * topbar代理
 */
@property(weak,nonatomic)id <XFTopBarViewDelegate> delegate;
@property (nonatomic, strong) SZTextView *textView;
- (void)resetSubsives;


@end
