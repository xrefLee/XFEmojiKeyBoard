//
//  XFEmojiHeader.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#ifndef XFEmojiHeader_h
#define XFEmojiHeader_h

//屏幕宽
#define kScreenW [UIScreen mainScreen].bounds.size.width
//屏幕高
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define UIColorRandom [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

/*topbar*/
//输入框的高度
static CGFloat const XFTextViewH = 35;
//键盘切换按钮的宽度
static CGFloat const XFEmotionBtnW = 30;
//键盘切换按钮的高度
static CGFloat const XFEmotionBtnH = 30;

//每一行的按钮数
static CGFloat const XFKrowCount = 7.0;
//每一页的行数
static CGFloat const XFRows = 3.0;

/*keyBoard*/
//键盘变化时间
static CGFloat const XFKeyBoardTipTime = 0.3;

#define topBarHeight 45

#define kOnePageCount (int)((XFKrowCount * XFRows) - 1)

#define itemW kScreenW * 0.0875

#define itemSpace (kScreenW - (itemW * XFKrowCount))/(XFKrowCount + 1)


#define keyBoardViewH itemW * XFRows + itemSpace * (XFRows + 1)

#define pageControlH 20
#define bottomBarH 40

//表情按钮宽高
/*颜色*/
//#define ColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]


#import "UIView+CustomFrame.h"



#endif /* XFEmojiHeader_h */
