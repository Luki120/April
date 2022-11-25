#import <GcUniversal/GcImagePickerUtils.h>
#import "Headers/Common.h"


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
