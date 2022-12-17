#import <GcUniversal/GcColorPickerUtils.h>
#import <GcUniversal/GcImagePickerUtils.h>
#import "Headers/Common.h"
#import "Headers/Prefs.h"


// imagine having to subclass a UIView to properly handle
// a layer's frame without breaking on rotation smfh

@interface AprilGradientView : UIView
@property (nonatomic, strong, readonly) CAGradientLayer *layer;
@end


@implementation AprilGradientView

@dynamic layer;

+ (Class)layerClass { return [CAGradientLayer class]; }

@end


@interface PSTableCell : UITableViewCell
- (void)applyAlpha;
@end


@interface UITableView (April)
@property (nonatomic, strong) UIImageView *aprilImageView;
@property (nonatomic, strong) UIImageView *aprilScheduledImageView;
@property (nonatomic, strong) AprilGradientView *neatGradientView;
- (void)setImage;
- (void)setBlur;
- (void)setGradient;
- (void)setScheduledImages;
- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
- (void)setScheduledImageWithImage:(UIImage *)image imageKey:(NSString *)key;
- (UIImageView *)createAprilImageView;
- (UIViewController *)_viewControllerForAncestor;
@end


static UIImage *darkImage;
static UIImage *lightImage;
static NSTimer *imagesTimer;
static NSNotificationName const AprilApplyTimerNotification = @"AprilApplyTimerNotification";


%hook UITableView


%property (nonatomic, strong) UIImageView *aprilImageView;
%property (nonatomic, strong) UIImageView *aprilScheduledImageView;
%property (nonatomic, strong) AprilGradientView *neatGradientView;


%new

- (void)setImage {

	loadWithoutAFuckingRespring();

	darkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bImage"];
	lightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bLightImage"];

	UIViewController *ancestor = [self _viewControllerForAncestor];
	if([ancestor isKindOfClass: %c(LCTTMessagesVC)]) return;

	self.backgroundView = nil;

	if(!yes) { [self setScheduledImages]; return; }
	if(self.aprilImageView) [self.aprilImageView removeFromSuperview];

	self.aprilImageView = [self createAprilImageView];
	self.aprilImageView.image = kUserInterfaceStyle ? darkImage : lightImage;

	[self setBlur];

}


%new

- (void)setScheduledImages {

	UIImage *morningImage;
	UIImage *afternoonImage;
	UIImage *sunsetImage;
	UIImage *midnightImage;

	if(!scheduledImages) return;
	if(self.aprilScheduledImageView) [self.aprilScheduledImageView removeFromSuperview];

	self.aprilScheduledImageView = [self createAprilImageView];

	NSInteger hour = [NSCalendar.currentCalendar component:NSCalendarUnitHour fromDate:[NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitSecond value:10 toDate:NSDate.date options:0]];

	if(hour >= 22) [self setScheduledImageWithImage:midnightImage imageKey: @"midnightImage"]; // 10 pm
	else if(hour >= 18) [self setScheduledImageWithImage:sunsetImage imageKey: @"sunsetImage"]; // 6 pm
	else if(hour >= 12) [self setScheduledImageWithImage:afternoonImage imageKey: @"afternoonImage"]; // 12 pm
	else if(hour >= 8) [self setScheduledImageWithImage:morningImage imageKey: @"morningImage"]; // 8 am
	else [self setScheduledImageWithImage:midnightImage imageKey: @"midnightImage"]; // time before 8 am, so loop back to midnight wallpaper

	[self setBlur];

}


%new

- (void)setBlur {

	loadWithoutAFuckingRespring();

	[[self.backgroundView viewWithTag:1337] removeFromSuperview];

	if(!blur) return;

	if(blurType == 0) {

		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		blurView.tag = 1337;
		blurView.alpha = intensity;
		[self.backgroundView insertSubview:blurView atIndex:0];

	} else {

		UIBlurEffect *blurEffect;

		switch(blurType) {
			case 1: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; break;
			case 2: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; break;
			case 3: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]; break;
			case 4: blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial]; break;
		}

		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect: blurEffect];
		blurEffectView.tag = 1337;
		blurEffectView.alpha = intensity;
		blurEffectView.frame = self.backgroundView.bounds;
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.backgroundView addSubview: blurEffectView];

	}

}


%new

