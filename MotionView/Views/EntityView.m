//
//  EntityView.m
//  Demo
//
//  Created by weixhe on 2017/4/14.
//  Copyright © 2017年 com.fumubang. All rights reserved.
//

#import "EntityView.h"
#import "ModulAssociationManager.h"
#import "ModulModel.h"

@interface EntityView ()
{
    UIImageView *recordImageView;       // 记录被拖动的imageView
    CGRect recordSourceRect;            // 记录从哪个rect开始的滑动
    
    UIImageView *intersectImageView;    // 被交集的imageView
    CGRect intersectRect;               // 被交集的rect
}

@property (nonatomic, strong) UIImageView *shotImageView;

@property (nonatomic, strong) NSMutableDictionary *regularDic;  // 固定不动的数据源,存放imageView，在滑动过程中，regularDic随之变化，不滑动时包含所有的imageViews

@end

@implementation EntityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.regularDic = [NSMutableDictionary dictionary];

        [self setup];
    }
    return self;
}

- (void)setup {
    for (ModulPositionModel *positionModel in [ModulAssociationManager manager].currentModul.positions) {
        
        UIView *view = [[UIView alloc] initWithFrame:positionModel.rect];
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = YES;
        [self addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:positionModel.rect];
        [view addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        [self setView:imageView origin:CGPointZero];

        // 缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
//        pinchGestureRecognizer.delaysTouchesBegan = YES;
        [imageView addGestureRecognizer:pinchGestureRecognizer];
        
        // 添加数据源regularDic
        [self.regularDic setObject:imageView forKey:NSStringFromCGRect(positionModel.rect)];
    }
}

#pragma mark - Setter

- (UIImageView *)shotImageView {
    if (!_shotImageView) {
        _shotImageView = [[UIImageView alloc] init];
        UIView *view = [UIView new];
        view.hidden = YES;
        view.backgroundColor = [UIColor whiteColor];            // 白边
        [self addSubview:view];
        [view addSubview:_shotImageView];
    }
    return _shotImageView;
}

- (void)setImageNameArray:(NSArray<NSString *> *)imageNameArray {
    
    NSAssert(imageNameArray.count >= [ModulAssociationManager manager].currentModul.positions.count, @"图片数量不符合模板，请查看图片数量");
    
    _imageNameArray = imageNameArray;
    
    for (int i= 0; i < [ModulAssociationManager manager].currentModul.positions.count; i++) {
        UIImage * image = [UIImage imageNamed:[imageNameArray objectAtIndex:i]];
        NSAssert(image, @"图片为空，请查看图片名字是否正确");
        // 等比缩放imageView
        ModulPositionModel *position = [[ModulAssociationManager manager].currentModul.positions objectAtIndex:i];
        CGSize imageSize = [self genereteImageViewSizeByModulSize:CGSizeMake(CGRectGetWidth(position.rect), CGRectGetHeight(position.rect)) imageSize:image.size];
        
        UIImageView *imageView = [self.regularDic objectForKey:NSStringFromCGRect(position.rect)];
        imageView.image = image;
        [self setView:imageView size:imageSize];
    }
}

- (void)setView:(UIView *)view origin:(CGPoint)origin {
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}

- (void)setView:(UIView *)view size:(CGSize)size {
    CGRect frame = view.frame;
    frame.size = size;
    view.frame = frame;
}

/*!
 *  @brief 扩大rect为scale倍
 */
- (CGRect)setScaleRect:(CGRect)rect scale:(CGFloat)scale {
    CGRect doubleRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    return doubleRect;
}

#pragma mark - UIGestureAction
float _lastScale = 0.0f;
- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    UIGestureRecognizerState state = [gesture state];
    
    if (state == UIGestureRecognizerStateBegan) {
        _lastScale = [gesture scale];
    }
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [[gesture.view.layer valueForKeyPath:@"transform.scale"] floatValue];

        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 3.0;
        const CGFloat kMinScale = 1.0;
        
        CGFloat newScale = 1 -  (_lastScale - [gesture scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([gesture.view transform], newScale, newScale);
        gesture.view.transform = transform;
        _lastScale = [gesture scale];  // Store the previous scale factor for the next pinch gesture call
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateFailed) {
        [self recorveryFrameWithView:gesture.view];
    }
}

#pragma mark - Method

/*!
 *  @brief 生成目标image的尺寸，按照（宽和高小的rate）等比放缩
 */
- (CGSize)genereteImageViewSizeByModulSize:(CGSize)modulSize imageSize:(CGSize)imageSize {
    CGFloat rate = MIN(imageSize.height / modulSize.height, imageSize.width / modulSize.width);
    return CGSizeMake(imageSize.width / rate, imageSize.height / rate);
}

/*!
 *  @brief 交换移动的view 和 被交集的view
 */
- (void)exchangeTheIntersectImages {
    // 切换origin
    [self setView:intersectImageView.superview origin:recordSourceRect.origin];
    [self setView:intersectImageView origin:CGPointZero];
    
    [self setView:recordImageView.superview origin:intersectRect.origin];
    [self setView:recordImageView origin:CGPointZero];
    
    // 重置size
    [self setView:intersectImageView.superview size:recordSourceRect.size];
    [self setView:intersectImageView size:[self genereteImageViewSizeByModulSize:recordSourceRect.size imageSize:intersectImageView.image.size]];
    [self setView:recordImageView.superview size:intersectRect.size];
    [self setView:recordImageView size:[self genereteImageViewSizeByModulSize:intersectRect.size imageSize:recordImageView.image.size]];
    
    
    // 恢复regularDic 数据源， 交换key
    [self.regularDic setObject:recordImageView forKey:NSStringFromCGRect(intersectRect)];
    [self.regularDic setObject:intersectImageView forKey:NSStringFromCGRect(recordSourceRect)];
}

/*!
 *  @brief 恢复原 view 的位置, 黏着性
 */
- (void)recorveryFrameWithView:(UIView *)view {
    
    // 左边
    CGFloat x = MIN(CGRectGetMinX(view.frame), 0);
    // 上边
    CGFloat y = MIN(CGRectGetMinY(view.frame), 0);
    // 右边， 宽度
    CGFloat rightMove = CGRectGetMaxX(view.frame) - CGRectGetWidth(view.superview.frame);
    x = rightMove > 0 ? x : x - rightMove;
    // 左边， 高度
    CGFloat bottomMove = CGRectGetMaxY(view.frame) - CGRectGetHeight(view.superview.frame);
    y = bottomMove > 0 ? y : y - bottomMove;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setView:view origin:CGPointMake(x, y)];
    }];
}

