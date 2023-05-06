@import Preferences.PSTableCell;
#import "Headers/Common.h"


@class AprilGaussianBlurCell;

@protocol AprilGaussianBlurCellDelegate <NSObject>

@required
- (void)didTapGaussianBlurButtonInAprilGaussianBlurCell:(AprilGaussianBlurCell *)aprilGaussianBlurCell;
- (void)didTapGaussianBlurInfoButtonInAprilGaussianBlurCell:(AprilGaussianBlurCell *)aprilGaussianBlurCell;

@end


@interface AprilGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AprilGaussianBlurCellDelegate> delegate;
@end
