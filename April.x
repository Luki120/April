@import UIKit;
#import <GcUniversal/GcColorPickerUtils.h>
#import <GcUniversal/GcImagePickerUtils.h>


// imagine having to subclass a UIView to properly handle
// a layer's frame without breaking on rotation smfh


@interface AprilGradientView : UIView
@property (nonatomic, strong, readonly) CAGradientLayer *layer;
@end


@implementation AprilGradientView

@dynamic layer;

+ (Class)layerClass {

	return [CAGradientLayer class];

}

@end


@interface PSTableCell : UITableViewCell
- (void)applyAlpha;
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(long long)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (assign, nonatomic) double _blurRadius;
@property (copy, nonatomic) NSString *_blurQuality;
- (id)initWithSettings:(id)arg1;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end


@interface UITableView (April)
@property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
@property (nonatomic, strong) UIImageView *hotGoodLookingScheduledImageView;
@property (nonatomic, strong) AprilGradientView *neatGradientView;
@property (readonly) NSTimeInterval timeIntervalSinceNow;
- (void)setImage;
- (void)setBlur;
- (void)setGradient;
- (void)setScheduledImages;
- (id)_viewControllerForAncestor;
@end


@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


static NSString *const plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";

#define kUserInterfaceStyle (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)

static BOOL yes;
static BOOL blur;

static int blurType;

static float intensity = 1.0f;

static BOOL alpha;

static float cellAlpha = 1.0f;

static BOOL setGradientAsBackground;
static BOOL setGradientAnimation;

static int gradientDirection;

static BOOL scheduledImages;

UIBlurEffect *blurEffect;

UIImage *hotGoodLookingDarkImage;
UIImage *hotGoodLookingLightImage;

NSTimer *imagesTimer;

UITableView *tableView = nil;

static void loadWithoutAFuckingRespring() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;

	blur = prefs[@"blur"] ? [prefs[@"blur"] boolValue] : NO;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;

	alpha = prefs[@"alphaEnabled"] ? [prefs[@"alphaEnabled"] boolValue] : YES;
	cellAlpha = prefs[@"cellAlpha"] ? [prefs[@"cellAlpha"] floatValue] : 1.0f;

	setGradientAsBackground = prefs[@"setGradientAsBackground"] ? [prefs[@"setGradientAsBackground"] boolValue] : NO;
	setGradientAnimation = prefs[@"setGradientAnimation"] ? [prefs[@"setGradientAnimation"] boolValue] : NO;
	gradientDirection = prefs[@"gradientDirection"] ? [prefs[@"gradientDirection"] integerValue] : 0;

	scheduledImages = prefs[@"scheduledImages"] ? [prefs[@"scheduledImages"] boolValue] : NO;

}


%hook UITableView


%property (nonatomic, strong) UIImageView *hotGoodLookingImageView;
%property (nonatomic, strong) UIImageView *hotGoodLookingScheduledImageView;
%property (nonatomic, strong) AprilGradientView *neatGradientView;


%new

- (void)setImage {

	loadWithoutAFuckingRespring();

	hotGoodLookingDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bImage"];
	hotGoodLookingLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bLightImage"];

	UIViewController *ancestor = [self _viewControllerForAncestor];

	if(![ancestor isKindOfClass:%c(LCTTMessagesController)]) {

		if(yes) {

			self.hotGoodLookingImageView = [UIImageView new];
			self.hotGoodLookingImageView.frame = self.backgroundView.bounds;
			self.hotGoodLookingImageView.image = kUserInterfaceStyle ? hotGoodLookingDarkImage : hotGoodLookingLightImage;
			self.hotGoodLookingImageView.contentMode = UIViewContentModeScaleAspectFill;
			self.hotGoodLookingImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			self.backgroundView = self.hotGoodLookingImageView;

		}

		else {

			if(setGradientAsBackground) [self setGradient];
			else self.backgroundView = NULL;

		}

	}

}


%new

