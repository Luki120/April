#import <UIKit/UIKit.h>
#import <GcColorPickerUtils.h>
#import <GcImagePickerUtils.h>




@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
- (void)postNotificationName:(NSString *)name object:(NSString *)object userInfo:(NSDictionary *)userInfo;
@end


@interface UITableView ()
- (void)setImage;
- (void)setBlur;
- (void)setGradient;
@end


@interface PSTableCell : UIView
- (void)applyAlpha;
@end


@interface _UIBackdropView : UIView
@property (assign,nonatomic) BOOL blurRadiusSetOnce;
@property (nonatomic,copy) NSString * _blurQuality;
@property (assign,nonatomic) double _blurRadius;
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3 ;
-(id)initWithSettings:(id)arg1 ;
@end


@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(long long)arg1 ;
@end



static NSString *plistPath = @"/var/mobile/Library/Preferences/me.luki.aprilprefs.plist";
static BOOL yes;
static BOOL blur;
static BOOL setGradientAsBackground;
static BOOL alpha;
static int blurType;
static int gradientDirection;
float cellAlpha = 1.0f;
float intensity = 1.0f;




CAGradientLayer *gradient;
UIView *view;



UIImage *image;




static void loadWithoutAFuckingRespring() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];
	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;
	blur = prefs[@"blur"] ? [prefs[@"blur"] boolValue] : NO;
	setGradientAsBackground = prefs[@"setGradientAsBackground"] ? [prefs[@"setGradientAsBackground"] boolValue] : NO;
	alpha = prefs[@"alphaEnabled"] ? [prefs[@"alphaEnabled"] boolValue] : YES;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 2;
	gradientDirection = prefs[@"gradientDirection"] ? [prefs[@"gradientDirection"] integerValue] : 0;
	cellAlpha = prefs[@"cellAlpha"] ? [prefs[@"cellAlpha"] floatValue] : 1.0f;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 1.0f;

}




%hook UITableView


%new


-(void)setImage {


	loadWithoutAFuckingRespring();

	if(yes) {

		image = [GcImagePickerUtils imageFromDefaults:@"me.luki.aprilprefs" withKey:@"bImage"];
		UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
		[backgroundImageView setFrame:self.frame];
		self.backgroundView = backgroundImageView;

		//[backgroundImageView setClipsToBounds:YES];
		//[backgroundImageView setContentMode: UIViewContentModeScaleAspectFill];

	}
	
	else {
		
		if(setGradientAsBackground) [self setGradient];
		else self.backgroundView = NULL;

	}

}


%new


-(void)setBlur {


	loadWithoutAFuckingRespring();
	
	[[self.backgroundView viewWithTag:1337] removeFromSuperview];
	
	if(blur && blurType == 2) {

		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2]; //4005

		_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithFrame:CGRectZero
		autosizesToFitSuperview:YES settings:settings];
		blurView.blurRadiusSetOnce = NO;
		blurView._blurRadius = 80.0;
		blurView._blurQuality = @"high";
		blurView.tag = 1337;
		blurView.alpha = intensity;
		[self.backgroundView insertSubview:blurView atIndex:1];


	}


	else if(blur && blurType == 1) {

		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		blurEffectView.tag = 1337;
		//always fill the view
		blurEffectView.alpha = intensity;
		blurEffectView.frame = self.backgroundView.bounds;
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.backgroundView addSubview:blurEffectView];


	}


	else if(blur && blurType == 0) {

		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		blurEffectView.tag = 1337;
		//always fill the view
		blurEffectView.alpha = intensity;
		blurEffectView.frame = self.backgroundView.bounds;
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.backgroundView addSubview:blurEffectView];

	}


}


%new 


-(void)setGradient {


	loadWithoutAFuckingRespring();


	if(setGradientAsBackground) {

		view = [[UIView alloc] initWithFrame:self.backgroundView.bounds];
		[view setClipsToBounds:YES];
		gradient = [CAGradientLayer layer];
		//gradient.type = kCAGradientLayerConic;
		gradient.frame = view.frame;
		gradient.startPoint = CGPointMake(0,0); // Lower right to upper left
		gradient.endPoint = CGPointMake(1,1);
		gradient.colors = [NSArray arrayWithObjects:(id)[[GcColorPickerUtils colorFromDefaults:@"me.luki.aprilprefs" withKey:@"gradientFirstColor" fallback:@"ffffff"] CGColor],(id)[[GcColorPickerUtils colorFromDefaults:@"me.luki.aprilprefs" withKey:@"gradientSecondColor" fallback:@"ffffff"]  CGColor], nil]; // (id)firstColor.CGColor, (id)secondColor.CGColor, nil];
		[view.layer addSublayer:gradient];
		self.backgroundView = view;
		
	}
	
	else {
		if(yes) [self setImage];
		else self.backgroundView = NULL;
	}


	switch(gradientDirection) {

	//	loadWithoutAFuckingRespring();


		case 0: // Bottom to Top	
			gradient.startPoint = CGPointMake(0.5,1);
			gradient.endPoint = CGPointMake(0.5,0);
			break;


		case 1: // Top to Bottom
			gradient.startPoint = CGPointMake(0.5,0);
			gradient.endPoint = CGPointMake(0.5,1);
			break;


		case 2: // Left to Right
			gradient.startPoint = CGPointMake(0,0.5);
			gradient.endPoint = CGPointMake(1,0.5);
			break;


		case 3: // Right to Left	
			gradient.startPoint = CGPointMake(1,0.5);
			gradient.endPoint = CGPointMake(0,0.5);
			break;


		case 4: // Upper Left lower right
			gradient.startPoint = CGPointMake(0,0);
			gradient.endPoint = CGPointMake(1,1);
			break;


		case 5: // Lower left upper right
			gradient.startPoint = CGPointMake(0,1);
			gradient.endPoint = CGPointMake(1,0);
			break;


		case 6: // Upper right lower left
			gradient.startPoint = CGPointMake(1,0);
			gradient.endPoint = CGPointMake(0,1);
			break;


		case 7: // Lower right upper left
			gradient.startPoint = CGPointMake(1,1);
			gradient.endPoint = CGPointMake(0,0);
			break;

	}

}


-(void)didMoveToSuperview {


	%orig;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImage) name:@"changeImage" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBlur) name:@"changeBlur" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGradient) name:@"changeGradient" object:nil];

}


-(void)didMoveToWindow {


	%orig;
	
	[self setImage];

	[self setGradient];

	[self setBlur];

}


%end




%hook PSTableCell


%new


-(void)applyAlpha { // https://github.com/PopsicleTreehouse/SettingsWallpaper

	loadWithoutAFuckingRespring();

	CGFloat red = 0.0, green = 0.0, blue = 0.0, dAlpha = 0.0;
	[self.backgroundColor getRed:&red green:&green blue:&blue alpha:&dAlpha];
	self.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:alpha ? cellAlpha : 1];

}


-(void)didMoveToWindow {

	loadWithoutAFuckingRespring();

	%orig;
	[self applyAlpha];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyAlpha) name:@"changeAlpha" object:nil];

}


-(void)refreshCellContentsWithSpecifier:(id)arg1 {

	loadWithoutAFuckingRespring();

	%orig;
	[self applyAlpha];

}


%end




%ctor {

    loadWithoutAFuckingRespring();

}
