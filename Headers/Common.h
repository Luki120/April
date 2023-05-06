#import <rootless.h>

#define rootlessPathC(cPath) ROOT_PATH(cPath)
#define rootlessPathNS(path) ROOT_PATH_NS(path)

static NSString *const kPath = rootlessPathNS(@"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist");

static NSNotificationName const AprilApplyImageNotification = @"AprilApplyImageNotification";
static NSNotificationName const AprilApplyGradientNotification = @"AprilApplyGradientNotification";
static NSNotificationName const AprilApplyAlphaNotification = @"AprilApplyAlphaNotification";

#define kAprilTintColor [UIColor colorWithRed:1.0 green:0.55 blue:0.73 alpha: 1.0]
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark

@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end
