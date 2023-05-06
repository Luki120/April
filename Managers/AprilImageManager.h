@import GcUniversal.ImagePickerUtils;
@import Photos;
#import "Headers/Common.h"


@interface AprilImageManager : NSObject
+ (AprilImageManager *)sharedInstance;
- (void)blurImage;
@end


@interface UIApplication ()
- (void)_openURL:(NSURL *)url;
@end
