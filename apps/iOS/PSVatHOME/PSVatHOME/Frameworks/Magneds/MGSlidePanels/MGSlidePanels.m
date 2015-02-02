//
//  MGSlidePanels.m
//
//
//  Created by Glenn Tillemans on 04-07-13.
//  Copyright (c) 2013 Magneds B.V. All rights reserved.
//

#import "MGSlidePanels.h"
#import "MGUtils.h"

@interface MGSlidePanels()

@property (nonatomic, strong) UIView *topPanelSnapshot;
@property (nonatomic, strong) UIView *statusbarSnapshot;
@property (nonatomic, assign) CGFloat initialTouchPositionX;
@property (nonatomic, assign) CGFloat initialHoizontalCenter;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *resetTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *topPanelSnapshotPanGesture;
@property (nonatomic, assign) BOOL leftShowing;
@property (nonatomic, assign) BOOL rightShowing;
@property (nonatomic, assign) BOOL topPanelIsOffScreen;
@property (nonatomic, assign) BOOL hideStatusBar;
@property (nonatomic, assign) BOOL moveStatusBar;
@property (nonatomic, assign) CGRect initialTopPanelFrame;

- (NSUInteger)autoResizeToFillScreen;
- (UIView *)topPanelView;
- (UIView *)leftPanelView;
- (UIView *)rightPanelView;
- (void)adjustLayout;
- (void)updateTopPanelHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)updateTopPanelHorizontalCenter:(CGFloat)newHorizontalCenter;
- (void)topPanelHorizontalCenterWillChange:(CGFloat)newHorizontalCenter;
- (void)topPanelHorizontalCenterDidChange:(CGFloat)newHorizontalCenter;
- (void)addTopPanelSnapshot;
- (void)removeTopPanelSnapshot;
- (CGFloat)anchorRightTopPanelCenter;
- (CGFloat)anchorLeftTopPanelCenter;
- (CGFloat)resettedCenter;
- (void)leftWillAppear;
- (void)rightWillAppear;
- (void)topDidReset;
- (BOOL)topPanelHasFocus;
- (void)updateLeftLayout;
- (void)updateRightLayout;

@end

@implementation UIViewController(SlidingViewExtension)

- (MGSlidePanels *)slidePanel
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[MGSlidePanels class]]))
    {
        viewController = viewController.parentViewController;
    }
    
    return (MGSlidePanels *)viewController;
}

@end

@implementation MGSlidePanels

@synthesize leftSlidePanel = _leftSlidePanel;
@synthesize rightSlidePanel = _rightSlidePanel;
@synthesize topSlidePanel = _topSlidePanel;
@synthesize anchorLeftPeekAmount;
@synthesize anchorRightPeekAmount;
@synthesize anchorLeftRevealAmount;
@synthesize anchorRightRevealAmount;
@synthesize rightWidthLayout = _rightWidthLayout;
@synthesize leftWidthLayout  = _leftWidthLayout;
@synthesize shouldAllowPanningPastAnchor;
@synthesize shouldAllowUserInteractionsWhenAnchored;
@synthesize shouldAddPanGestureRecognizerToTopPanelSnapshot;
@synthesize resetStrategy = _resetStrategy;

// category properties
@synthesize topPanelSnapshot;
@synthesize initialTouchPositionX;
@synthesize initialHoizontalCenter;
@synthesize panGesture = _panGesture;
@synthesize resetTapGesture;
@synthesize leftShowing   = _leftShowing;
@synthesize rightShowing  = _rightShowing;
@synthesize topPanelIsOffScreen = _topPanelIsOffScreen;
@synthesize topPanelSnapshotPanGesture = _topPanelSnapshotPanGesture;

