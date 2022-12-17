#import "AprilImageManager.h"

#define saveImageToGallery UIImageWriteToSavedPhotosAlbum

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


- (void)blurImage {

	__block id observer;

	UIImage *darkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey: @"bImage"];
	UIImage *lightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey: @"bLightImage"];

	UIImage *candidateImage = kUserInterfaceStyle ? darkImage : lightImage;

	CIContext *context = [CIContext new];
	CIImage *inputImage = [[CIImage alloc] initWithImage: candidateImage];

	CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
	[clampFilter setDefaults];
	[clampFilter setValue:inputImage forKey: kCIInputImageKey];

	CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[blurFilter setValue:clampFilter.outputImage forKey: kCIInputImageKey];

	firstAlertVC = [UIAlertController alertControllerWithTitle:@"April" message:@"How much blur intensity do you want?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Blur" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[blurFilter setValue:@(firstAlertVC.textFields.firstObject.text.doubleValue) forKey:@"inputRadius"];

		CIImage *outputImage = [blurFilter valueForKey: kCIOutputImageKey];
		CGImageRef cgImage = [context createCGImage:outputImage fromRect: inputImage.extent];
		UIImage *blurredImage = [[UIImage alloc] initWithCGImage:cgImage scale:candidateImage.scale orientation: UIImageOrientationUp];

		saveImageToGallery(blurredImage, nil, nil, nil);
		CGImageRelease(cgImage);

		[self presentSuccessAlertController];
		[NSNotificationCenter.defaultCenter removeObserver: observer];

	}];
	confirmAction.enabled = NO;

	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[NSNotificationCenter.defaultCenter removeObserver: observer];
	}];

	[firstAlertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"Between 0 and 100";
		textField.keyboardType = UIKeyboardTypeNumberPad;

		observer = [NSNotificationCenter.defaultCenter addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			confirmAction.enabled = textField.text.integerValue != 0 && textField.text.integerValue <= 100;
		}];
	}];

	[firstAlertVC addAction: confirmAction];
	[firstAlertVC addAction: dismissAction];

}


- (void)presentSuccessAlertController {

	secondAlertVC = [UIAlertController alertControllerWithTitle:@"April" message:@"Your fancy image got succesfully saved to your gallery, do you want to see how it looks?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Heck yeah" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[UIApplication.sharedApplication _openURL: [NSURL URLWithString: @"photos-redirect://"]];

	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];

	[secondAlertVC addAction: confirmAction];
	[secondAlertVC addAction: cancelAction];

	[NSNotificationCenter.defaultCenter postNotificationName:AprilPresentVCNotification object:nil];

}

@end
