//
//  ViewController.m
//  CJPageMenu
//
//  Created by chenjie on 16/8/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "ViewController.h"
#import "CJCursorView.h"
@interface ViewController ()
@property(nonatomic,strong)CJCursorView * cursorView;
@property(nonatomic,strong)NSMutableArray * arr;
@property(nonatomic,strong)UILabel * label;
@end

@implementation ViewController
-(NSMutableArray *)arr{
    if (_arr==nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CJCursorView * cursorView = [[CJCursorView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 40)];
    cursorView.normalColor = [UIColor blackColor];
    cursorView.normalFont = [UIFont systemFontOfSize:14.0];
    cursorView.selectFont = [UIFont systemFontOfSize:16.0];
    cursorView.selectColor = [UIColor redColor];
    cursorView.parentViewController = self;
    cursorView.contentViewHeight = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(cursorView.bounds);
    NSArray * arrary = @[@"你好",@"鹤来了来了",@"nihaoninininin",@"嘿嘿和诶嘿嘿II嘿hi",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"安放的发生地方",@"page",@"menu",@"view",@"editor"];
    cursorView.titles = arrary;
    
    for (NSString * name in arrary) {
        [self addControllerView];
        self.label.text = name;
    }
    cursorView.controllers = self.arr;
    
    [self.view addSubview:cursorView];
    self.cursorView = cursorView;
    [cursorView reloadPages];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)addControllerView{
    
    UIViewController * controller = [[UIViewController alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255. green:arc4random_uniform(255)/255. blue:arc4random_uniform(255)/255. alpha:1.0];
    [controller.view addSubview:label];
    self.label = label;
    [self.arr addObject:controller];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
