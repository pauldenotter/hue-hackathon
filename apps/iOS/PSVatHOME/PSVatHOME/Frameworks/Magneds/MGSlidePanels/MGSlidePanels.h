//
//  MGSlidePanels.h
//  
//
//  Created by Glenn Tillemans on 04-07-13.
//  Copyright (c) 2013 Magneds B.V. All rights reserved.
//
//
//  MGSlidePanels is a ViewController that presents it's
//  ViewControllers in two different layers, the top layer
//  and the bottom layer. It provides a functionality to
//  swipe left or right to reveal the bottom layer.
//
//
//  USAGE:
//
//  Create an initialisation ViewController which is a
//  subclass of MGSlidePanels. Within this ViewController
//  point the self.topSlidePanel to the ViewController
//  that should be shown when the app starts.
//
//  Use self.slidePanel.leftSlidePanel and
//  self.slidePanel.rightSlidePanel to connect
//  ViewControllers that should be shown when swiping left
//  or right. If a sidePanel is not necesary set it to
//  nil.
//
//  Add the gesture recognizer to the current view by
//  calling :
//  [self.view addGestureRecognizer:self.slidePanel.panGesture];
//
//  Call [self.slidePanel anchorTopPanelTo:]; when opening
//  a panel through a button tap.
//
//  Set the [self.slidePanel setAnchorRightRevealAmount:];
//  or the [self.slidePanel setAnchorLeftRevealAmount:];
//  to configure the size of the sidePanel.
//
//  Or set [self.slidePanel setAnchorLeftPeekAmount:];
//  or the [self.slidePanel setAnchorRightPeekAmount:];
//  to configure the size of the topPanel.
//
//
//  Make sure to include the following frameworks into the
//  project:
//  - QuartzCore.framework
//


#import <UIKit/UIKit.h>
#import "UIImage+ImageWithUIView.h"


#define kMGSlidePanelRightWillAppear        @"kMGSlidePanelRightWillAppear"
#define kMGSlidePanelLeftWillAppear         @"kMGSlidePanelLeftWillAppear"
#define kMGSlidePanelRightWillDisappear     @"kMGSlidePanelRightWillDisappear"
#define kMGSlidePanelLeftWillDisappear      @"kMGSlidePanelLeftWillDisappear"
#define kMGSlidePanelTopDidAnchorLeft       @"kMGSlidePanelTopDidAnchorLeft"
#define kMGSlidePanelTopDidAnchorRight      @"kMGSlidePanelTopDidAnchorRight"
#define kMGSlidePanelTopWillReset           @"kMGSlidePanelTopWillReset"
#define kMGSlidePanelTopDidReset            @"kMGSlidePanelTopDidReset"

typedef enum {
    MGViewFullWidth,
    MGViewFixedRevealWidth,
    MGViewVariableRevealWidth
} MGViewWidthLayout;

typedef enum {
    MGSideLeft,
    MGSideRight
} MGSide;

typedef enum {
    MGResetNone = 0,
    MGResetTapping = 1 << 0,
    MGResetPanning = 1 << 1
} MGResetStrategy;


@interface MGSlidePanels : UIViewController
{
    CGPoint startTouchPosition;
    BOOL topPanelHasFocus;
}

@property (nonatomic, strong) UIViewController *leftSlidePanel;
@property (nonatomic, strong) UIViewController *rightSlidePanel;
@property (nonatomic, strong) UIViewController *topSlidePanel;

@property (nonatomic, assign) CGFloat anchorLeftPeekAmount;
@property (nonatomic, assign) CGFloat anchorRightPeekAmount;

@property (nonatomic, assign) CGFloat anchorLeftRevealAmount;
@property (nonatomic, assign) CGFloat anchorRightRevealAmount;

/*
 Specifies whether or not the top view can be panned past the anchor point.
 Set to NO if you don't want to show the empty space behind the top and 
 side views.
 By defaut, this is set to YES
 */
@property (nonatomic, assign) BOOL shouldAllowPanningPastAnchor;

/*
 Specifies if the user should be able to interact with the top view when it 
 is anchored.
 By default, this is set to NO
 */
@property (nonatomic, assign) BOOL shouldAllowUserInteractionsWhenAnchored;

/*
 Specifies if the top view snapshot requires a pan gesture recognizer.
 This is useful when panGesture is added to the navigation bar instead of 
 the main view.
 By default, this is set to NO
 */
@property (nonatomic, assign) BOOL shouldAddPanGestureRecognizerToTopPanelSnapshot;

/* 
 Specifies the behavior for the left width
 By default, this is set to MGViewFullWidth
 */
@property (nonatomic, assign) MGViewWidthLayout leftWidthLayout;

/*
 Specifies the behavior for the right width
 By default, this is set to MGViewFullWidth
 */
@property (nonatomic, assign) MGViewWidthLayout rightWidthLayout;

/*
 Returns the strategy for resetting the top view when it is anchored.
 By default, this is set to MGResetPanning | MGResetTapping to allow both 
 panning and tapping to reset the top view. If this is set to MGResetNone, 
 then there must be a custom way to reset the top view otherwise it will 
 stay anchored.
 */
@property (nonatomic, assign) MGResetStrategy resetStrategy;

/*
 Returns a horizontal panning gesture for moving the top view.
 This is typically added to the top view or a top view's navigation bar.
 */
- (UIPanGestureRecognizer *)panGesture;

/*
 Slides the top view in the direction of the specified side.
 A peek amount or reveal amount must be set for the given side. The top 
 view will anchor to one of those specified values.
 */
- (void)anchorTopPanelTo:(MGSide)side;

/*
 Slides the top view in the direction of the specified side.
 A peek amount or reveal amount must be set for the given side. The top 
 view will anchor to one of those specified values.
 */
- (void)anchorTopPanelTo:(MGSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

/*
 Slides the top view off of the screen in the direction of the specified 
 side.
 */
- (void)anchorTopPanelOffScreenTo:(MGSide)side;

/*
 Slides the top view off of the screen in the direction of the specified 
 side.
 */
- (void)anchorTopPanelOffScreenTo:(MGSide)side animations:(void(^)())animations onComplete:(void(^)())complete;

/*
 Slides the top view back to the center. 
 */
- (void)resetTopPanel;

/*
 Slides the top view back to the center.
 */
- (void)resetTopPanelWithAnimations:(void(^)())animations onComplete:(void(^)())complete;

/*
 show firstrun animation.
 TopPanel peeks to left and back to right.
 */
- (void)firstRun;

/*
 Move the iOS statusbar with the menu.
 Default is NO.
 */
- (BOOL)moveStatusBar:(BOOL)moveStatusBar;

/*
 Returns true if the left view is showing (even partially) 
 */
- (BOOL)leftShowing;

/*
 Returns true if the right view is showing (even partially)
 */
- (BOOL)rightShowing;

/*
 Returns true if the top view is completely off the screen 
 */
- (BOOL)topPanelIsOffScreen;

@end


/*
 Hacked in UIViewController Category
 Category is not working if imported as a different file so it'sincluded 
 directly into this file.
 */
@interface UIViewController(SlidingViewExtension)
/*
 Convience method for getting access to the MGSlidePanels instance 
 */
- (MGSlidePanels *)slidePanel;
@end
