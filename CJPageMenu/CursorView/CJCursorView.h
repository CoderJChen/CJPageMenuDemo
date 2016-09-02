//
//  CJCursorView.h
//  CJPageMenu
//
//  Created by chenjie on 16/8/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJCursorView : UIView
/**
 *  底部标识线
 */
@property (nonatomic, strong) UIView *lineView;
/**
    当前所在controller，必须赋值
 */
@property (nonatomic, strong) UIViewController * parentViewController;
/** 当前所在容器底部的高度 */
@property (nonatomic, assign) CGFloat contentViewHeight;
/** 添加的viewcontroller的实例，绘制界面时，会把viewController的view添加在scrollView上 */
@property (nonatomic,strong)NSArray * controllers;
/** 标题和显示的页面的数量相同 */
@property (nonatomic,strong)NSArray * titles;
/** 常规颜色是黑色，选中颜色是红色 */
@property (nonatomic,strong)UIColor * normalColor;
@property (nonatomic,strong)UIColor * selectColor;
/** 常规字体是14，选中字体是16 */
@property (nonatomic,strong)UIFont * normalFont;
@property (nonatomic,strong)UIFont * selectFont;
 /**当前选中的index。可以设置当前的index*/
@property (nonatomic, assign) NSInteger currentIndex;
/** 分割线位置调整。总是居中显示  默认(0,3,2,3) 上0左3下2右3*/
@property (nonatomic,assign)UIEdgeInsets lineEdgeInset;
/** 选择区域调整。默认(0,10,0,10) */
@property (nonatomic,assign)UIEdgeInsets cursorEdgeInset;
/**刷新列表*/
- (void)reloadPages;



@end
