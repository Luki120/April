#import "Managers/AprilImageManager.h"
@import Preferences.PSTableCell;


@protocol AprilGaussianBlurCellDelegate <NSObject>

@required
- (void)aprilGaussianBlurCellDidTapGaussianBlurButton;
- (void)aprilGaussianBlurCellDidTapGaussianBlurInfoButton;

@end


@interface AprilGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AprilGaussianBlurCellDelegate> delegate;
@end