/*!
 *  @brief 将截屏图片缩小，居中显示，留白边，动画
 */
- (void)scaleSmallTheShotView:(CGRect)rect {
    CGFloat padding = 5.0f;
    self.shotImageView.frame = CGRectMake(0, 0, CGRectGetWidth(rect) - padding, CGRectGetHeight(rect) - padding);
    self.shotImageView.center = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2);
    self.shotImageView.superview.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    self.shotImageView.superview.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/*!
 *  @brief 触点与目标view接触，隐藏目标，为了显示shot截屏缩小视图
 */
- (void)showShotView {
   
    self.shotImageView.image = [self shotViewWithFrame:[self setScaleRect:intersectRect scale:[UIScreen mainScreen].scale]];
    [self scaleSmallTheShotView:intersectRect];
    self.shotImageView.superview.hidden = NO;
    [self bringSubviewToFront:self.shotImageView.superview];
}

/*!
 *  @brief 触点与目标view离开，隐藏shot截屏，并显示目标（或切换后的目标）view
 */
- (void)hidenShotView {
    self.shotImageView.superview.hidden = YES;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];

    for (NSString *obj in self.regularDic.allKeys) {
        CGRect rect = CGRectFromString(obj);
        if (CGRectContainsPoint(rect, [touch locationInView:self])) {
            recordImageView = [self.regularDic objectForKey:obj];
            recordSourceRect = rect;
            [self.regularDic removeObjectForKey:obj];
            [self sendSubviewToBack:recordImageView];
            break;
        }
    }
}

