//
//  ZYPathButton.h
//  ZYPathButton
//
//  Created by tang dixi on 30/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

#import "ZYPathItemButton.h"

@import UIKit;
@import QuartzCore;
@import AudioToolbox;

@class ZYPathButton;

/*!
 *  The direction of a `ZYPathButton` object's bloom animation.
 */
typedef NS_ENUM(NSUInteger, kZYPathButtonBloomDirection) {
    /*!
     *  Bloom animation gose to the top of the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionTop = 1,
    /*!
     *  Bloom animation gose to top left of the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionTopLeft = 2,
    /*!
     *  Bloom animation gose to the left of the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionLeft = 3,
    /*!
     *  Bloom animation gose to bottom left of the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionBottomLeft = 4,
    /*!
     *  Bloom animation gose to the bottom of the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionBottom = 5,
    /*!
     *  Bloom animation gose to bottom right of the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionBottomRight = 6,
    /*!
     *  Bloom animation gose to the right of the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionRight = 7,
    /*!
     *  Bloom animation gose around the `ZYPathButton` object.
     */
    kZYPathButtonBloomDirectionTopRight = 8,
};

/*!
 *  `ZYPathButtonDelegate` protocol defines methods that inform the delegate object the events of item button's selection, presentation and dismissal.
 */
@protocol ZYPathButtonDelegate <NSObject>

/*!
 *  Tells the delegate that the item button at an index is clicked.
 *
 *  @param ZYPathButton    A `ZYPathButton` object informing the delegate about the button click.
 *  @param itemButtonIndex The index of the item button being clicked.
 */
- (void)pathButton:(ZYPathButton *)ZYPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex;

@optional

/*!
 *  Tells the delegate that the `ZYPathButton` object will present its items.
 *
 *  @param ZYPathButton A `ZYPathButton` object that is about to present its items.
 */
- (void)willPresentZYPathButtonItems:(ZYPathButton *)ZYPathButton;
/*!
 *  Tells the delegate that the `ZYPathButton` object has already presented its items.
 *
 *  @param ZYPathButton A `ZYPathButton` object that has presented its items.
 */
- (void)didPresentZYPathButtonItems:(ZYPathButton *)ZYPathButton;

/*!
 *  Tells the delegate that the `ZYPathButton` object will dismiss its items.
 *
 *  @param ZYPathButton A `ZYPathButton` object that is about to dismiss its items
 */
- (void)willDismissZYPathButtonItems:(ZYPathButton *)ZYPathButton;
/*!
 *  Tells the delegate that the `ZYPathButton` object has already dismissed its items.
 *
 *  @param ZYPathButton A `ZYPathButton` object that has dismissed its items.
 */
- (void)didDismissZYPathButtonItems:(ZYPathButton *)ZYPathButton;

@end

@interface ZYPathButton : UIView <UIGestureRecognizerDelegate>

/*!
 *  The object that acts as the delegate of the `ZYPathButton` object.
 */
@property (weak, nonatomic) id<ZYPathButtonDelegate> delegate;

/*!
 *  `ZYPathButton` object's bloom animation's duration.
 */
@property (assign, nonatomic) NSTimeInterval basicDuration;
/*!
 *  `YES` if allows `ZYPathButton` object's sub items to rotate. Otherwise `NO`.
 */
@property (assign, nonatomic) BOOL allowSubItemRotation;

/*!
 *  `ZYPathButton` object's bloom radius. The default value is 105.0f.
 */
@property (assign, nonatomic) CGFloat bloomRadius;

/*!
 *  `ZYPathButton` object's bloom angle.
 */
@property (assign, nonatomic) CGFloat bloomAngel;

/*!
 *  The center of a `ZYPathButton` object's position. The default value positions the `ZYPathButton` object in bottom center.
 */
@property (assign, nonatomic) CGPoint ZYButtonCenter;

/*!
 *  If set to `YES` a sound will be played when the `ZYPathButton` object is being interacted. The default value is `YES`.
 */
@property (assign, nonatomic) BOOL allowSounds;

/*!
 *  The path to the `ZYPathButton` object's bloom effect sound file.
 */
@property (copy, nonatomic) NSString *bloomSoundPath;

/*!
 *  The path to the `ZYPathButton` object's fold effect sound file.
 */
@property (copy, nonatomic) NSString *foldSoundPath;

/*!
 *  The path to the `ZYPathButton` object's item action sound file.
 */
@property (copy, nonatomic) NSString *itemSoundPath;

/*!
 *  `YES` if allows the `ZYPathButton` object's center button to rotate. Otherwise `NO`.
 */
@property (assign, nonatomic) BOOL allowCenterButtonRotation;

/*!
 *  Color of the backdrop view when `ZYPathButton` object's sub items are shown.
 */
@property (strong, nonatomic) UIColor *bottomViewColor;

/*!
 *  Direction of `ZYPathButton` object's bloom animation.
 */
@property (assign, nonatomic) kZYPathButtonBloomDirection bloomDirection;

/*!
 *  Creates a `ZYPathButton` object with a given normal image and highlited images for center button.
 *
 *  @param centerImage            The normal image for `ZYPathButton` object's center button.
 *  @param centerHighlightedImage The highlighted image for `ZYPathButton` object's center button.
 *
 *  @return A `ZYPathButton` object.
 */
- (instancetype)initWithCenterImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage;

/*!
 *  Creates a `ZYPathButton` object with a given frame, normal and highlighted images for its center button.
 *
 *  @param centerButtonFrame      The frame of `ZYPathButton` object.
 *  @param centerImage            The normal image for `ZYPathButton` object's center button.
 *  @param centerHighlightedImage The highlighted image for `ZYPathButton` object's center button.
 *
 *  @return A `ZYPathButton` object.
 */
- (instancetype)initWithButtonFrame:(CGRect)centerButtonFrame
                        centerImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage;

/*!
 *  Adds item buttons to an existing `ZYPathButton` object.
 *
 *  @param pathItemButtons The item buttons to be added.
 */
- (void)addPathItems:(NSArray *)pathItemButtons;

@end
