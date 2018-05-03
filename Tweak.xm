/*
CalculatorXI
By Squ1dd13 (Alex)
This is a tweak to get the iOS 11 calculator on iOS 10 (and kind of 7-9 as well I think).
Slightly buggy, but works pretty well. The .deb is available at http://squ1dd13.tk/repo.
NOTE: Some of the classes that appear to have been hooked are actually just fake names. This is because they are Swift classes. Check the %ctor for the real class.
*/


#import "QuartzCore/QuartzCore.h"
#import <UIKit/UIKit.h>


UIView *backgroundView;
UIView *smallBackgroundView;



//we have to hook UILabel, because hooking this with Swift doesn't work
%hook UILabel

-(void)layoutSubviews {
	CGRect selfFrame = self.frame;
	BOOL allowChange = (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5)) && (![self.text isEqualToString:@"0"]));

	if (allowChange) {
		//Add the iOS 11 style circles, but give the non-numerical buttons their custom colours
		if (!([self.text isEqualToString:@"AC"]
		|| ([self.text isEqualToString:@"C"])
		|| ((selfFrame.origin.x == 187.5) && (selfFrame.origin.y == 1.5))
		|| ([self.text isEqualToString:@"\%"]))) {

			if (!([self.text isEqualToString:@"−"]
			|| ([self.text isEqualToString:@"×"])
			|| ([self.text isEqualToString:@"÷"])
			|| ([self.text isEqualToString:@"+"])
			|| ([self.text isEqualToString:@"="]))) {

					if (![self.text isEqualToString:@"Rad"]) {
						NSLog(@"Normal, using NSArray to change properties");

				} else if ((selfFrame.origin.x < 400)) {
					//Scientific keypad buttons
							if (![self.text isEqualToString:@"Rad"]) {
								self.font = [UIFont systemFontOfSize:20];
								//self.layer.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0].CGColor;
								self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
								NSLog(@"Scientific");


					}

				} else if (![self.text isEqualToString:@"0"]) {
					//Normal keys
					if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
						self.font = [UIFont systemFontOfSize:25];
						self.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

						UITapGestureRecognizer *scienceTap=[[UITapGestureRecognizer alloc] initWithTarget:self
						action:@selector(deselectAction)];
						[scienceTap setNumberOfTapsRequired:1];
						scienceTap.cancelsTouchesInView = NO;
						[self addGestureRecognizer:scienceTap];

						NSLog(@"Normal");
					}
				}

				self.textColor = [UIColor whiteColor];


			} else {
				//Orange Divide and multiply etc.
				self.layer.backgroundColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0].CGColor;
				UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
				if (!(UIDeviceOrientationIsLandscape(orientation))){
					self.font = [UIFont systemFontOfSize:45];
				} else {
					self.font = [UIFont systemFontOfSize:25];
				}
				self.userInteractionEnabled = YES;
				UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self
				action:@selector(tapAction)];
				[tap setNumberOfTapsRequired:1];
				tap.cancelsTouchesInView = NO;
				[self addGestureRecognizer:tap];
				NSLog(@"Action Buttons");

			}
		} else {
			//The AC Button & Friends
			self.layer.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0].CGColor;
			self.textColor = [UIColor blackColor];
			UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
			if (!(UIDeviceOrientationIsLandscape(orientation))){
				self.font = [UIFont systemFontOfSize:40];
			} else if (!([self.text isEqualToString:@"AC"] || [self.text isEqualToString:@"C"])) {
				self.font = [UIFont systemFontOfSize:25];
			}
			NSLog(@"AC Etc.");
		}
		if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
			self.layer.cornerRadius = self.bounds.size.height / 2;
			NSLog(@"Setting corner radius");
		}

	} else {

		self.textColor = [UIColor whiteColor];
		//self.font = [UIFont systemFontOfSize:60];
		//self.layer.backgroundColor = [UIColor clearColor].CGColor;
		NSLog(@"White text");
	}
	if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
		//if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
		self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
		NSLog(@"Transform");
	}
	//}
	if ((selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
		self.font = [UIFont systemFontOfSize:115 weight:0.01];
		//CGRect frame = self.frame;
		//frame.origin.y = 98.5;
		//self.frame = frame;
	}
}


