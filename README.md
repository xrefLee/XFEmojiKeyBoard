# XFEmojiKeyBoard
# 表情键盘

### 效果展示:

* 表情分组显示
* 输入框高度自适应
* 输入框显示自定义表情图片


![Markdown preferences pane](https://github.com/xrefLee/XFEmojiKeyBoard/blob/master/PicSource/111.gif?raw=true) ![Markdown preferences pane](https://github.com/xrefLee/XFEmojiKeyBoard/blob/master/PicSource/222.gif?raw=true)
### 使用:
```
    [[XFEmojiKeyBoard shareInstance] showInView:self.view topBarType:(XFEmojiKeyBoardTypeHideTopBar)];
    [XFEmojiKeyBoard shareInstance].emojiArr = modelArr;
    [XFEmojiKeyBoard shareInstance].delegate = self;
```
***XFEmojiKeyBoardType (键盘展示类型)***

	* XFEmojiKeyBoardTypeShowTopBar // topBar 显示在底部 
	* XFEmojiKeyBoardTypeHideTopBar // topBar 隐藏
	
***emojiArr (数据)***

```
@[
	@[XFEmojiModel , XFEmojiModel , XFEmojiModel],
	@[XFEmojiModel , XFEmojiModel , XFEmojiModel],
	@[XFEmojiModel , XFEmojiModel , XFEmojiModel]
]
```

***XFEmojiKeyBoardDelegate (代理方法)***

```
/// 发送按钮点击代理方法
- (void)sendAllStr:(NSString *)str;
/// 弹幕按钮点击切换状态代理方法
- (void)changeDanMuSelect:(BOOL)isSelect;
/// 键盘状态代理方法
- (void)changeKeyBoardStatus:(XFEmojiKeyBoardStatusType)status;
```
### 特此说明:

* 借用了他人的算法实现 UICollectionView item 和表情图片相对应
* 借用SZTextView实现输入框 placeholder 
