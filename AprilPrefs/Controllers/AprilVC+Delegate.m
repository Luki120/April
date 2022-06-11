#import "AprilVC+Delegate.h"


@implementation AprilVC (Delegate)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	AprilGaussianBlurCell *cell = (AprilGaussianBlurCell *)[super tableView:tableView cellForRowAtIndexPath: indexPath];
	if([cell isKindOfClass: AprilGaussianBlurCell.class]) cell.delegate = self;
	return cell;

}


- (void)aprilGaussianBlurCellDidTapGaussianBlurButton {

	[[AprilImageManager sharedInstance] blurImageWithImage];
	[self presentViewController:[AprilImageManager sharedInstance]->firstAlertVC animated:YES completion:nil];

}


- (void)aprilGaussianBlurCellDidTapGaussianBlurInfoButton {

	AudioServicesPlaySystemSound(1521);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"April" message:@"The gaussian blur is an actual blur applied to the image, rather than an overlay view, like the epic one. This means you can save any image you want with the blur applied, and with any intensity you want. Since generating the blur takes quite some resources, including it directly as an option wouldn't be the best performance wise without sacrificing on the fly preferences. However, you can save any image you want and then come back here and apply it. The image that'll be saved is the one you currently have selected depending on dark/light mode." preferredStyle: UIAlertControllerStyleAlert];
	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler: nil];
	[alertController addAction: dismissAction];
	[self presentViewController:alertController animated:YES completion: nil];

}


- (void)presentVC {

	[self presentViewController:[AprilImageManager sharedInstance]->secondAlertVC animated:YES completion:nil];

}

@end