- (void)setTopSlidePanel:(UIViewController *)topSlidePanel
{
    CGRect topPanelFrame = _topSlidePanel ? _topSlidePanel.view.frame : self.view.bounds;
    
    [self removeTopPanelSnapshot];
    [_topSlidePanel.view removeFromSuperview];
    [_topSlidePanel willMoveToParentViewController:nil];
    [_topSlidePanel removeFromParentViewController];
    
    _topSlidePanel = topSlidePanel;
    
    [self addChildViewController:_topSlidePanel];
    [_topSlidePanel didMoveToParentViewController:self];
    
    [_topSlidePanel.view setAutoresizingMask:self.autoResizeToFillScreen];
    [_topSlidePanel.view setFrame:topPanelFrame];
    _topSlidePanel.view.layer.shadowOffset = CGSizeZero;
    _topSlidePanel.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
    
    //    self.topPanelView.layer.shadowOpacity = 0.75f;
    //    self.topPanelView.layer.shadowRadius = 10.0f;
    //    self.topPanelView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
        
    [self.view addSubview:_topSlidePanel.view];
}

- (void)setLeftSlidePanel:(UIViewController *)leftSlidePanel
{
    [_leftSlidePanel.view removeFromSuperview];
    [_leftSlidePanel willMoveToParentViewController:nil];
    [_leftSlidePanel removeFromParentViewController];
    
    _leftSlidePanel = leftSlidePanel;
    
    if (_leftSlidePanel)
    {
        [self addChildViewController:_leftSlidePanel];
        [_leftSlidePanel didMoveToParentViewController:self];
        
        [self updateLeftLayout];
    }
}

- (void)setRightSlidePanel:(UIViewController *)rightSlidePanel
{
    [_rightSlidePanel.view removeFromSuperview];
    [_rightSlidePanel willMoveToParentViewController:nil];
    [_rightSlidePanel removeFromParentViewController];
    
    _rightSlidePanel = rightSlidePanel;
    
    if (_rightSlidePanel)
    {
        [self addChildViewController:_rightSlidePanel];
        [_rightSlidePanel didMoveToParentViewController:self];
        
        [self updateRightLayout];
    }
}

- (void)setLeftWidthLayout:(MGViewWidthLayout)leftWidthLayout
{
    if (leftWidthLayout == MGViewVariableRevealWidth && self.anchorRightPeekAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorRightPeekAmount must be set"];
    }
    else if (leftWidthLayout == MGViewFixedRevealWidth && self.anchorRightRevealAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorRightRevealAmount must be set"];
    }
    
    _leftWidthLayout = leftWidthLayout;
}

