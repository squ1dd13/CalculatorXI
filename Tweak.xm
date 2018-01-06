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
				if (!(UIDeviceOrientationIsLandscape(orientation)) && !([self.text isEqualToString:@"0"])) {
					if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
						self.font = [UIFont systemFontOfSize:45];
						self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
						UITapGestureRecognizer *normalTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deselectAction)];
						[normalTap setNumberOfTapsRequired:1];
						normalTap.cancelsTouchesInView = NO;
						[self addGestureRecognizer:normalTap];
					}
				} else if ((selfFrame.origin.x < 400)) {
					if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
						self.font = [UIFont systemFontOfSize:20];
						self.layer.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0].CGColor;
					}
					//Scientific keypad buttons
				} else if (![self.text isEqualToString:@"0"]) {
					//if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
						self.font = [UIFont systemFontOfSize:25];
						self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
						UITapGestureRecognizer *scienceTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deselectAction)];
						[scienceTap setNumberOfTapsRequired:1];
						scienceTap.cancelsTouchesInView = NO;
						[self addGestureRecognizer:scienceTap];
					//}
				}
				self.textColor = [UIColor whiteColor];

				//Normal keys
			} else if (!([self.text isEqualToString:@"0"])) {
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
		if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
			self.layer.cornerRadius = self.bounds.size.height / 2;
		}

	} else if (![self.text isEqualToString:@"0"]) {

		self.textColor = [UIColor whiteColor];
	}
	if (![self.text isEqualToString:@"0"]) {
		if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
			self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
		}
	}
}


- (void)_updateAutoresizingConstraints {
	if (![self.text isEqualToString:@"0"]) {
		CGRect selfFrame = self.frame;
		if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
			self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
		}
	}
}

- (void)_updateContentSizeConstraints{
	if (![self.text isEqualToString:@"0"]) {
		CGRect selfFrame = self.frame;
		if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
			self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
		}
	}
}

%new

- (void)tapAction {
	if (![self.text isEqualToString:@"="]) {
		[UIView animateWithDuration:0.0 animations:^{
			self.layer.backgroundColor = [UIColor whiteColor].CGColor;
			self.textColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0];
			for (UILabel *button in self.superview.subviews) {
				if ([button isKindOfClass:[UILabel class]]) {
					if (([button.text isEqualToString:@"−"] || ([button.text isEqualToString:@"×"]) || ([button.text isEqualToString:@"÷"]) || ([button.text isEqualToString:@"+"]) || ([button.text isEqualToString:@"="]))) {
						button.layer.backgroundColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0].CGColor;
						button.textColor = [UIColor whiteColor];
					} else if (![button.text isEqualToString:@"0"]) {
						CGRect selfFrame = button.frame;
						if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
							if (!([self.text isEqualToString:@"AC"] || ([self.text isEqualToString:@"C"]) || ((selfFrame.origin.x == 187.5) && (selfFrame.origin.y == 1.5)) || ([self.text isEqualToString:@"\%"])) && !([button.text isEqualToString:@"0"])) {
								UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
								if (!(UIDeviceOrientationIsLandscape(orientation)) && !([self.text isEqualToString:@"0"])) {
									if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
										self.font = [UIFont systemFontOfSize:45];
										self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
									}
								} else if ((selfFrame.origin.x < 400)) {
									if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
										self.font = [UIFont systemFontOfSize:20];
										self.layer.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0].CGColor;
									}
									//Scientific keypad buttons
								} else if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5) || (![self.text isEqualToString:@"0"]))) {
										self.font = [UIFont systemFontOfSize:25];
										self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

								}
								self.textColor = [UIColor whiteColor];
							} else if (![self.text isEqualToString:@"0"]) {
								self.layer.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0].CGColor;
								self.textColor = [UIColor blackColor];
								UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
								if (!(UIDeviceOrientationIsLandscape(orientation))){
									self.font = [UIFont systemFontOfSize:40];
								} else {
									self.font = [UIFont systemFontOfSize:25];
								}
							}
						} else if (![self.text isEqualToString:@"0"]) {
							self.textColor = [UIColor whiteColor];
						}
					}
				}
			}
			if (![self.text isEqualToString:@"="]) {
				self.layer.backgroundColor = [UIColor whiteColor].CGColor;
				self.textColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0];
			}
		}];
	}
}

%new

-(void)deselectAction {

	//We won't bother with the animations for now
	for (UILabel *actionButton in self.superview.subviews) {
		if ([actionButton isKindOfClass:[UILabel class]]) {
			if (([actionButton.text isEqualToString:@"−"] || ([actionButton.text isEqualToString:@"×"]) || ([actionButton.text isEqualToString:@"÷"]) || ([actionButton.text isEqualToString:@"+"]) || ([actionButton.text isEqualToString:@"="]))) {
				actionButton.layer.backgroundColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0].CGColor;
				actionButton.textColor = [UIColor whiteColor];
			}
			}
		}
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
		if (![plusMinusButton.text isEqualToString:@")"]) {
			plusMinusButton.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
			plusMinusButton.textColor = [UIColor blackColor];
			plusMinusButton.clipsToBounds = YES;
			[plusMinusButton layer].cornerRadius = plusMinusButton.bounds.size.height / 2;
			dotButton.font = [UIFont systemFontOfSize:35];
			CGRect frame = zeroButton.frame;
			frame.origin.x = 1.5;
			frame.size.width = 185;
			zeroButton.frame = frame;
			zeroButton.textAlignment = NSTextAlignmentLeft;
			zeroButton.font = [UIFont systemFontOfSize:25];
			zeroButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
			zeroButton.textColor = [UIColor whiteColor];
			zeroButton.transform = CGAffineTransformMakeScale(0.8f, 0.8f);

		}
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
	/*
	CGRect displayFrame = [self layer].frame;
	displayBackgroundView = [[UIView alloc] initWithFrame:displayFrame];
	displayBackgroundView.backgroundColor = [UIColor blackColor];
	[self addSubview:displayBackgroundView];
	[self layer].backgroundColor = [UIColor clearColor].CGColor;
	[self sendSubviewToBack:displayBackgroundView];

	[self layer].backgroundColor = [UIColor blackColor].CGColor;
	*/
	%orig;

}
%end

%ctor {
	%init(DisplayView=objc_getClass("Calculator.DisplayView"));
}
