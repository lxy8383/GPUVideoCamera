//
//  PlayControlView.m
//  LXYVideoCapture
//
//  Created by liuxy on 2019/3/12.
//  Copyright © 2019年 liuxy. All rights reserved.
//

#import "PlayControlView.h"

@implementation PlayControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self layUI];
    }
    return self;
}
- (void)layUI
{
    [self addSubview:self.captureButton];
    self.captureButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.f - 40, [UIScreen mainScreen].bounds.size.height - 140, 60, 60);
    
    [self addSubview:self.filterButton];
    self.filterButton.frame = CGRectMake(40, 50, 50, 50);

}

#pragma mark - 按钮点击

- (void)captureViewAction:(UIButton *)sender
{
    if(sender.tag == 40001){
        
        if(!_captureButton.selected){
            [_captureButton setTitle:@"暂停" forState:UIControlStateNormal];
        }else{
            [_captureButton setTitle:@"拍摄" forState:UIControlStateNormal];
        }
        if([self.delegate respondsToSelector:@selector(startCapture:)]){
            [self.delegate startCapture:!_captureButton.selected];
        }
        _captureButton.selected = !_captureButton.selected;

    }else if(sender.tag == 40002){
        
        if([self.delegate respondsToSelector:@selector(setUpFilter:)]){
            [self.delegate setUpFilter:!_filterButton.selected];
        }
        _filterButton.selected = !_filterButton.selected;
    }
}

#pragma mark - lazy
- (UIButton *)captureButton
{
    if(!_captureButton){
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captureButton.backgroundColor = [UIColor redColor];
        [_captureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_captureButton addTarget:self action:@selector(captureViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_captureButton setTitle:@"拍摄" forState:UIControlStateNormal];
        _captureButton.tag = 40001;
    }
    return _captureButton;
}

- (UIButton *)filterButton
{
    if(!_filterButton){
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterButton.backgroundColor = [UIColor yellowColor];
        [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_filterButton addTarget:self action:@selector(captureViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
        _filterButton.tag = 40002;
    }
    return _filterButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
