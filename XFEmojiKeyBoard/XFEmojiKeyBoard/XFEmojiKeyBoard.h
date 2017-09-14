//
//  XFEmojiKeyBoard.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "XFEmojiModel.h"
typedef NS_ENUM(NSUInteger, XFEmojiKeyBoardType) {
    XFEmojiKeyBoardTypeShowTopBar,
    XFEmojiKeyBoardTypeHideTopBar,
    
};


typedef NS_ENUM(NSUInteger, XFEmojiKeyBoardStatusType) {
    XFEmojiKeyBoardShowSystemKeyBoard,
    XFEmojiKeyBoardShowEmojiKeyBoard,
    XFEmojiKeyBoardHide,
};



@protocol XFEmojiKeyBoardDelegate <NSObject>

/// 发送按钮点击代理方法
- (void)sendAllStr:(NSString *)str;
/// 弹幕按钮点击切换状态代理方法
- (void)changeDanMuSelect:(BOOL)isSelect;
/// 键盘状态代理方法
- (void)changeKeyBoardStatus:(XFEmojiKeyBoardStatusType)status;



@end


@interface XFEmojiKeyBoard : UIView


/**
 表情分组数组
 eg：
 NSArray *emojiArr = @[ @[XFEmojiModel,XFEmojiModel,XFEmojiModel],
                        @[XFEmojiModel,XFEmojiModel],
                        @[XFEmojiModel,XFEmojiModel]
                      ];
 */
@property (nonatomic, strong) NSArray<XFEmojiModel *> *emojiArr;

/**
 定义每个分组的 ，每行的item个数，和行数
 eg：
 XFCount gourpCount;
 gourpCount.numOfRow = 7;
 gourpCount.rowCount = 3;
 XFCount gourpCount1;
 gourpCount1.numOfRow = 3;
 gourpCount1.rowCount = 3;
 NSValue *group = [NSValue valueWithBytes:&gourpCount objCType:@encode(struct XFCount)];
 NSValue *group1 = [NSValue valueWithBytes:&gourpCount1 objCType:@encode(struct XFCount)];
 NSArray *customCountArr = @[group,group,group1];
 
 */
@property (nonatomic, strong) NSArray<NSValue *> *customCountArr;

@property (nonatomic, strong) SZTextView *textView;

@property (nonatomic, weak) id<XFEmojiKeyBoardDelegate> delegate;

+ (instancetype)shareInstance;

- (void)showInView:(UIView *)view topBarType:(XFEmojiKeyBoardType)topBarType;

- (void)hideKeyBoard;



@end
