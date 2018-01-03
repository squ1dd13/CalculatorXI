//Even though Calculator.app is written in Swift, for the keys we don't need to hook any Swift classes because the keys are UILabels
UIView *backgroundView;
UIView *smallBackgroundView;

//BOOL isNotLandscape = !(([[UIDevice currentDevice]orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice]orientation] == UIDeviceOrientationLandscapeRight));
//The % sign key is stored in NSArray *buttons at index 2

%hook UILabel

-(void)layoutSubviews {
	CGRect selfFrame = self.frame;
	/* Don't modify the display text. We can't detect the x or y because of different device screen sizes, and we can't
	detect the width because that is dynamic */
	if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
		//Add the iOS 11 style circles, but give the non-numerical buttons their custom colours
		if (!([self.text isEqualToString:@"AC"] || ([self.text isEqualToString:@"C"]) || ((selfFrame.origin.x == 187.5) && (selfFrame.origin.y == 1.5)) || ([self.text isEqualToString:@"\%"]))) {
			if (!([self.text isEqualToString:@"−"] || ([self.text isEqualToString:@"×"]) || ([self.text isEqualToString:@"÷"]) || ([self.text isEqualToString:@"+"]) || ([self.text isEqualToString:@"="]))) {

				UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
				if (!(UIDeviceOrientationIsLandscape(orientation))){
					self.font = [UIFont systemFontOfSize:45];
					self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
				} else if ((selfFrame.origin.x < 400)) {
					self.font = [UIFont systemFontOfSize:20];
					self.layer.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0].CGColor;
					//Scientific keypad buttons
				} else {
					self.font = [UIFont systemFontOfSize:25];
					self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
				}
				self.textColor = [UIColor whiteColor];

				//Normal keys
			} else if (!([self.text isEqualToString:@"."])) {
				self.layer.backgroundColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0].CGColor;
				UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
				if (!(UIDeviceOrientationIsLandscape(orientation))){
					self.font = [UIFont systemFontOfSize:45];
				} else {
					self.font = [UIFont systemFontOfSize:25];
				}
				self.userInteractionEnabled = YES;
				UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
				[tap setNumberOfTapsRequired:1];
				tap.cancelsTouchesInView = NO;
				[self addGestureRecognizer:tap];
				//Orange Divide and multiply etc.
			} else {
				self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
				UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
				if (!(UIDeviceOrientationIsLandscape(orientation))){
					self.font = [UIFont systemFontOfSize:35];
				} else {
					self.font = [UIFont systemFontOfSize:25];
				}
				//If it's a '.'
			}
		} else {
			//The AC Button & Friends
			self.layer.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0].CGColor;
			self.textColor = [UIColor blackColor];
			UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
			if (!(UIDeviceOrientationIsLandscape(orientation))){
				self.font = [UIFont systemFontOfSize:40];
			} else {
				self.font = [UIFont systemFontOfSize:25];
			}
		}
		self.layer.cornerRadius = self.bounds.size.height / 2;

	} else {
		self.textColor = [UIColor whiteColor];
	}
	//      self.translatesAutoresizingMaskIntoConstraints = NO;
	self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
}

-(void)setFrame {

	if ([self.text isEqualToString:@"0"]) {
		CGRect frame = self.frame;
		CGFloat currentWidth = frame.size.width;
		frame.size.width = currentWidth *2;
	}
}


- (void)_updateAutoresizingConstraints {
	self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
}

- (void)_updateContentSizeConstraints{
	self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
}

%new

- (void)tapAction {
	[UIView animateWithDuration:0.0 animations:^{
		self.layer.backgroundColor = [UIColor whiteColor].CGColor;
		self.textColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0];
	}];
}

%end

%group Keypad

@interface KeypadView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@property (nonatomic, copy) NSArray *buttons;
@end

%hook KeypadView
-(void)layoutSubviews {
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	if (!(UIDeviceOrientationIsLandscape(orientation))){
		backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-120, 0, 500, 500)];
	} else {
		backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-120, 0, 800, 500)];
	}
	backgroundView.backgroundColor = [UIColor blackColor];
	[self addSubview:backgroundView];
	[self sendSubviewToBack:backgroundView];
	NSMutableArray *temp = [NSMutableArray arrayWithArray:((KeypadView*)self).buttons];
	if ([temp count] > 0) {

		UILabel *plusMinusButton = temp[1];
		UILabel *dotButton = temp[18];
		UILabel *zeroButton = temp[16];
		plusMinusButton.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
		plusMinusButton.textColor = [UIColor blackColor];
		[plusMinusButton layer].cornerRadius = plusMinusButton.bounds.size.height / 2;
		dotButton.font = [UIFont systemFontOfSize:35];
		CGRect frame = zeroButton.frame;
		CGFloat currentWidth = frame.size.width;
		frame.size.width = currentWidth *2.1;
		zeroButton.frame = frame;
		zeroButton.textAlignment = NSTextAlignmentLeft;
	}
	((KeypadView*)self).buttons = temp;


}

%end
%end
%ctor {
	%init(Keypad, KeypadView=objc_getClass("Calculator.CalculatorKeypadView"));
}


UIView *displayBackgroundView;

@interface DisplayView
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

%hook DisplayView
-(void)layoutSubviews {

	CGRect displayFrame = [self layer].frame;
	displayBackgroundView = [[UIView alloc] initWithFrame:displayFrame];
	displayBackgroundView.backgroundColor = [UIColor blackColor];
	[self addSubview:displayBackgroundView];
	[self layer].backgroundColor = [UIColor clearColor].CGColor;
	[self sendSubviewToBack:displayBackgroundView];

	[self layer].backgroundColor = [UIColor blackColor].CGColor;

}
%end

%ctor {
	%init(DisplayView=objc_getClass("Calculator.DisplayView"));
}
