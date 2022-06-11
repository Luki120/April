@import UIKit;


@interface APPAnimatedTitleView : UIView
- (id)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset;
- (void)adjustLabelPositionToScrollOffset:(CGFloat)offset;
@end