- (void)setRightWidthLayout:(MGViewWidthLayout)rightWidthLayout
{
    if (rightWidthLayout == MGViewVariableRevealWidth && self.anchorLeftPeekAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorLeftPeekAmount must be set"];
    }
    else if (rightWidthLayout == MGViewFixedRevealWidth && self.anchorLeftRevealAmount <= 0)
    {
        [NSException raise:@"Invalid Width Layout" format:@"anchorLeftRevealAmount must be set"];
    }
    
    _rightWidthLayout = rightWidthLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moveStatusBar = NO;
    self.hideStatusBar = NO;
    self.shouldAllowPanningPastAnchor = YES;
    self.shouldAllowUserInteractionsWhenAnchored = NO;
    self.shouldAddPanGestureRecognizerToTopPanelSnapshot = NO;
    self.resetTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTopPanel)];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateTopPanelHorizontalCenterWithRecognizer:)];
    self.resetTapGesture.enabled = NO;
    self.resetStrategy = MGResetTapping | MGResetPanning;
    
    self.topPanelSnapshot = [[UIView alloc] initWithFrame:self.topPanelView.bounds];
    [self.topPanelSnapshot setAutoresizingMask:self.autoResizeToFillScreen];
    [self.topPanelSnapshot addGestureRecognizer:self.resetTapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.topPanelView.layer.shadowOffset = CGSizeZero;
    self.topPanelView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
    [self adjustLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.topPanelView.layer.shadowPath = nil;
    self.topPanelView.layer.shouldRasterize = YES;
    
    if(![self topPanelHasFocus]){
        [self removeTopPanelSnapshot];
    }
    
    [self adjustLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.topPanelView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
    self.topPanelView.layer.shouldRasterize = NO;
    
    if(![self topPanelHasFocus])
    {
        [self addTopPanelSnapshot];
    }
}

- (void)setResetStrategy:(MGResetStrategy)resetStrategy
{
    _resetStrategy = resetStrategy;
    if (_resetStrategy & MGResetTapping)
    {
        self.resetTapGesture.enabled = YES;
    }
    else
    {
        self.resetTapGesture.enabled = NO;
    }
}

- (void)adjustLayout
{
    self.topPanelSnapshot.frame = self.topPanelView.bounds;
    
    if ([self rightShowing] && ![self topPanelIsOffScreen])
    {
        [self updateRightLayout];
        [self updateTopPanelHorizontalCenter:self.anchorLeftTopPanelCenter];
    }
    else if ([self rightShowing] && [self topPanelIsOffScreen])
    {
        [self updateRightLayout];
        [self updateTopPanelHorizontalCenter:-self.resettedCenter];
    }
    else if ([self leftShowing] && ![self topPanelIsOffScreen])
    {
        [self updateLeftLayout];
        [self updateTopPanelHorizontalCenter:self.anchorRightTopPanelCenter];
    }
    else if ([self leftShowing] && [self topPanelIsOffScreen])
    {
        [self updateLeftLayout];
        [self updateTopPanelHorizontalCenter:self.view.bounds.size.width + self.resettedCenter];
    }
}

- (void)updateTopPanelHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint currentTouchPoint = [recognizer locationInView:self.view];
    CGFloat currentTouchPositionX = currentTouchPoint.x;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.initialTouchPositionX = currentTouchPositionX;
        self.initialHoizontalCenter = self.topPanelView.center.x;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat panAmount = self.initialTouchPositionX - currentTouchPositionX;
        CGFloat newCenterPosition = self.initialHoizontalCenter - panAmount;
        
        if ((newCenterPosition < self.resettedCenter &&
             (self.anchorLeftTopPanelCenter == NSNotFound ||
              self.rightPanelView == nil)) ||
            (newCenterPosition > self.resettedCenter &&
             (self.anchorRightTopPanelCenter == NSNotFound ||
              self.leftPanelView == nil)))
        {
            newCenterPosition = self.resettedCenter;
        }
        
        BOOL newCenterPositionIsOutsideAnchor = newCenterPosition < self.anchorLeftTopPanelCenter || self.anchorRightTopPanelCenter < newCenterPosition;
        
        if ((newCenterPositionIsOutsideAnchor &&
             self.shouldAllowPanningPastAnchor) ||
            !newCenterPositionIsOutsideAnchor)
        {
            [self topPanelHorizontalCenterWillChange:newCenterPosition];
            [self updateTopPanelHorizontalCenter:newCenterPosition];
            [self topPanelHorizontalCenterDidChange:newCenterPosition];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint currentVelocityPoint = [recognizer velocityInView:self.view];
        CGFloat currentVelocityX     = currentVelocityPoint.x;
        
        if ([self leftShowing] && currentVelocityX > 100)
        {
            [self anchorTopPanelTo:MGSideRight];
        }
        else if ([self rightShowing] && currentVelocityX < 100)
        {
            [self anchorTopPanelTo:MGSideLeft];
        }
        else
        {
            [self resetTopPanel];
        }
    }
}

- (UIPanGestureRecognizer *)panGesture
{
    return _panGesture;
}

- (void)anchorTopPanelTo:(MGSide)side
{
    [self anchorTopPanelTo:side animations:nil onComplete:nil];
}

- (void)anchorTopPanelTo:(MGSide)side animations:(void (^)())animations onComplete:(void (^)())complete
{
    if(([MGUtils isIOS7] || [MGUtils isIOS8]) && self.moveStatusBar)
        [self addsStatusbarSnapshot];
    
    CGFloat newCenter = self.topPanelView.center.x;
    
    if (side == MGSideLeft)
    {
        newCenter = self.anchorLeftTopPanelCenter;
    }
    else if (side == MGSideRight)
    {
        newCenter = self.anchorRightTopPanelCenter;
    }
    
    [self topPanelHorizontalCenterWillChange:newCenter];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         if (animations)
                         {
                             animations();
                         }
                         [self updateTopPanelHorizontalCenter:newCenter];
                     }
                     completion:^(BOOL finished) {
                         if (_resetStrategy & MGResetPanning)
                         {
                             self.panGesture.enabled = YES;
                         }
                         else
                         {
                             self.panGesture.enabled = NO;
                         }
                         if (complete)
                         {
                             complete();
                         }
                         
                         _topPanelIsOffScreen = NO;
                         [self addTopPanelSnapshot];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSString *key = (side == MGSideLeft) ? kMGSlidePanelTopDidAnchorLeft : kMGSlidePanelTopDidAnchorRight;
                             [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
                         });
                     }
     ];
}

