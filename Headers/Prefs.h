static BOOL yes;
static BOOL blur;

static NSInteger blurType;

static float intensity;
static float cellAlpha;

static BOOL setGradientAsBackground;
static BOOL setGradientAnimation;

static NSInteger gradientDirection;

static BOOL scheduledImages;

static void loadWithoutAFuckingRespring() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	yes = prefs[@"yes"] ? [prefs[@"yes"] boolValue] : NO;

	blur = prefs[@"blur"] ? [prefs[@"blur"] boolValue] : NO;
	blurType = prefs[@"blurType"] ? [prefs[@"blurType"] integerValue] : 0;
	intensity = prefs[@"intensity"] ? [prefs[@"intensity"] floatValue] : 0.85f;

	cellAlpha = prefs[@"cellAlpha"] ? [prefs[@"cellAlpha"] floatValue] : 1.0f;

	setGradientAsBackground = prefs[@"setGradientAsBackground"] ? [prefs[@"setGradientAsBackground"] boolValue] : NO;
	setGradientAnimation = prefs[@"setGradientAnimation"] ? [prefs[@"setGradientAnimation"] boolValue] : NO;
	gradientDirection = prefs[@"gradientDirection"] ? [prefs[@"gradientDirection"] integerValue] : 0;

	scheduledImages = prefs[@"scheduledImages"] ? [prefs[@"scheduledImages"] boolValue] : NO;

}
