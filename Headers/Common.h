static NSString *const kPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";

#define kAprilTintColor [UIColor colorWithRed:1.0 green:0.55 blue:0.73 alpha: 1.0]
#define kUserInterfaceStyle UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark

@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (assign, nonatomic) double _blurRadius;
@property (copy, nonatomic) NSString *_blurQuality;
- (id)initWithSettings:(id)arg1;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end
