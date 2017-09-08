//
//  XMNChatExpressionManager.m
//  XMNChatFramework
//
//  Created by XMFraker on 16/5/31.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNChatExpressionManager.h"
//#import "XMNChatConfiguration.h"

#import "YYWebImage.h"

@interface XMNChatExpressionManager ()

@property (nonatomic, copy)   NSArray *qqEmotions;
@property (nonatomic, strong) NSBundle *qqBundle;

/** qq表情每页显示的数量 20个 */
@property (nonatomic, assign, readonly) NSInteger countPerPage;

@end

@implementation XMNChatExpressionManager

#pragma mark - Life Cycle
- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
        NSArray *array1=[self.qqEmotions subarrayWithRange:NSMakeRange(0, 60)];
        NSArray *array2=[self.qqEmotions subarrayWithRange:NSMakeRange(60, 9)];
        NSArray *array3=[self.qqEmotions subarrayWithRange:NSMakeRange(69, 22)];
        [_dataArray addObject:array1];
        [_dataArray addObject:array2];
        [_dataArray addObject:array3];
    }
    return _dataArray;
}
- (instancetype)init {
    
    if (self = [super init]) {
        
        //获取QQ表情解析格式
        
        /** 使用旧版QQ表情 */
       // self.qqBundle = [NSBundle bundleWithPath:[kXMNChatBundle pathForResource:@"FaceIcon" ofType:@"bundle"]];
        
        /** 使用最新版QQ表情 */
        self.qqBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"FaceIcon" ofType:@"bundle"]];

        self.qqEmotions =  [NSArray arrayWithContentsOfFile:[self.qqBundle pathForResource:@"info" ofType:@"plist"]];
        NSMutableDictionary *mapper = [NSMutableDictionary dictionary];
        NSMutableDictionary *gifMapper = [NSMutableDictionary dictionary];
        NSMutableDictionary *allPic = [NSMutableDictionary dictionary];
        NSMutableDictionary *keyMapDic = [NSMutableDictionary dictionary];
        
        __weak typeof(*&self) wSelf = self;
        [self.qqEmotions enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(*&wSelf) self = wSelf;
            mapper[obj.allKeys[0]] = [YYImage imageWithContentsOfFile:[self.qqBundle pathForResource:obj.allValues[0] ofType:@"png"]];
            /** 添加如果GIF表情不存在 使用PNG表情 */
            gifMapper[obj.allKeys[0]] = mapper[obj.allKeys[0]];
            [allPic setValuesForKeysWithDictionary:obj];
            keyMapDic[obj.allValues[0]] = obj.allKeys[0];
            
            
        }];
        _qqMapper = [mapper copy];
        _qqGifMapper = [gifMapper copy];
        _allPicDic = [allPic copy];
        _keyMapper = [keyMapDic copy];
    }
    return self;
}

+ (instancetype)sharedManager {
    
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

#pragma mark - Methods

- (NSArray *)emotionsAtIndexPath:(NSIndexPath *)aIndexPath {
    NSArray *array=self.dataArray[aIndexPath.section];
    if (aIndexPath.section == 0) {
        NSInteger index = MAX(aIndexPath.row * self.countPerPage, 0);
        if (index + self.countPerPage >= array.count) {
            NSInteger count =  array.count -  index;
            return [array subarrayWithRange:NSMakeRange(index, count)];
        }else {
            return [array subarrayWithRange:NSMakeRange(index, self.countPerPage)];
        }
    }else if(aIndexPath.section==1){
        NSInteger index = MAX(aIndexPath.row * 14, 0);
        if (index + 14 >= array.count) {
            NSInteger count =  array.count -  index;
            return [array subarrayWithRange:NSMakeRange(index, count)];
        }else {
            return [array subarrayWithRange:NSMakeRange(index, 14)];
        }
    }else if(aIndexPath.section==2){
        NSInteger index = MAX(aIndexPath.row * 11, 0);
        if (index + 11 >= array.count) {
            NSInteger count =  array.count -  index;
            return [array subarrayWithRange:NSMakeRange(index, count)];
        }else {
            return [array subarrayWithRange:NSMakeRange(index, 11)];
        }
    }
    return nil;
}

#pragma mark - Getters

- (NSInteger)countPerPage {
    return 20;
}

@end
