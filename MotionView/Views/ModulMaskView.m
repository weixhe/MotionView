//
//  Mould1.m
//  Demo
//
//  Created by weixhe on 2017/4/14.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import "ModulMaskView.h"
#import "ModulAssociationManager.h"
#import "ModulModel.h"

@interface ModulMaskView ()

@end

@implementation ModulMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        squareRect = CGRectMake(30,50,100, 100);
//        circleRect = CGRectMake(CGRectGetMidX(self.frame), 180, 100, 100);
//        roundRect = CGRectMake(160,50,100, 150);
        
        self.backgroundColor = [UIColor clearColor];        // 固定的透明
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // 中间镂空的矩形框
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    [path setUsesEvenOddFillRule:YES];
    ModulModel *modul = [[ModulAssociationManager manager] currentModul];
    
    for (ModulPositionModel *position in modul.positions) {
        
        switch (position.modulStyle) {
            case ModulStyleForSquare:
                [path appendPath:[[ModulAssociationManager manager] squarePathWithFrame:position.rect]];
                break;
            case ModulStyleForCircle:
                [path appendPath:[[ModulAssociationManager manager] circlePathWithFrame:position.rect]];
                break;
            case ModulStyleForRoundRect:
                [path appendPath:[[ModulAssociationManager manager] roundPathWithFrame:position.rect radius:position.radius]];
                break;
            case ModulStyleForEllipse:
                [path appendPath:[[ModulAssociationManager manager] ellipsePathWithFrame:position.rect]];
                break;
            
            default:
                break;
        }
    }
    
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
//    roundLayer.opacity = 0.5;
    [self.layer addSublayer:shapeLayer];
}


@end