- (void)setGradient {

	loadWithoutAFuckingRespring();

	if(!setGradientAsBackground) return;

	UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.aprilprefs" withKey:@"gradientFirstColor" fallback:@"ffffff"];
	UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.aprilprefs" withKey:@"gradientSecondColor" fallback:@"ffffff"];
	NSArray *gradientColors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
	NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00], [NSNumber numberWithFloat:0.50], nil];

	self.neatGradientView = [[AprilGradientView alloc] initWithFrame: self.backgroundView.bounds];
	self.neatGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.neatGradientView.layer.colors = gradientColors;
	self.neatGradientView.layer.locations = gradientLocations;
	self.backgroundView = self.neatGradientView;

	switch(gradientDirection) {
		case 0: [self setGradientStartPoint:CGPointMake(0.5, 1) endPoint:CGPointMake(0.5, 0)]; break; // Bottom to top
		case 1: [self setGradientStartPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)]; break; // Top to bottom
		case 2: [self setGradientStartPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)]; break; // Left to right
		case 3: [self setGradientStartPoint:CGPointMake(1, 0.5) endPoint:CGPointMake(0, 0.5)]; break; // Right to left
		case 4: [self setGradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)]; break; // Upper left lower right
		case 5: [self setGradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 0)]; break; // Lower left upper right
		case 6: [self setGradientStartPoint:CGPointMake(1, 0) endPoint:CGPointMake(0, 1)]; break; // Upper right lower left
		case 7: [self setGradientStartPoint:CGPointMake(1, 1) endPoint:CGPointMake(0, 0)]; break; // Lower right upper left
	}

	if(!setGradientAnimation) return;

	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"colors"];
	animation.fromValue = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
	animation.toValue = [NSArray arrayWithObjects:(id)secondColor.CGColor, (id)firstColor.CGColor, nil];
	animation.duration = 4.5;
	animation.repeatCount = HUGE_VALF; // Loop the animation forever
	animation.autoreverses = YES;
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	[self.neatGradientView.layer addAnimation:animation forKey:@"gradientAnimation"];

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;
	self.aprilImageView.image = kUserInterfaceStyle ? darkImage : lightImage;

}


- (void)didMoveToSuperview { // Add notification observers

	%orig;

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setImage) name:AprilApplyImageNotification object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setGradient) name:AprilApplyGradientNotification object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setScheduledImages) name:AprilApplyTimerNotification object:nil];

}


- (void)didMoveToWindow {

	%orig;

	[self setImage];
	[self setGradient];
	[self setScheduledImages];

}


// Reusable funcs

%new

- (UIImageView *)createAprilImageView {

	UIImageView *imageView = [UIImageView new];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.backgroundView = imageView;
	return imageView;

}


%new

- (void)setScheduledImageWithImage:(UIImage *)image imageKey:(NSString *)key {

	image = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey: key];
	self.aprilScheduledImageView.image = image;

}


%new

- (void)setGradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {

	self.neatGradientView.layer.startPoint = startPoint;
	self.neatGradientView.layer.endPoint = endPoint;

}


%end


%hook PSTableCell


%new

- (void)applyAlpha { // https://github.com/PopsicleTreehouse/SettingsWallpaper

	loadWithoutAFuckingRespring();

	CGFloat red = 0.0, green = 0.0, blue = 0.0, dAlpha = 0.0;
	[self.backgroundColor getRed:&red green:&green blue:&blue alpha:&dAlpha];
	self.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:cellAlpha];

}


- (void)didMoveToWindow {

	%orig;
	[self applyAlpha];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applyAlpha) name:AprilApplyAlphaNotification object:nil];

}


- (void)refreshCellContentsWithSpecifier:(id)specifier {

	%orig;
	[self applyAlpha];

}


// since we extracted the color components, they get "unlinked" to the preset system colors
// so we need to manually update them again so they switch dynamically following the user interface style

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {

	%orig;

	UIColor *darkModeColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.12 alpha: cellAlpha];
	UIColor *lightModeColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha: cellAlpha];

	self.backgroundColor = kUserInterfaceStyle ? darkModeColor : lightModeColor;

}


- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2 { %orig(NO, NO); }
- (void)setHighlighted:(BOOL)arg1 animated:(BOOL)arg2 { %orig(NO, NO); }


%end


static void scheduleTimer() {

	NSInteger hour = [NSCalendar.currentCalendar component:NSCalendarUnitHour fromDate:NSDate.date];
	NSInteger targetHour = 8;

	if(hour < 8) targetHour = 8;

	else if(hour < 12) targetHour = 12;
	else if(hour < 18) targetHour = 18;
	else if(hour < 22) targetHour = 22;

	NSInteger seconds = [NSCalendar.currentCalendar dateBySettingUnit:NSCalendarUnitHour value:targetHour ofDate:[NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:NSDate.date]] options:0].timeIntervalSinceNow;

	if(seconds < 0) seconds = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSCalendar.currentCalendar dateBySettingUnit:NSCalendarUnitHour value:targetHour ofDate:[NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:NSDate.date]] options:0] options:0].timeIntervalSinceNow;

	imagesTimer = [NSTimer timerWithTimeInterval:seconds repeats:NO block:^(NSTimer *time) {

		[NSNotificationCenter.defaultCenter postNotificationName:AprilApplyTimerNotification object:nil];
		scheduleTimer();

	}];

	[NSRunLoop.currentRunLoop addTimer:imagesTimer forMode: NSDefaultRunLoopMode];

}


%ctor {

	loadWithoutAFuckingRespring();
	scheduleTimer();

}
