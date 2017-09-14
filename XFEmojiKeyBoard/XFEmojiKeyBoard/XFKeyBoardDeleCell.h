//
//  XFKeyBoardDeleCell.h
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/14.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFKeyBoardDeleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeigth;

@end
