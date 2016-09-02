//
//  CJSelectorCell.h
//  CJPageMenu
//
//  Created by chenjie on 16/8/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJSelectorCell : UICollectionViewCell
/** cell显示的内容 */
@property(nonatomic,copy)NSString *content;
/** 常规颜色是黑色，选中颜色是红色 */
@property (nonatomic,strong)UIColor * normalColor;
@property (nonatomic,strong)UIColor * selectColor;
/** 常规字体是14，选中字体是16 */
@property (nonatomic,strong)UIFont * normalFont;
@property (nonatomic,strong)UIFont * selectFont;
@end
