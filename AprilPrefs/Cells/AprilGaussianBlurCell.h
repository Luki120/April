@import Preferences.PSTableCell;
#import "Headers/Common.h"


@protocol AprilGaussianBlurCellDelegate <NSObject>

@required
- (void)aprilGaussianBlurCellDidTapGaussianBlurButton;
- (void)aprilGaussianBlurCellDidTapGaussianBlurInfoButton;

@end


@interface AprilGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AprilGaussianBlurCellDelegate> delegate;
@end
