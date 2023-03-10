//
//  HXFloatingController.m
//  HXTool
//
//  Created by 中威网 on 2023/3/8.
//

#import "HXFloatingController.h"
#import "HXFloatingManage.h"

@interface HXFloatingDeitailController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIScrollView *scrollView;


@end


@implementation HXFloatingDeitailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
        
    self.detailString = [self.detailString stringByReplacingOccurrencesOfString:@"," withString:@",\n  "];

    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc] init];
    par.lineBreakMode = NSLineBreakByCharWrapping;
    par.lineSpacing = 5.f;
    CGSize size = [self.detailString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:par} context:nil].size;
    
    self.scrollView.contentSize = CGSizeMake(0, size.height);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.detailString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:par}];
    
    self.label.frame = CGRectMake(15, 0, self.scrollView.frame.size.width-30, size.height);
    self.label.numberOfLines = 0;
    self.label.attributedText = attStr;
    [self.scrollView addSubview:self.label];
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}


@end


@interface HXFloatingController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, strong) UIButton *clearButton;

@end

@implementation HXFloatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDataSources];
    [self setupViews];
}

- (void)setupViews {
    [self.view addSubview:self.tableView];
    
    self.clearButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30-45, [UIScreen mainScreen].bounds.size.height-30-45, 45, 45);
    [self.view addSubview:self.clearButton];
}

- (void)getDataSources {
    self.dataSources = [[HXFloatingManage sharedFloating] getUrlDataSources];
}

- (void)onClear {
    [[HXFloatingManage sharedFloating] clear];
    [self getDataSources];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = self.dataSources[indexPath.row][@"url"];
    cell.textLabel.numberOfLines = 0.f;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"selected line %ld",indexPath.row);
    
    HXFloatingDeitailController *vc = [[HXFloatingDeitailController alloc] init];
    vc.detailString = self.dataSources[indexPath.row][@"body"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView  {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSArray array];
    }
    return _dataSources;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] init];
        [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
        _clearButton.backgroundColor = [UIColor lightGrayColor];
        _clearButton.layer.cornerRadius = 45/2;
        _clearButton.layer.masksToBounds = YES;
        [_clearButton addTarget:self action:@selector(onClear) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

@end
