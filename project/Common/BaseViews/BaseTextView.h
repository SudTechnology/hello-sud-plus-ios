//
//  BaseTextView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTextView : UITextView

/**
 *  The text to be displayed when the text view is empty. The default value is `nil`.
 */
@property (copy, nonatomic, nullable) NSString *placeHolder;

/**
 *  The color of the place holder text. The default value is `[UIColor lightGrayColor]`.
 */
@property (strong, nonatomic) UIColor *placeHolderTextColor;

/**
 *  The insets to be used when the placeholder is drawn. The default value is `UIEdgeInsets(5.0, 7.0, 5.0, 7.0)`.
 */
@property (assign, nonatomic) UIEdgeInsets placeHolderInsets;


/**
 When TextView height changed will call this block. You can set height changed animation
 in this block call - (void)layoutIfNeeded.
 */
@property (copy, nonatomic, nullable) void(^heightChangeBlock)(void);

/**
 *  Determines whether or not the text view contains text after trimming white space
 *  from the front and back of its string.
 *
 *  @return `YES` if the text view contains text, `NO` otherwise.
 */
//- (BOOL)hasText;

- (void)associateConstraints;

@end

NS_ASSUME_NONNULL_END
