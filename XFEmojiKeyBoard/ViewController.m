//
//  ViewController.m
//  XFEmojiKeyBoard
//
//  Created by 李雪丰 on 2017/9/1.
//  Copyright © 2017年 李雪丰. All rights reserved.
//

#import "ViewController.h"
#import "XFEmojiKeyBoard.h"
#import "XFEmojiHeader.h"
#import "XMNChatExpressionManager.h"
#import "XFEmojiModel.h"


@interface ViewController ()<XFEmojiKeyBoardDelegate,UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSArray *allArr = [XMNChatExpressionManager sharedManager].dataArray;
    
    NSDictionary *mapper = [XMNChatExpressionManager sharedManager].qqMapper;
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSArray *arr in allArr) {
        NSMutableArray *tmpArr11 = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            XFEmojiModel *model = [[XFEmojiModel alloc]init];
            if (dic.allKeys.count) {
                model.emojiStr = dic.allKeys[0];
                model.imageName = dic[dic.allKeys[0]];
                model.image = [mapper objectForKey:model.emojiStr];
            }
            [tmpArr11 addObject:model];
        }
        
        [modelArr addObject:tmpArr11];
        
    }
    
    [[XFEmojiKeyBoard shareInstance] showInView:self.view topBarType:(XFEmojiKeyBoardTypeHideTopBar)];
    [XFEmojiKeyBoard shareInstance].emojiArr = modelArr;
    [XFEmojiKeyBoard shareInstance].delegate = self;
 
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(10, 10, 100, 100);
    btn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    

}

- (void)btnAction{
    [[XFEmojiKeyBoard shareInstance].textView becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[XFEmojiKeyBoard shareInstance] hideKeyBoard];
}

- (void)sendAllStr:(NSString *)str{
    NSLog(@"%@",str);
    
}

- (void)changeDanMuSelect:(BOOL)isSelect{
    
    
}

- (void)changeKeyBoardStatus:(XFEmojiKeyBoardStatusType)status{
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    [self disable_emoji:string];
    return [self disable_emoji:string];
}

// 屏蔽系统自带键盘的表情
- (BOOL)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches = [regex matchesInString:text options:kNilOptions range:NSMakeRange(0, text.length)];
    
    if (matches.count > 0) {
        return NO;
    }
    return YES;

}
@end
