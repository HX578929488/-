//
//  HXFloatingManage.h
//  HXTool
//
//  Created by 中威网 on 2023/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXFloatingManage : NSObject

+ (instancetype)sharedFloating;

// 显示窗口
- (void)show:(id)view;
// 隐藏窗口
- (void)hide;


// 保存网络数据
- (BOOL)writeUrlToFile:(NSString *)url body:(id)body;
// 获取url数据内容
- (NSArray *)getUrlDataSources;
// 清空数据
- (void)clear;

@end

NS_ASSUME_NONNULL_END
