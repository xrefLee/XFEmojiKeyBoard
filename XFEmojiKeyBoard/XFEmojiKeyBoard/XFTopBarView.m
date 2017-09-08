//
//  XFTopBarView.m
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import "XFTopBarView.h"
#import "XFEmojiHeader.h"

#define maxHeight 90

@interface XFTopBarView ()<UITextViewDelegate>
@property(nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIButton *danmuBtn;
@property (nonatomic, strong) UILabel *danmuLabel;
/*
 * 表情按钮
 */
@property(nonatomic, strong) UIButton *topBarEmotionBtn;

@end

@implementation XFTopBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViewsWithFrame:frame];
    }
    return self;
}


- (void)setUpViewsWithFrame:(CGRect)frame{
//    self.backgroundColor =  ColorRGB(236, 237, 241);
    [self addSubview:self.topLine];
    [self addSubview:self.textView];
    [self addSubview:self.danmuBtn];
    [self addSubview:self.topBarEmotionBtn];
    
    self.topLine.frame = CGRectMake(0, 0, kScreenW, 0.5);
    
    self.danmuBtn.size = CGSizeMake((frame.size.height - 8)*1.5, frame.size.height - 8);
    self.danmuLabel.width = self.danmuBtn.width*2/3;
    self.topBarEmotionBtn.frame = CGRectMake(self.danmuBtn.right + 5, self.danmuBtn.top, self.danmuBtn.height, self.danmuBtn.height);
    
    self.textView.frame = CGRectMake(self.topBarEmotionBtn.right + 5, 4, frame.size.width - self.danmuBtn.width - self.topBarEmotionBtn.width - 5- 5-5 - 5, topBarHeight - 8);
    self.topBarEmotionBtn.height = self.textView.height - 2;
    self.topBarEmotionBtn.centerY = self.textView.centerY;
    self.danmuBtn.height = self.textView.height - 2;
    self.danmuBtn.centerY = self.textView.centerY;
    self.danmuLabel.height = self.danmuBtn.height - 2;
    self.danmuLabel.centerY = self.danmuBtn.height/2;
}

- (void)danmuBtnAction:(UIButton *)sender{
    if (!sender.isSelected) {
        self.danmuLabel.textColor = [UIColor cyanColor];
        self.danmuBtn.backgroundColor = [UIColor cyanColor];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.danmuLabel.left = self.danmuBtn.width-self.danmuLabel.width - 2;
        [UIView commitAnimations];
        self.textView.placeholder = @"弹幕状态~说点什么吧";
        
    }else{
        self.danmuLabel.textColor = [UIColor lightGrayColor];
        self.danmuBtn.backgroundColor = [UIColor lightGrayColor];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.danmuLabel.left = 2;
        [UIView commitAnimations];
        self.textView.placeholder = @"说点什么吧";
        
    }
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(danMuBtnIsSelect:)]) {
        [self.delegate danMuBtnIsSelect:sender.selected];
    }
    
}

//键盘切换按钮事件
- (void)emotionBtnDidClicked:(UIButton *)emotionBtn {
    emotionBtn.selected = !emotionBtn.selected;
    if ([self.delegate respondsToSelector:@selector(topBarEmotionBtnClicked:)]) {
        [self.delegate topBarEmotionBtnClicked:emotionBtn];
    }
}


- (UIButton *)topBarEmotionBtn {
    
    if (!_topBarEmotionBtn) {
        _topBarEmotionBtn = [[UIButton alloc]init];
        [_topBarEmotionBtn setImage:[UIImage imageNamed:@"group_topic_expression"] forState:UIControlStateNormal];
        [_topBarEmotionBtn setImage:[UIImage imageNamed:@"group_topic_keyboard"] forState:UIControlStateSelected];
        [_topBarEmotionBtn addTarget:self action:@selector(emotionBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBarEmotionBtn;
}


- (UIButton *)danmuBtn{
    if (!_danmuBtn) {
        _danmuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _danmuBtn.frame = CGRectMake(5, 0, 45,  5);
        _danmuBtn.backgroundColor = [UIColor lightGrayColor];
        _danmuBtn.layer.cornerRadius = 3;
        _danmuBtn.layer.masksToBounds = YES;
        
        self.danmuLabel = [UILabel new];
        self.danmuLabel.frame = CGRectMake(2, 0, 30, 0);
        self.danmuLabel.layer.cornerRadius = 3;
        self.danmuLabel.layer.masksToBounds = YES;
        self.danmuLabel.backgroundColor = [UIColor whiteColor];
        self.danmuLabel.textColor = [UIColor lightGrayColor];
        self.danmuLabel.text = @"弹幕";
        self.danmuLabel.font = [UIFont systemFontOfSize:13];
        self.danmuLabel.textAlignment = NSTextAlignmentCenter;
        [_danmuBtn addSubview:self.danmuLabel];
        [_danmuBtn addTarget:self action:@selector(danmuBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _danmuBtn;
}

- (SZTextView *)textView {
    
    if (!_textView) {
        _textView = [[SZTextView alloc]init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 5;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.scrollEnabled = YES;
        self.textView.placeholder = @"说点什么吧";
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17.0f];

    }
    return _textView;
}

- (UIView *)topLine {
    
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLine;
}

- (void)resetSubsives {
    
    
    
    [self textViewDidChange:self.textView];
}



#pragma mark ==== textView代理方法 ====

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(sendAction)]) {
            [self.delegate sendAction];
        }
        return NO;
    }
    return YES;
}

//监听键盘改变，重设控件frame
- (void)textViewDidChange:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter]postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
    CGFloat width   = CGRectGetWidth(textView.frame);
    CGSize newSize  = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    CGRect maxFrame = textView.frame;
    maxFrame.size   = CGSizeMake(width, maxHeight);
    CGFloat height = newSize.height < self.danmuBtn.height ? self.danmuBtn.height : newSize.height;
    
    newFrame.size   = CGSizeMake(width, height);
    
    
    
    [UIView animateWithDuration:0.25 animations:^{
        if (newSize.height <= maxHeight) {
            
            textView.frame  = newFrame;
            textView.scrollEnabled = NO;
        }else {
            
            textView.frame = maxFrame;
            textView.scrollEnabled = YES;
        }
        
        self.height = textView.size.height + 8;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"keyBoardChange" object:nil];
//        [self updateSubviews];
    }];
}
@end