- (void)setScheduledImages {

	loadWithoutAFuckingRespring();

	UIImage *imageMorning;
	UIImage *imageAfternoon;
	UIImage *imageSunset;
	UIImage *imageMidnight;

	UIViewController *ancestor = [self _viewControllerForAncestor];

	if(![ancestor isKindOfClass:%c(LCTTMessagesController)]) {

		if(scheduledImages) {

			if(self.hotGoodLookingScheduledImageView) [self.hotGoodLookingScheduledImageView removeFromSuperview];

			self.hotGoodLookingScheduledImageView = [UIImageView new];
			self.hotGoodLookingScheduledImageView.frame = self.backgroundView.bounds;
			self.hotGoodLookingScheduledImageView.contentMode = UIViewContentModeScaleAspectFill;
			self.hotGoodLookingScheduledImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

			self.backgroundView = self.hotGoodLookingScheduledImageView;

			int hours = [NSCalendar.currentCalendar component:NSCalendarUnitHour fromDate:[NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitSecond value:10 toDate:NSDate.date options:0]];

			if(hours >= 22) { // 10 pm

				imageMidnight = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"imageMidnight"];
				self.hotGoodLookingScheduledImageView.image = imageMidnight;


			} else if(hours >= 18) { // 6 pm

				imageSunset = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"imageSunset"];
				self.hotGoodLookingScheduledImageView.image = imageSunset;


			} else if(hours >= 12) { // 12 pm

				imageAfternoon = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"imageAfternoon"];
				self.hotGoodLookingScheduledImageView.image = imageAfternoon;


			} else if(hours >= 8) { // 8 am

				imageMorning = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"imageMorning"];
				self.hotGoodLookingScheduledImageView.image = imageMorning;


			} else { // time before 8 am, so loop back to midnight wallpaper

				imageMidnight = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"imageMidnight"];
				self.hotGoodLookingScheduledImageView.image = imageMidnight;

			}

		}

	}

}


%new

- (void)setBlur {

	loadWithoutAFuckingRespring();

	[[self.backgroundView viewWithTag:1337] removeFromSuperview];

	if(blur) {

		if(blurType == 0) {

			_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

			_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
			blurView.tag = 1337;
			blurView.alpha = intensity;
			blurView._blurRadius = 80.0;
			blurView._blurQuality = @"high";
			blurView.blurRadiusSetOnce = NO;
			[self.backgroundView insertSubview:blurView atIndex:0];

		} else {

			switch(blurType) {

				case 1:

					blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
					break;


				case 2:

					blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
					break;


				case 3:

					blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
					break;


				case 4:

					blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
					break;

			}

			UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
			blurEffectView.tag = 1337;
			blurEffectView.alpha = intensity;
			blurEffectView.frame = self.backgroundView.bounds;
			blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self.backgroundView addSubview:blurEffectView];

		}

	}

}


%new

- (void)setGradient {

	loadWithoutAFuckingRespring();

	if(setGradientAsBackground) {

		UIColor *firstColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.aprilprefs" withKey:@"gradientFirstColor" fallback:@"ffffff"];
		UIColor *secondColor = [GcColorPickerUtils colorFromDefaults:@"me.luki.aprilprefs" withKey:@"gradientSecondColor" fallback:@"ffffff"];

		self.neatGradientView = [[AprilGradientView alloc] initWithFrame:self.backgroundView.bounds];
		self.neatGradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.neatGradientView.layer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
		self.neatGradientView.layer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.00], [NSNumber numberWithFloat:0.50] , nil];
		self.backgroundView = self.neatGradientView;

		if(setGradientAnimation) {

			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
			animation.fillMode = kCAFillModeBoth;
			animation.fromValue = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
			animation.toValue = [NSArray arrayWithObjects:(id)secondColor.CGColor, (id)firstColor.CGColor, nil];
			animation.duration = 4.5;
			animation.repeatCount = HUGE_VALF; // Loop the animation forever
			animation.autoreverses = YES;
			animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			animation.removedOnCompletion = NO;
			[self.neatGradientView.layer addAnimation:animation forKey:@"animateGradient"];

		}

	}

	else {

		if(yes) [self setImage];
		else self.backgroundView = NULL;

	}

	switch(gradientDirection) {

		case 0: // Bottom to Top

			self.neatGradientView.layer.startPoint = CGPointMake(0.5,1);
			self.neatGradientView.layer.endPoint = CGPointMake(0.5,0);
			break;


		case 1: // Top to Bottom

			self.neatGradientView.layer.startPoint = CGPointMake(0.5,0);
			self.neatGradientView.layer.endPoint = CGPointMake(0.5,1);
			break;


		case 2: // Left to Right

			self.neatGradientView.layer.startPoint = CGPointMake(0,0.5);
			self.neatGradientView.layer.endPoint = CGPointMake(1,0.5);
			break;


		case 3: // Right to Left

			self.neatGradientView.layer.startPoint = CGPointMake(1,0.5);
			self.neatGradientView.layer.endPoint = CGPointMake(0,0.5);
			break;


		case 4: // Upper Left lower right

			self.neatGradientView.layer.startPoint = CGPointMake(0,0);
			self.neatGradientView.layer.endPoint = CGPointMake(1,1);
			break;


		case 5: // Lower left upper right

			self.neatGradientView.layer.startPoint = CGPointMake(0,1);
			self.neatGradientView.layer.endPoint = CGPointMake(1,0);
			break;


		case 6: // Upper right lower left

			self.neatGradientView.layer.startPoint = CGPointMake(1,0);
			self.neatGradientView.layer.endPoint = CGPointMake(0,1);
			break;


		case 7: // Lower right upper left

			self.neatGradientView.layer.startPoint = CGPointMake(1,1);
			self.neatGradientView.layer.endPoint = CGPointMake(0,0);
			break;

	}

}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // handle transition between light/dark mode dynamically

	%orig;

	hotGoodLookingDarkImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bImage"];
	hotGoodLookingLightImage = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bLightImage"];

	self.hotGoodLookingImageView.image = kUserInterfaceStyle ? hotGoodLookingDarkImage : hotGoodLookingLightImage;

}


