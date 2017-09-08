# XFEmojiKeyBoard
# 表情键盘

### 介绍:


### 打包逻辑:
在 `项目文件路径` 中找到以 `project_name` 为前缀的.xcodeproj/.xcworkspace 构建 以 `project_name` 命名的ipa 文件至 `包生成路径`

### 上传逻辑:
1. 在 `包生成路径` 找到以 `project_name` 命名的 ipa 文件; 
2. 根据 `uKey` 和 `\_api\_key` 上传至蒲公英

#### 注意:
打包之前 Xcode 需配置好证书