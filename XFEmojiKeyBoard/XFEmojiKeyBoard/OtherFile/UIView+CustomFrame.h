//
//  UIView+CustomFrame.h
//  项目常用文件
//
//  Created by lxf on 2017/5/16.
//  Copyright © 2017年 lxf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomFrame)
@property (nonatomic,assign) float top;

@property (nonatomic,assign) float bottom;

@property (nonatomic,assign) float left;

@property (nonatomic,assign) float right;

@property (nonatomic,assign) float x;

@property (nonatomic,assign) float y;

@property (nonatomic,assign) float width;

@property (nonatomic,assign) float height;

@property (nonatomic,assign) float centerX;

@property (nonatomic,assign) float centerY;

@property (nonatomic,assign) CGPoint origin;

@property (nonatomic,assign) CGSize size;

- (void)removeAllSubviews;

@end
