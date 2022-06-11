#import "Headers/Constants.h"
#import <GcUniversal/GcImagePickerUtils.h>


@interface AprilImageManager : NSObject {

	@public UIAlertController *firstAlertVC;
	@public UIAlertController *secondAlertVC;

}
+ (AprilImageManager *)sharedInstance;
- (void)blurImageWithImage;
@end


@interface UIApplication ()
- (void)_openURL:(NSURL *)url;
@end
