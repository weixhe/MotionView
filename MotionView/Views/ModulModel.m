//
//  ModulPosition.m
//  Demo
//
//  Created by weixhe on 2017/4/14.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import "ModulModel.h"

@implementation ModulModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id", @"positions":@"moduls"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"positions":@"ModulPositionModel"};
}

@end

@interface ModulPositionModel ()

@property (nonatomic, assign) int shape;

@property (nonatomic, copy) NSString *position;

@end

@implementation ModulPositionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"id":@"ID"};
}

- (ModulStyle)modulStyle {
    return _shape;
}

- (CGRect)rect {
    CGRect r = CGRectFromString(self.position);
    return r;
}

@end
