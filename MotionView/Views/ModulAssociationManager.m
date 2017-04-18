//
//  ModulAssociation.m
//  Demo
//
//  Created by weixhe on 2017/4/14.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import "ModulAssociationManager.h"
#import "ModulModel.h"

static ModulAssociationManager *instance = nil;
@implementation ModulAssociationManager

+ (instancetype)manager {
    @synchronized (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[ModulAssociationManager alloc] init];
        });
    }
    return instance;
}

- (void)getModulData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"20170416023245" ofType:@"json"];
    
    _moduls = [ModulModel mj_objectArrayWithKeyValuesArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil]];
    
    
}

- (ModulModel *)currentModul {
    if (_moduls.count > 0) {
        
        for (ModulModel *modul in self.moduls) {
            if (modul.ID == self.currentModulID) {
                return modul;
            }
        }
    }
    return nil;
}

- (UIBezierPath *)circlePathWithFrame:(CGRect)circleRect {
    return [UIBezierPath bezierPathWithOvalInRect:circleRect];
}

- (UIBezierPath *)squarePathWithFrame:(CGRect)squareRect {
    return [UIBezierPath bezierPathWithRect:squareRect];
}

- (UIBezierPath *)roundPathWithFrame:(CGRect)roundRect radius:(CGFloat)radius {
    return [UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:radius];
}

- (UIBezierPath *)ellipsePathWithFrame:(CGRect)ellipseFrame {
    return [UIBezierPath bezierPathWithOvalInRect:ellipseFrame];
}

@end