static BOOL hasIntersect = NO;  // 是否有交集
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (recordImageView) {
        UITouch *touch = [touches anyObject];
        CGPoint preTouchPoint = [touch previousLocationInView:self];
        CGPoint touchPoint = [touch locationInView:self];
        CGPoint movePoint = CGPointMake(touchPoint.x - preTouchPoint.x, touchPoint.y - preTouchPoint.y);
        // 移动imageView
        recordImageView.center = CGPointMake(recordImageView.center.x + movePoint.x, recordImageView.center.y + movePoint.y);
        
        // 判断有没有数据源中其他的imageView有交集，如果有，则被交集的imageView缩小，如果没有则recordImageView继续移动
        
        if (hasIntersect) {     // 如果有交集，则往后只需要判断手指是否离开
            
            if (!CGRectContainsPoint(intersectRect, touchPoint)) {
                hasIntersect = NO;
                if (!_shotImageView.superview.hidden) {
                    [self hidenShotView];
                }
            }
            
        } else {                // 如果没有交集，则需要判断每一个image是否即将有交集
            
            for (NSString *obj in self.regularDic.allKeys) {
                CGRect rect = CGRectFromString(obj);
                
                if (CGRectContainsPoint(rect, touchPoint)) {
                    hasIntersect = YES;
                    // 有手指触点交集, 截屏，设置截屏view动画缩小
                    if (_shotImageView.superview.hidden) {
                        intersectImageView = [self.regularDic objectForKey:obj];
                        intersectRect = rect;
                        [self showShotView];
                    }
                    break;
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!recordImageView) {
        return;
    }
    
    // 移动结束后，判断recordImageView的位置
    if (!CGRectEqualToRect(recordImageView.frame, recordSourceRect)) {
        // 判断有没有数据源中其他的imageView有交集，如果有，则交换位置，如果没有则recordImageView恢复自己的位置
        
        if (hasIntersect) {
            
            // 交换移动的view 和 被交集的view
            [self exchangeTheIntersectImages];
            hasIntersect = NO;
            if (!_shotImageView.superview.hidden) {
                [self hidenShotView];
            }
            
        } else {
            
            // 没有与其他的imageView交集
            [self recorveryFrameWithView:recordImageView];
            // 恢复regularDic 数据源
            [self.regularDic setObject:recordImageView forKey:NSStringFromCGRect(recordSourceRect)];
        }
    } else {
        // 移动结束后，移动的image仍在原始框，即，点了一下或者移动后frame值没有变,不用调[self recorveryRecordImageViewFrame]方法
        // 恢复regularDic 数据源
        hasIntersect = NO;
        [self.regularDic setObject:recordImageView forKey:NSStringFromCGRect(recordSourceRect)];
    }
    recordImageView = nil;
}

// 例如：触摸过程中被来电打断
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!recordImageView) {
        return;
    }
    
    // 移动结束后，判断recordImageView的位置
    if (CGRectEqualToRect(recordImageView.frame, recordSourceRect)) {
        // 移动结束后，移动的image仍在原始框，即，点了一下或者移动后frame值没有变,不用调[self recorveryRecordImageViewFrame]方法
        // 恢复regularDic 数据源
        hasIntersect = NO;
        [self.regularDic setObject:recordImageView forKey:NSStringFromCGRect(recordSourceRect)];
    } else {
        // 移动了recordImageView
        [self recorveryFrameWithView:recordImageView];
        // 恢复regularDic 数据源
        [self.regularDic setObject:recordImageView forKey:NSStringFromCGRect(recordSourceRect)];
    }
    recordImageView = nil;
}

#pragma mark -|

/*!
 *  @brief 截屏
 */
- (UIImage *)shotViewWithFrame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    
    // 设置截屏大小
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(viewImage.CGImage, frame);   // 这里可以设置想要截图的区域
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    return sendImage;
}

@end
