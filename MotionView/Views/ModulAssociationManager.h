//
//  ModulAssociation.h
//  Demo
//
//  Created by weixhe on 2017/4/14.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJExtension.h"
/*!
 *  @brief 模板关联类，标记了模板的类型，和模板中的各个组件、尺寸
 */
@class ModulModel;
@interface ModulAssociationManager : NSObject

@property (nonatomic, strong, readonly) NSArray <ModulModel *> *moduls;

@property (nonatomic, assign) int currentModulID;       // 设置当前选中的模板的ID

+ (instancetype)manager;

- (void)getModulData;

- (ModulModel *)currentModul;


- (UIBezierPath *)circlePathWithFrame:(CGRect)circleRect;
- (UIBezierPath *)squarePathWithFrame:(CGRect)squareRect;
- (UIBezierPath *)roundPathWithFrame:(CGRect)roundRect radius:(CGFloat)radius;
- (UIBezierPath *)ellipsePathWithFrame:(CGRect)ellipseFrame;

@end

