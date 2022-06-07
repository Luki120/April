@import Foundation;


@interface NSDistributedNotificationCenter : NSNotificationCenter
@end


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
