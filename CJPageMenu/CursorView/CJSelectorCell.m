//
//  CJSelectorCell.m
//  CJPageMenu
//
//  Created by chenjie on 16/8/8.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import "CJSelectorCell.h"

@interface CJSelectorCell()
@property(strong,nonatomic)UILabel *label;
@end

@implementation CJSelectorCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.normalFont = self.selectFont = [UIFont systemFontOfSize:14.0];
        self.normalColor = [UIColor whiteColor];
        self.selectColor = [UIColor redColor];
        
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}
-(void)setContent:(NSString *)content{
    _content = [content copy];
    _label.text = _content;
}
-(void)setSelected:(BOOL)selected{
    super.selected = selected;
    
    if (selected) {
        _label.textColor = self.selectColor;
        _label.font = self.selectFont;
    }else{
        _label.textColor = self.normalColor;
        _label.font = self.normalFont;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = self.contentView.bounds;
}
@end
