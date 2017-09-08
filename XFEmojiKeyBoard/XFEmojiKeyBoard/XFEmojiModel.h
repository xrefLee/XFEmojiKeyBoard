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

@property (nonatomic, strong) NSString *emojiStr;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isDele;

@end
