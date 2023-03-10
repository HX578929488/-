//
//  HXFloatingView.m
//  HXTool
//
//  Created by 中威网 on 2023/3/8.
//

#import "HXFloatingView.h"
#import "HXFloatingController.h"

// 左右间距
#define KFLOATING_WINDOW_LEFT_AND_RIGHT 5
// 顶部间距
#define KFLOATING_WINDOW_TOP 44


@interface HXFloatingView ()
@property (nonatomic, strong) UIImageView *floatingImageView;


@end


@implementation HXFloatingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // 设置背景透明
    self.frame = CGRectMake(KFLOATING_WINDOW_LEFT_AND_RIGHT, 180, 45, 45); // 默认位置
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.floatingImageView.frame = self.bounds;
    [self addSubview:self.floatingImageView];
    
    // 添加移动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFloatingWindow:)];
    [self addGestureRecognizer:pan];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFloatingWindow:)];
    [self addGestureRecognizer:tap];
}


- (void)panFloatingWindow:(UIPanGestureRecognizer *)pan {
    // 悬浮窗偏移量
    CGPoint transPoint = [pan translationInView:self];

    CGRect frame = self.frame;
    frame.origin.x = MIN(MAX(frame.origin.x + transPoint.x, KFLOATING_WINDOW_LEFT_AND_RIGHT), [UIScreen mainScreen].bounds.size.width-KFLOATING_WINDOW_LEFT_AND_RIGHT-self.frame.size.width);
    frame.origin.y = MIN(MAX(frame.origin.y + transPoint.y, KFLOATING_WINDOW_TOP), [UIScreen mainScreen].bounds.size.height-self.frame.size.height);
    self.frame = frame;
    
    NSLog(@"移动后Origin---%@",NSStringFromCGPoint(self.frame.origin));

    // 复位,表示相对上一次
    [pan setTranslation:CGPointZero inView:self];
}

- (UIImageView *)floatingImageView {
    if (!_floatingImageView) {
        _floatingImageView = [[UIImageView alloc] init];
        _floatingImageView.image = [UIImage imageNamed:@"floating_icon.png"];
    }
    return _floatingImageView;
}


- (void)tapFloatingWindow:(UITapGestureRecognizer *)tap {
    NSLog(@"点击了悬浮窗!!!!!!");
    
    HXFloatingController *vc = [[HXFloatingController alloc] init];
    [[self funResponderVC].navigationController pushViewController:vc animated:YES];
}


- (UIViewController *)funResponderVC{
    UIView *net = [super superview]; // 返回上一级的视图。直到找到UIViewController视图为止
    UIResponder *nextResponder = [net nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)nextResponder;
    } else{
        return nil;
    }
}

@end





@interface HXFloatingTableView ()

@end


@implementation HXFloatingTableView



@end
