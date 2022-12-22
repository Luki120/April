#import <GcUniversal/GcImagePickerUtils.h>
#import "Headers/Common.h"
@import Photos;


@interface AprilImageManager : NSObject {

	@public UIAlertController *firstAlertVC;
	@public UIAlertController *secondAlertVC;

}
+ (AprilImageManager *)sharedInstance;
- (void)blurImage;
@end


@interface UIApplication ()
- (void)_openURL:(NSURL *)url;
@end
