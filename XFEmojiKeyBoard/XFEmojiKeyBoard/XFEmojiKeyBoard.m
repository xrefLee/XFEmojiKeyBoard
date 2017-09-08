//
//  XFEmojiKeyBoard.m
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import "XFEmojiKeyBoard.h"
#import "XFEmojiKeyBoardView.h"
#import "XFTopBarView.h"
#import "XFEmojiHeader.h"
#import "XFTextAttachment.h"

@interface XFEmojiKeyBoard ()<XFTopBarViewDelegate,XFEmojiKeyBoardViewDelegate>
{
    
    UIButton *_topBarBtn;
    
    UIFont *_textViewFont;
    
}
@property (nonatomic, strong) XFTopBarView *topBarView;
@property (nonatomic, strong) XFEmojiKeyBoardView *keyBoardView;
@property (nonatomic, strong) UIView *showInView;
@property (nonatomic, assign) XFEmojiKeyBoardType topBarType;

@end

@implementation XFEmojiKeyBoard

static XFEmojiKeyBoard *keyBord = nil;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!keyBord) {
            keyBord = [[XFEmojiKeyBoard alloc]init];
        }
    });
    return keyBord;
}


- (void)showInView:(UIView *)view topBarType:(XFEmojiKeyBoardType)topBarType{
    
    self.topBarType = topBarType;
//    XFEmojiKeyBoard *new = [XFEmojiKeyBoard shareInstance];
    self.showInView = view;
    [view addSubview:self];
    
    self.frame = CGRectMake(0, 0, kScreenW, self.topBarView.height + self.keyBoardView.height);
    
    if (topBarType == XFEmojiKeyBoardTypeHideTopBar) {
        self.top = view.bottom;
//        self.top = kScreenH;
    }else{
        self.top = view.bottom - topBarHeight;
//        self.top = kScreenH - topBarHeight;
    }
    
    
    
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpViews];
        [self addNotifations];
        
    }
    return self;
}

- (void)setUpViews{
    
    self.topBarView = [[XFTopBarView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, topBarHeight)];
    self.topBarView.delegate = self;
    self.textView = self.topBarView.textView;
    _textViewFont = [self.textView.font copy];
    [self addSubview:self.topBarView];
    self.keyBoardView = [[XFEmojiKeyBoardView alloc]initWithFrame:CGRectMake(0, self.topBarView.bottom, kScreenW, keyBoardViewH + pageControlH + bottomBarH)];
    self.keyBoardView.delegate = self;
    [self addSubview:self.keyBoardView];
    __weak typeof(self)wself = self;
    [[NSNotificationCenter defaultCenter]addObserverForName:@"keyBoardChange" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        wself.height = wself.topBarView.height + wself.keyBoardView.keyBoardHeight;
        wself.keyBoardView.top = wself.topBarView.bottom;
        wself.bottom = wself.showInView.bottom;
    }];
    
    
    
    
}


- (void)setEmojiArr:(NSArray *)emojiArr{
    _emojiArr = emojiArr;
    self.keyBoardView.dataArr = emojiArr;
}


#pragma mark -----XFTopBarViewDelegate
- (void)topBarEmotionBtnClicked:(UIButton *)sender{
    _topBarBtn = sender;
    if (sender.selected) {
        [self handleHide];
        [self.textView resignFirstResponder];
        
    }else{
        
        [self.textView becomeFirstResponder];
//        [self handleHide];
    }
    
    
}

- (void)danMuBtnIsSelect:(BOOL)isSelect{
    if ([self.delegate respondsToSelector:@selector(changeDanMuSelect:)]) {
        [self.delegate changeDanMuSelect:isSelect];
    }
    
}

#pragma mark -----XFEmojiKeyBoardViewDelegate
- (void)insertEmoji:(XFEmojiModel *)emojiModel{
    XFTextAttachment *emojiTextAttachment = [XFTextAttachment new];
    UIImage *image = emojiModel.image;
    emojiTextAttachment.emojiStr = emojiModel.emojiStr;
    emojiTextAttachment.image = image;
    // 给附件设置尺寸
    
    CGFloat emojiHeigth = [self heightWithFont:self.textView.font];
    
    
    
    emojiTextAttachment.bounds = CGRectMake(0, -4, emojiHeigth, emojiHeigth);
    //textview插入富文本，用创建的附件初始化富文本
    [self.textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment] atIndex:self.textView.selectedRange.location];
    self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location + 1, self.textView.selectedRange.length);
    [self resetTextStyle];
}

