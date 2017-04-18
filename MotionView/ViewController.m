//
//  ViewController.m
//  MotionView
//
//  Created by weixhe on 2017/4/17.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import "ViewController.h"
#import "EntityView.h"
#import "ModulMaskView.h"

#import "ModulAssociationManager.h"
#import "ModulModel.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    
    [[ModulAssociationManager manager] getModulData];
    [ModulAssociationManager manager].currentModulID = 1;       // 设置ID=1的modul
    
    EntityView *entityView = [[EntityView alloc] initWithFrame:self.view.bounds];
    entityView.imageNameArray = @[@"1.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    [self.view addSubview:entityView];
    
    ModulMaskView *maskView = [[ModulMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:maskView];
    maskView.userInteractionEnabled = NO;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
