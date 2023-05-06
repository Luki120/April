@import GcUniversal.ColorPickerUtils;
@import GcUniversal.ImagePickerUtils;
@import ObjectiveC.runtime;
#import "Common.h"
#import "Prefs.h"


@interface PSTableCell : UITableViewCell
- (void)applyAlpha;
@end


@interface UITableView (April)
@property (nonatomic, strong) UIImageView *aprilImageView;
@property (nonatomic, strong) UIImageView *aprilScheduledImageView;
- (void)setImage;
- (void)setBlur;
- (void)setGradient;
- (void)setScheduledImages;
- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (void)setScheduledImageWithImage:(UIImage *)image imageKey:(NSString *)key;
- (UIImageView *)createAprilImageView;
- (UIViewController *)_viewControllerForAncestor;
@end