- (void)sendAction{
    if ([self.delegate respondsToSelector:@selector(sendAllStr:)]) {
        [self.delegate sendAllStr:[self getPlainStringWithAttStr:self.textView.attributedText]];
        self.textView.text = @"";
        [self.topBarView resetSubsives];
    }
    
}

- (void)deletAction{
    [self.textView deleteBackward];
}




- (void)resetTextStyle {
    
    NSRange wholeRange = NSMakeRange(0, self.textView.textStorage.length);
    [self.textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [self.textView.textStorage addAttribute:NSFontAttributeName value:_textViewFont range:wholeRange];
    
    
    [self.textView scrollRectToVisible:CGRectMake(0, 0, self.textView.contentSize.width, self.textView.contentSize.height) animated:NO];

    //重新设置输入框视图的frame
    [self.topBarView resetSubsives];
}
- (NSString *)getPlainStringWithAttStr:(NSAttributedString *)attrStr {
    
    NSMutableString *plainString = [NSMutableString stringWithString:attrStr.string];
    __block NSUInteger base = 0;
    [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length)
                     options:0
                  usingBlock:^(XFTextAttachment *value, NSRange range, BOOL *stop) {
                      if (value) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:value.emojiStr];
                          base += value.emojiStr.length - 1;
                      }
                  }];
    return plainString;
}


//添加通知监听
- (void)addNotifations {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    NSValue *beginValue    = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect beginFrame      = beginValue.CGRectValue;
    CGRect endFrame        = endValue.CGRectValue;
    self.keyBoardView.keyBoardHeight = endFrame.size.height;
    BOOL isNeedHandle = beginFrame.size.height > 0 && beginFrame.origin.y - endFrame.origin.y > 0;
    
    CGFloat changeY = beginFrame.origin.y - endFrame.origin.y;
    
    //处理键盘走多次
    if (isNeedHandle) {
        //处理键盘弹出
        [self handleKeyBoardShow:endFrame];
    }
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    

    if (_topBarBtn.selected) {
        [self handleHide];
    }else{
        [self hideKeyBoard];
    }
}


//处理键盘弹出
- (void)handleKeyBoardShow:(CGRect)frame {
    if (_topBarBtn) {
        _topBarBtn.selected = NO;
    }
    
    
    [UIView animateWithDuration:XFKeyBoardTipTime animations:^{
        self.top = kScreenH - frame.size.height - self.topBarView.height;
        self.keyBoardView.alpha = 0;
    }];
    
    [self keyBoardChangeStatus:XFEmojiKeyBoardShowSystemKeyBoard];
}

- (void)handleHide{
    self.keyBoardView.keyBoardHeight = self.keyBoardView.height;
    self.height = self.topBarView.height + self.keyBoardView.keyBoardHeight;
    self.keyBoardView.top = self.bottom;
    self.keyBoardView.alpha = 1;
    [UIView animateWithDuration:XFKeyBoardTipTime animations:^{
        self.bottom = self.showInView.bottom;
        self.keyBoardView.top = self.topBarView.bottom;
    }];
    [self keyBoardChangeStatus:XFEmojiKeyBoardShowEmojiKeyBoard];
    
}

- (void)hideKeyBoard {
//    _isShow = NO;
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
    if (_topBarBtn) {
        _topBarBtn.selected = NO;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
   
        if (self.topBarType == XFEmojiKeyBoardTypeShowTopBar) {
            self.top = self.showInView.height - self.topBarView.height;
        }else{
            self.top = self.showInView.height;
        }
        
        
    }];
    
    [self keyBoardChangeStatus:XFEmojiKeyBoardHide];
    
}


- (void)keyBoardChangeStatus:(XFEmojiKeyBoardStatusType)status{
    
    if ([self.delegate respondsToSelector:@selector(changeKeyBoardStatus:)]) {
        [self.delegate changeKeyBoardStatus:status];
    }
    
}

- (CGFloat)heightWithFont:(UIFont *)font {
    
    if (!font){font = [UIFont systemFontOfSize:17];}
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize maxsize = CGSizeMake(100, MAXFLOAT);
    CGSize size = [@"/" boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;
}

@end