- (void)anchorTopPanelOffScreenTo:(MGSide)side
{
    [self anchorTopPanelOffScreenTo:side animations:nil onComplete:nil];
}

- (void)anchorTopPanelOffScreenTo:(MGSide)side animations:(void(^)())animations onComplete:(void(^)())complete
{
    CGFloat newCenter = self.topPanelView.center.x;
    
    if (side == MGSideLeft)
    {
        newCenter = -self.resettedCenter;
    }
    else if (side == MGSideRight)
    {
        newCenter = self.view.bounds.size.width + self.resettedCenter;
    }
    
    [self topPanelHorizontalCenterWillChange:newCenter];
    
    [UIView animateWithDuration:0.25f animations:^{
        if (animations)
        {
            animations();
        }
        [self updateTopPanelHorizontalCenter:newCenter];
    }
                     completion:^(BOOL finished)
     {
         if (complete)
         {
             complete();
         }
         _topPanelIsOffScreen = YES;
         [self addTopPanelSnapshot];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *key = (side == MGSideLeft) ? kMGSlidePanelTopDidAnchorLeft : kMGSlidePanelTopDidAnchorRight;
             [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
         });
     }];
}

- (void)resetTopPanel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMGSlidePanelTopWillReset object:self userInfo:nil];
    });
    [self resetTopPanelWithAnimations:nil onComplete:nil];
}

- (void)resetTopPanelWithAnimations:(void(^)())animations onComplete:(void(^)())complete
{
    [self topPanelHorizontalCenterWillChange:self.resettedCenter];
    
    [UIView animateWithDuration:0.25f animations:^{
        if (animations)
        {
            animations();
        }
        [self updateTopPanelHorizontalCenter:self.resettedCenter];
    }
                     completion:^(BOOL finished)
     {
         if (complete)
         {
             complete();
         }
         [self topPanelHorizontalCenterDidChange:self.resettedCenter];
     }];
}

- (void)firstRun
{
    if(([MGUtils isIOS7] || [MGUtils isIOS8]) && self.moveStatusBar)
        [self addsStatusbarSnapshot];
    
    CGFloat newCenter = self.topPanelView.center.x;
    
    newCenter = self.resettedCenter + 100;
    
    [self topPanelHorizontalCenterWillChange:newCenter];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         [self updateTopPanelHorizontalCenter:newCenter];
                     }
                     completion:^(BOOL finished) {
                         if (_resetStrategy & MGResetPanning)
                         {
                             self.panGesture.enabled = YES;
                         }
                         else
                         {
                             self.panGesture.enabled = NO;
                         }
                         
                         _topPanelIsOffScreen = NO;
                         [self addTopPanelSnapshot];
                         
                         [self performSelector:@selector(resetTopPanel) withObject:nil afterDelay:0.25];
                     }
     ];
}

- (NSUInteger)autoResizeToFillScreen
{
    return (UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin);
}

- (UIView *)topPanelView
{
    return self.topSlidePanel.view;
}

- (UIView *)leftPanelView
{
    return self.leftSlidePanel.view;
}

- (UIView *)rightPanelView
{
    return self.rightSlidePanel.view;
}

- (void)updateTopPanelHorizontalCenter:(CGFloat)newHorizontalCenter
{
    CGPoint center = self.topPanelView.center;
    center.x = newHorizontalCenter;
    self.topPanelView.layer.position = center;
}

