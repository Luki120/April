#import "Headers/Constants.h"
#import "Managers/AprilImageManager.h"
#import <Preferences/PSTableCell.h>


@protocol AprilGaussianBlurCellDelegate <NSObject>

@required
- (void)aprilGaussianBlurCellDidTapGaussianBlurButton;
- (void)aprilGaussianBlurCellDidTapGaussianBlurInfoButton;

@end


@interface AprilGaussianBlurCell : PSTableCell
@property (nonatomic, weak) id <AprilGaussianBlurCellDelegate> delegate;
@end
