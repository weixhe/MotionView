//
//  EntityView.h
//  Demo
//
//  Created by weixhe on 2017/4/14.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntityView : UIView

@property (nonatomic, strong) NSArray <NSString *> *imageNameArray;

- (UIImage *)shotViewWithFrame:(CGRect)frame;
@end