- (void)topPanelHorizontalCenterWillChange:(CGFloat)newHorizontalCenter
{
    CGPoint center = self.topPanelView.center;
    
    if (center.x >= self.resettedCenter && newHorizontalCenter == self.resettedCenter)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kMGSlidePanelLeftWillDisappear object:self userInfo:nil];
        });
    }
    
    if (center.x <= self.resettedCenter && newHorizontalCenter == self.resettedCenter)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kMGSlidePanelRightWillDisappear object:self userInfo:nil];
        });
    }
    
    if (center.x <= self.resettedCenter && newHorizontalCenter > self.resettedCenter)
    {
        [self leftWillAppear];
    }
    else if (center.x >= self.resettedCenter && newHorizontalCenter < self.resettedCenter)
    {
        [self rightWillAppear];
    }
}

- (void)topPanelHorizontalCenterDidChange:(CGFloat)newHorizontalCenter
{
    if (newHorizontalCenter == self.resettedCenter)
    {
        [self topDidReset];
    }
}

- (void)addTopPanelSnapshot
{
    if (!self.topPanelSnapshot.superview && !self.shouldAllowUserInteractionsWhenAnchored)
    {
        topPanelSnapshot.layer.contents = (id)[UIImage imageWithUIView:self.topPanelView].CGImage;
        
        if (self.shouldAddPanGestureRecognizerToTopPanelSnapshot && (_resetStrategy & MGResetPanning))
        {
            if (!_topPanelSnapshotPanGesture)
            {
                _topPanelSnapshotPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateTopPanelHorizontalCenterWithRecognizer:)];
            }
            [topPanelSnapshot addGestureRecognizer:_topPanelSnapshotPanGesture];
        }
        [self.topPanelView addSubview:self.topPanelSnapshot];
    }
}

- (void)removeTopPanelSnapshot
{
    if (self.topPanelSnapshot.superview)
        [self.topPanelSnapshot removeFromSuperview];
    
    if([MGUtils isIOS7] || [MGUtils isIOS8])
        [self removeStatusbarSnapshot];
}

- (void)addsStatusbarSnapshot
{
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat statusBarHeight = CGRectGetHeight(statusBarFrame);
    
    CGRect statusBarContainerRect = CGRectZero;
    statusBarContainerRect.origin.y = -statusBarHeight;
    statusBarContainerRect.size = CGSizeMake(CGRectGetWidth(statusBarFrame), statusBarHeight);
    
    //    self.statusbarSnapshot = [[UIView alloc] initWithFrame:statusBarContainerRect];
    self.statusbarSnapshot = [[UIView alloc] initWithFrame:self.topPanelView.frame];
    
    UIView *screenShot = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    [self.statusbarSnapshot addSubview:screenShot];
    [self.statusbarSnapshot setClipsToBounds:YES];
    [self.topPanelView addSubview:self.statusbarSnapshot];
    [self setStatusBarHidden:YES];
    
    self.initialTopPanelFrame = self.topPanelView.frame;
    
    //    CGRect rect = self.topPanelView.frame;
    //    rect.origin.y += statusBarHeight;
    //    rect.size.height -= statusBarHeight;
    //    self.topPanelView.frame = rect;
}

- (void)removeStatusbarSnapshot
{
    if(self.statusbarSnapshot.superview)
        [self.statusbarSnapshot removeFromSuperview];
    
    self.topPanelView.frame = self.initialTopPanelFrame;
    
    [self setStatusBarHidden:NO];
}

- (void)setStatusBarHidden:(BOOL)hidden
{
    BOOL UIViewControllerBasedStatusBarAppearance = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue];
    if (!UIViewControllerBasedStatusBarAppearance)
    {
        self.hideStatusBar = hidden;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [UIApplication sharedApplication].statusBarHidden = hidden;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return self.hideStatusBar;
}

- (BOOL)moveStatusBar:(BOOL)moveStatusBar
{
    self.moveStatusBar = moveStatusBar;
    return moveStatusBar;
}


- (CGFloat)anchorRightTopPanelCenter
{
    if (self.anchorRightPeekAmount)
    {
        return self.view.bounds.size.width + self.resettedCenter - self.anchorRightPeekAmount;
    }
    else if (self.anchorRightRevealAmount)
    {
        return self.resettedCenter + self.anchorRightRevealAmount;
    }
    else
    {
        return NSNotFound;
    }
}

