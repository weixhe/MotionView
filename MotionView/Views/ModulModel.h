//
//  ModulPosition.h
//  Demo
//
//  Created by weixhe on 2017/4/14.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJExtension.h"

typedef NS_ENUM(NSUInteger, ModulStyle) {
    ModulStyleForSquare = 1,            // 方块
    ModulStyleForRoundRect = 2,         // 圆角方块
    ModulStyleForCircle = 3,            // 圆
    ModulStyleForEllipse = 4,           // 椭圆

};


@class ModulPositionModel;
@interface ModulModel : NSObject

@property (nonatomic, assign) int ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray <ModulPositionModel *> *positions;

@end


@interface ModulPositionModel : NSObject

@property (nonatomic, assign) int ID;

@property (nonatomic, assign) CGFloat radius;  // 半径角度

@property (nonatomic, assign, readonly) ModulStyle modulStyle;

@property (nonatomic, assign, readonly) CGRect rect;

@end
