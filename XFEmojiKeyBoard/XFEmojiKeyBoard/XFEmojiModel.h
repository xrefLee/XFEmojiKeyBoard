//
//  XFEmojiModel.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XFEmojiModel : NSObject

/// 表情字符串  /惊讶
@property (nonatomic, strong) NSString *emojiStr;
/// 对应的图片名称
@property (nonatomic, strong) NSString *imageName;
/// 对应的 image
@property (nonatomic, strong) UIImage *image;


@end