- (CGFloat)anchorLeftTopPanelCenter
{
    if (self.anchorLeftPeekAmount)
    {
        return -self.resettedCenter + self.anchorLeftPeekAmount;
    }
    else if (self.anchorLeftRevealAmount)
    {
        return -self.resettedCenter + (self.view.bounds.size.width - self.anchorLeftRevealAmount);
    }
    else
    {
        return NSNotFound;
    }
}

- (CGFloat)resettedCenter
{
    return (self.view.bounds.size.width / 2);
}

- (void)leftWillAppear
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMGSlidePanelLeftWillAppear object:self userInfo:nil];
    });
    
    [self.rightPanelView removeFromSuperview];
    [self updateLeftLayout];
    [self.view insertSubview:self.leftPanelView belowSubview:self.topPanelView];
    _leftShowing  = YES;
    _rightShowing = NO;
}

- (void)rightWillAppear
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMGSlidePanelRightWillAppear object:self userInfo:nil];
    });
    
    [self.leftPanelView removeFromSuperview];
    [self updateRightLayout];
    [self.view insertSubview:self.rightPanelView belowSubview:self.topPanelView];
    _leftShowing  = NO;
    _rightShowing = YES;
}

- (void)topDidReset
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMGSlidePanelTopDidReset object:self userInfo:nil];
    });
    
    [self.topPanelView removeGestureRecognizer:self.resetTapGesture];
    [self removeTopPanelSnapshot];
    self.panGesture.enabled = YES;
    [self.rightPanelView removeFromSuperview];
    [self.leftPanelView removeFromSuperview];
    _leftShowing   = NO;
    _rightShowing  = NO;
    _topPanelIsOffScreen = NO;
}

- (BOOL)topPanelHasFocus
{
    return !_leftShowing && !_rightShowing && !_topPanelIsOffScreen;
}

- (void)updateLeftLayout
{
    if (self.leftWidthLayout == MGViewFullWidth)
    {
        [self.leftPanelView setAutoresizingMask:self.autoResizeToFillScreen];
        [self.leftPanelView setFrame:self.view.bounds];
    }
    else if (self.leftWidthLayout == MGViewVariableRevealWidth && !self.topPanelIsOffScreen)
    {
        CGRect frame = self.view.bounds;
        
        frame.size.width = frame.size.width - self.anchorRightPeekAmount;
        self.leftPanelView.frame = frame;
    }
    else if (self.leftWidthLayout == MGViewFixedRevealWidth)
    {
        CGRect frame = self.view.bounds;
        
        frame.size.width = self.anchorRightRevealAmount;
        self.leftPanelView.frame = frame;
    }
    else
    {
        [NSException raise:@"Invalid Width Layout" format:@"leftWidthLayout must be a valid MGViewWidthLayout"];
    }
}

- (void)updateRightLayout
{
    if (self.rightWidthLayout == MGViewFullWidth)
    {
        [self.rightPanelView setAutoresizingMask:self.autoResizeToFillScreen];
        [self.rightPanelView setFrame:self.view.bounds];
    }
    else if (self.rightWidthLayout == MGViewVariableRevealWidth)
    {
        CGRect frame = self.view.bounds;
        
        CGFloat newLeftEdge;
        CGFloat newWidth = frame.size.width;
        
        if (self.topPanelIsOffScreen)
        {
            newLeftEdge = 0;
        }
        else
        {
            newLeftEdge = self.anchorLeftPeekAmount;
            newWidth   -= self.anchorLeftPeekAmount;
        }
        
        frame.origin.x   = newLeftEdge;
        frame.size.width = newWidth;
        
        self.rightPanelView.frame = frame;
    }
    else if (self.rightWidthLayout == MGViewFixedRevealWidth)
    {
        CGRect frame = self.view.bounds;
        
        CGFloat newLeftEdge = frame.size.width - self.anchorLeftRevealAmount;
        CGFloat newWidth = self.anchorLeftRevealAmount;
        
        frame.origin.x   = newLeftEdge;
        frame.size.width = newWidth;
        
        self.rightPanelView.frame = frame;
    }
    else
    {
        [NSException raise:@"Invalid Width Layout" format:@"rightWidthLayout must be a valid MGViewWidthLayout"];
    }
}

@end
