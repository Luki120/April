#import "APPAnimatedTitleView.h"


@implementation APPAnimatedTitleView {

	UILabel *titleLabel;
	CGFloat minimumOffsetRequired;
	NSLayoutConstraint *centerYAnchorConstraint;

}


- (id)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset {

	self = [super init];
	if(!self) return nil;

	titleLabel = [UILabel new];
	titleLabel.font = [UIFont systemFontOfSize:17 weight: UIFontWeightHeavy];
	titleLabel.text = title;
	titleLabel.textColor = UIColor.labelColor;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.clipsToBounds = YES;
	titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview: titleLabel];

	[self.widthAnchor constraintEqualToAnchor: titleLabel.widthAnchor].active = YES;
	[self.heightAnchor constraintEqualToAnchor: titleLabel.heightAnchor].active = YES;

	[titleLabel.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
	centerYAnchorConstraint = [titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant: 100];
	centerYAnchorConstraint.active = YES;

	minimumOffsetRequired = minimumOffset;

	return self;

}


- (void)adjustLabelPositionToScrollOffset:(CGFloat)offset {

	CGFloat adjustment = 100 - (offset - minimumOffsetRequired);

	if(offset > minimumOffsetRequired) {

		if(adjustment <= 0) centerYAnchorConstraint.constant = 0; 
		else centerYAnchorConstraint.constant = adjustment;

	} else centerYAnchorConstraint.constant = -100;

}

@end
