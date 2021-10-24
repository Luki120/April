@import UIKit;


@interface APPAnimatedTitleView : UIView
- (instancetype)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset;
- (void)adjustLabelPositionToScrollOffset:(CGFloat)offset;
@end