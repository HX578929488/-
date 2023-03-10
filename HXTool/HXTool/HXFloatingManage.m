//
//  HXFloatingManage.m
//  HXTool
//
//  Created by 中威网 on 2023/3/8.
//

#import "HXFloatingManage.h"
#import "HXFloatingView.h"


static NSString *hxFloatingUrlPath = @"hxUrlCache.plist";

@interface HXFloatingManage ()
@property (nonatomic, strong) HXFloatingView *floatingView;
// url数据缓存池
@property (nonatomic, copy) NSMutableArray *urlCache;

// 准备保存
@property (nonatomic, assign) BOOL isSave;


@end

@implementation HXFloatingManage


// 管理类单例
+ (instancetype)sharedFloating {
    static HXFloatingManage *manage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[HXFloatingManage alloc] init];
    });
    
    return manage;
}

// 显示窗口
- (void)show:(id)view {
    [view addSubview:self.floatingView];
}


// 隐藏窗口
- (void)hide {
    [self.floatingView removeFromSuperview];
}


- (BOOL)writeUrlToFile:(NSString *)url body:(id)body {
    
    NSAssert([url isKindOfClass:[NSString class]], @"传字符串,不想处理其他类型。");
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
        body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else if ([body isKindOfClass:[NSData class]]) {
        body = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    }else if([body isKindOfClass:[NSError class]]){
        NSError *error = (NSError *)body;
        body = error.localizedDescription;
    }
    
    
    
    NSDictionary *dict = @{
        @"url":url,
        @"body":body
    };
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:hxFloatingUrlPath];
    // 检查文件是否存在
    if ([fileManager fileExistsAtPath:filePath]) {
        // 获取之前的数据
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        [self.urlCache addObjectsFromArray:array];
    }
    
    // 把新数据插入第一行
    [self.urlCache insertObject:dict atIndex:0];
        
    // 写入新的文件数据
    BOOL isSuccess = [self.urlCache writeToFile:filePath atomically:YES];
    if (isSuccess) {
        [self.urlCache removeAllObjects];
    }
    return isSuccess;
}

- (void)save {
    if (self.isSave) {

    }
}


// 获取url数据内容
- (NSArray *)getUrlDataSources {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:hxFloatingUrlPath];
    return [NSArray arrayWithContentsOfFile:filePath];
}

// 清空数据
- (void)clear {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:hxFloatingUrlPath];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

// 懒加载
- (HXFloatingView *)floatingView {
    if (!_floatingView) {
        _floatingView = [[HXFloatingView alloc] init];
    }
    return _floatingView;
}


- (NSMutableArray *)urlCache {
    if (!_urlCache) {
        _urlCache = [NSMutableArray arrayWithCapacity:10];
    }
    return _urlCache;
}

@end
