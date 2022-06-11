#import "AprilImageManager.h"


@implementation AprilImageManager

+ (AprilImageManager *)sharedInstance {

	static AprilImageManager *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [AprilImageManager new]; });

	return sharedInstance;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	return self;

}


- (void)blurImageWithImage {

	UIImage *darkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey: @"bImage"];
	UIImage *lightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey: @"bLightImage"];

	UIImage *candidateImage = kUserInterfaceStyle ? darkImage : lightImage;

	CIContext *context = [CIContext contextWithOptions: nil];
	CIImage *inputImage = [[CIImage alloc] initWithImage: candidateImage];

	CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
	[clampFilter setDefaults];
	[clampFilter setValue:inputImage forKey: kCIInputImageKey];

	CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[blurFilter setValue:clampFilter.outputImage forKey: kCIInputImageKey];

	firstAlertVC = [UIAlertController alertControllerWithTitle:@"April" message:@"How much blur intensity do you want?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Blur" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[blurFilter setValue:[NSNumber numberWithFloat:firstAlertVC.textFields.firstObject.text.doubleValue] forKey:@"inputRadius"];

		CIImage *result = [blurFilter valueForKey: kCIOutputImageKey];
		CGImageRef cgImage = [context createCGImage:result fromRect: inputImage.extent];
		UIImage *blurredImage = [[UIImage alloc] initWithCGImage:cgImage scale:candidateImage.scale orientation: UIImageOrientationUp];

		[self saveImageToGallery: blurredImage];
		CGImageRelease(cgImage);

		[self proudSuccessAlertController];

	}];

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[firstAlertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"Between 0 and 100";
		textField.keyboardType = UIKeyboardTypeNumberPad;
	}];

	[firstAlertVC addAction: confirmAction];
	[firstAlertVC addAction: dismissAction];

}


- (void)saveImageToGallery:(UIImage *)image { kSaveToGallery(image, nil, nil, nil); }


- (void)proudSuccessAlertController {

	secondAlertVC = [UIAlertController alertControllerWithTitle:@"April" message:@"Your fancy image got succesfully saved to your gallery, do you want to see how it looks?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Heck yeah" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[UIApplication.sharedApplication _openURL: [NSURL URLWithString: @"photos-redirect://"]];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[secondAlertVC addAction: confirmAction];
	[secondAlertVC addAction: cancelAction];

	[NSNotificationCenter.defaultCenter postNotificationName:@"presentVC" object:nil];

}

@end