- (void)didMoveToSuperview { // Add notification observers

	%orig;

	tableView = self; // get an instance of UITableView

	[self setImage];
	[self setGradient];

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setImage) name:@"applyImage" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setGradient) name:@"applyGradient" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setScheduledImages) name:@"applyScheduledImage" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setScheduledImages) name:@"applyTimer" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setBlur) name:@"applyBlur" object:nil];

}


- (void)didMoveToWindow {

	%orig;

	[self setScheduledImages];

	[self setBlur];

}


%end


%hook PSTableCell


%new

- (void)applyAlpha { // https://github.com/PopsicleTreehouse/SettingsWallpaper

	loadWithoutAFuckingRespring();

	CGFloat red = 0.0, green = 0.0, blue = 0.0, dAlpha = 0.0;
	[self.backgroundColor getRed:&red green:&green blue:&blue alpha:&dAlpha];
	self.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha ? cellAlpha : 1];


}


- (void)didMoveToWindow {

	%orig;

	[self applyAlpha];

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applyAlpha) name:@"applyAlpha" object:nil];

}


- (void)refreshCellContentsWithSpecifier:(id)arg1 {

	%orig;

	[self applyAlpha];

}


// since we extracted the color components, they get "unlinked" to the preset system colors
// so we need to manually update them again so they switch dynamically following the user interface style


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {

	%orig;

	UIColor *darkModeColor = [UIColor colorWithRed: 0.11 green: 0.11 blue: 0.12 alpha:alpha ? cellAlpha : 1];
	UIColor *lightModeColor = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha:alpha ? cellAlpha : 1];

	self.backgroundColor = kUserInterfaceStyle ? darkModeColor : lightModeColor;

}


- (void)setSelected:(BOOL)arg1 animated:(BOOL)arg2 {

	%orig(NO, NO);

}


- (void)setHighlighted:(BOOL)arg1 animated:(BOOL)arg2 {

	%orig(NO, NO);

}


%end


void scheduleTimer() {

	int hour = [NSCalendar.currentCalendar component:NSCalendarUnitHour fromDate:NSDate.date];
	int targetHour = 8;
	
	if(hour < 8) targetHour = 8;
	
	else if(hour < 12) targetHour = 12;
	else if(hour < 18) targetHour = 18;
	else if(hour < 22) targetHour = 22;
	
	int seconds = [NSCalendar.currentCalendar dateBySettingUnit:NSCalendarUnitHour value:targetHour ofDate:[NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:NSDate.date]] options:0].timeIntervalSinceNow;
	
	if(seconds < 0) seconds = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSCalendar.currentCalendar dateBySettingUnit:NSCalendarUnitHour value:targetHour ofDate:[NSCalendar.currentCalendar dateFromComponents:[NSCalendar.currentCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:NSDate.date]] options:0] options:0].timeIntervalSinceNow;
	

	imagesTimer = [NSTimer timerWithTimeInterval:seconds repeats:NO block:^(NSTimer *time) {

						[NSNotificationCenter.defaultCenter postNotificationName:@"timerApplied" object:nil];

						[tableView setBlur];	

						scheduleTimer();

					}];
	
	[NSRunLoop.currentRunLoop addTimer:imagesTimer forMode : NSDefaultRunLoopMode];

}


%ctor {

	loadWithoutAFuckingRespring();
	
	scheduleTimer();

}