- (void)_updateAutoresizingConstraints {
	if (![self.text isEqualToString:@"0"]) {
		CGRect selfFrame = self.frame;
		if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
			//self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
			NSLog(@"_updateAutoresizingConstraints");
		}
	}
}

- (void)_updateContentSizeConstraints{
	if (![self.text isEqualToString:@"0"]) {
		CGRect selfFrame = self.frame;
		if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
			//self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
			NSLog(@"_updateContentSizeConstraints");
		}
	}
}
/*
-(void)setFrame {
CGRect selfFrame = self.frame;
if ((selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
CGRect displayFrame = self.frame;
displayFrame.origin.
}
*/

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
						[self bringSubviewToFront:button];

					} else if (![button.text isEqualToString:@"0"]) {
						CGRect selfFrame = button.frame;
						if (!(selfFrame.size.height == 116.5 || (selfFrame.size.height == 51.5))) {
							if (!([self.text isEqualToString:@"AC"] || ([self.text isEqualToString:@"C"])
							|| ((selfFrame.origin.x == 187.5) && (selfFrame.origin.y == 1.5))
							|| ([self.text isEqualToString:@"\%"])) && !([button.text isEqualToString:@"0"])) {
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
								}
							}
						} else {
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
/*
%new

-(void)deselectAction {

//We won't bother with the animations for now
for (UILabel *actionButton in self.superview.subviews) {
if ([actionButton isKindOfClass:[UILabel class]]) {
if (([actionButton.text isEqualToString:@"−"] || ([actionButton.text isEqualToString:@"×"]) || ([actionButton.text isEqualToString:@"÷"]) || ([actionButton.text isEqualToString:@"+"]) || ([actionButton.text isEqualToString:@"="]))) {
[UIView animateWithDuration:0.0 animations:^{
self.layer.backgroundColor = [UIColor whiteColor].CGColor;
self.textColor = [UIColor colorWithRed:1.00 green:0.56 blue:0.00 alpha:1.0];
}
}
}
}
}
*/
%end


%group Keypad

@interface KeypadView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@property (nonatomic, copy) NSArray *buttons;
@property (nonatomic, assign, readwrite) CGRect frame;
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
		UILabel *blankLabel = temp[17];

		if (![plusMinusButton.text isEqualToString:@")"]) {

			UILabel *oneButton = temp[12];
			UILabel *twoButton = temp[13];
			UILabel *threeButton = temp[14];
			UILabel *fourButton = temp[8];
			UILabel *fiveButton = temp[9];
			UILabel *sixButton = temp[10];
			UILabel *sevenButton = temp[4];
			UILabel *eightButton = temp[5];
			UILabel *nineButton = temp[6];
			UILabel *zeroButton = temp[16];
			plusMinusButton.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
			plusMinusButton.textColor = [UIColor blackColor];
			plusMinusButton.clipsToBounds = YES;
			[plusMinusButton layer].cornerRadius = plusMinusButton.bounds.size.height / 2;
			blankLabel.hidden = YES;
			/*
			CGRect newFrame;
			newFrame.size.width = 185;
			newFrame.origin.x = 1.5;
			zeroButton.frame = newFrame;
			zeroButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
			zeroButton.textColor = [UIColor whiteColor];
			zeroButton.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
			*/

			//Original attempt
			zeroButton.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
			CGRect frame = zeroButton.frame;
			zeroButton.text = @"   0";
			//frame.origin.x = 1.5;
			frame.size.width = 170;
			zeroButton.frame = frame;
			zeroButton.textAlignment = NSTextAlignmentLeft;
			zeroButton.font = [UIFont systemFontOfSize:45];
			zeroButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
			zeroButton.textColor = [UIColor whiteColor];

			oneButton.font = [UIFont systemFontOfSize:45];
			oneButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			twoButton.font = [UIFont systemFontOfSize:45];
			twoButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			threeButton.font = [UIFont systemFontOfSize:45];
			threeButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			fourButton.font = [UIFont systemFontOfSize:45];
			fourButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			fiveButton.font = [UIFont systemFontOfSize:45];
			fiveButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			sixButton.font = [UIFont systemFontOfSize:45];
			sixButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			sevenButton.font = [UIFont systemFontOfSize:45];
			sevenButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			eightButton.font = [UIFont systemFontOfSize:45];
			eightButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			nineButton.font = [UIFont systemFontOfSize:45];
			nineButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			dotButton.font = [UIFont systemFontOfSize:45 weight:0.1];
			dotButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			NSLog(@"Zero");



		} else {
			UILabel *oneButton = temp[36];
			UILabel *twoButton = temp[37];
			UILabel *threeButton = temp[38];
			UILabel *fourButton = temp[26];
			UILabel *fiveButton = temp[27];
			UILabel *sixButton = temp[28];
			UILabel *sevenButton = temp[16];
			UILabel *eightButton = temp[17];
			UILabel *nineButton = temp[18];

			UILabel *zeroButton = temp[46];
			UILabel *cACButton = temp[6];
			zeroButton.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
			CGRect frame = zeroButton.frame;
			zeroButton.text = @"   0";
			//frame.origin.x = 1.5;
			frame.size.width = 110;
			zeroButton.frame = frame;
			zeroButton.textAlignment = NSTextAlignmentLeft;
			zeroButton.font = [UIFont systemFontOfSize:25];
			zeroButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;
			zeroButton.textColor = [UIColor whiteColor];

			cACButton.font = [UIFont systemFontOfSize:25];

			oneButton.font = [UIFont systemFontOfSize:25];
			oneButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			twoButton.font = [UIFont systemFontOfSize:25];
			twoButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			threeButton.font = [UIFont systemFontOfSize:25];
			threeButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			fourButton.font = [UIFont systemFontOfSize:25];
			fourButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			fiveButton.font = [UIFont systemFontOfSize:25];
			fiveButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			sixButton.font = [UIFont systemFontOfSize:25];
			sixButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			sevenButton.font = [UIFont systemFontOfSize:25];
			sevenButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			eightButton.font = [UIFont systemFontOfSize:25];
			eightButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			nineButton.font = [UIFont systemFontOfSize:25];
			nineButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			dotButton.font = [UIFont systemFontOfSize:25 weight:0.1];
			dotButton.layer.backgroundColor = [UIColor colorWithRed:0.22 green:0.20 blue:0.20 alpha:1.0].CGColor;

			//radDegButton.font = [UIFont systemFontOfSize:20];
			//radDegButton.layer.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0].CGColor;
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
@property (nonatomic, assign, readwrite) NSInteger maximumResultDigits;
@property (nonatomic, assign, readwrite) NSArray *subviews;
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@property (nonatomic, assign) CALayer *layer;
@end

%hook DisplayView

- (void)loadView {
	((DisplayView*)self).hidden = YES;
}

-(void)setBackgroundColor:(id)arg1 {
	arg1 = [UIColor clearColor];
}
-(NSInteger)maximumResultDigits {
	return 999;
}

%end

%ctor {
	%init(DisplayView=objc_getClass("Calculator.DisplayView"));
}

@interface UIButtonLabel
@property(retain, nonatomic) UIFont *font;
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@property (setter=_setCornerRadius:, nonatomic) double _cornerRadius;
@end
//Fix the UIButtonLabels of the action menu (copy, paste etc.)
%hook UIButtonLabel

-(void)layoutSubviews {
	%orig;
	//self.font = [UIFont systemFontOfSize:14];
	self.backgroundColor = [UIColor clearColor];
	//self._cornerRadius = 0;

}

%end
