#import "AprilGaussianBlurCell.h"


@implementation AprilGaussianBlurCell {

	UIButton *gaussianBlurButton;
	UIButton *gaussianBlurInfoButton;

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
	if(self) [self setupUI];
	return self;

}


- (void)setupUI {

	if(!gaussianBlurButton) {
		gaussianBlurButton = [UIButton new];
		gaussianBlurButton.titleLabel.font = [UIFont systemFontOfSize: 17];
		gaussianBlurButton.translatesAutoresizingMaskIntoConstraints = NO;
		[gaussianBlurButton setTitle: @"Gaussian Blur" forState: UIControlStateNormal];
		[gaussianBlurButton setTitleColor:kAprilTintColor forState: UIControlStateNormal];
		[gaussianBlurButton addTarget:self action:@selector(didTapBlurButton) forControlEvents: UIControlEventTouchUpInside];
		[self.contentView addSubview: gaussianBlurButton];
	}

	UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize: 20];
	UIImage *buttonImage = [UIImage systemImageNamed:@"info.circle" withConfiguration: configuration];

	if(!gaussianBlurInfoButton) {
		gaussianBlurInfoButton = [UIButton new];
		gaussianBlurInfoButton.tintColor = kAprilTintColor;
		gaussianBlurInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
		[gaussianBlurInfoButton setImage:buttonImage forState: UIControlStateNormal];
		[gaussianBlurInfoButton addTarget:self action:@selector(didTapInfoButton) forControlEvents: UIControlEventTouchUpInside];
		[self.contentView addSubview: gaussianBlurInfoButton];
	}

	[self layoutUI];

}


- (void)layoutUI {

	[gaussianBlurButton.centerYAnchor constraintEqualToAnchor: self.contentView.centerYAnchor].active = YES;
	[gaussianBlurButton.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor constant: 15].active = YES;

	[gaussianBlurInfoButton.centerYAnchor constraintEqualToAnchor: self.contentView.centerYAnchor].active = YES;
	[gaussianBlurInfoButton.trailingAnchor constraintEqualToAnchor: self.contentView.trailingAnchor constant: -20].active = YES;

}


- (void)didTapBlurButton { [self.delegate didTapGaussianBlurButtonInAprilGaussianBlurCell: self]; }
- (void)didTapInfoButton { [self.delegate didTapGaussianBlurInfoButtonInAprilGaussianBlurCell: self]; }

@end
