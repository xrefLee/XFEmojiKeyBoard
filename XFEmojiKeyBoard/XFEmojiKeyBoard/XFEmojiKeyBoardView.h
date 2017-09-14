//
//  XFEmojiKeyBoardView.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFEmojiModel.h"

@protocol XFEmojiKeyBoardViewDelegate <NSObject>

- (void)insertEmoji:(XFEmojiModel *)emojiModel;
- (void)deletAction;
- (void)sendAction;


@end

@interface XFEmojiKeyBoardView : UIView

@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, weak) id<XFEmojiKeyBoardViewDelegate> delegate;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *customCountArr;
@end
