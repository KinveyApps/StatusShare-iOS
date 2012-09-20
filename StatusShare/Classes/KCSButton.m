//
//  KCSButton.m
//
//  Copyright (c) 2012 Kinvey. All rights reserved.
//

#import "KCSButton.h"
#import "UIColor+KinveyHelpers.h"

@implementation KCSButton

- (void) commonInit
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self setReversesTitleShadowWhenHighlighted:YES];
    self.titleLabel.shadowOffset = CGSizeMake(0., 1.);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    
    [self setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    [self setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.2] forState:UIControlStateDisabled];
    
    [self addObserver:self forKeyPath:@"highlighted" options:0 context:nil];
}

- (id) init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"highlighted"];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath* roundRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height/4];

    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    [[UIColor whiteColor] setFill];
    [roundRect fill];
    
    
	CGContextAddPath(ctx, roundRect.CGPath);
	CGContextClip(ctx);
	
    
    UIColor* strokeColor = [UIColor blackColor];
    NSArray* colors = nil;
    if (self.enabled == NO) {
        colors = [NSArray arrayWithObjects:(id)[[[UIColor kinveyOrange] darkerColor] colorWithAlphaComponent:0.5].CGColor, (id) [[UIColor kinveyOrange] colorWithAlphaComponent:0.5].CGColor, (id)[[[UIColor kinveyOrange] lighterColor] colorWithAlphaComponent:0.5].CGColor, nil];
        strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } else if (self.highlighted == YES) {
        colors = [NSArray arrayWithObjects:(id)[UIColor kinveyOrange].CGColor, (id)[UIColor kinveyOrange].CGColor, (id)[[UIColor kinveyOrange] darkerColor].CGColor, nil];
        
    } else {
        colors = [NSArray arrayWithObjects:(id)[[UIColor kinveyOrange] darkerColor].CGColor, (id)[UIColor kinveyOrange].CGColor, (id)[[UIColor kinveyOrange] lighterColor].CGColor, nil];
    }

    
    CGFloat locations[] = {1.0, 0.5, 0.0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef fillGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGContextDrawLinearGradient(ctx, fillGradient, CGPointMake(0, CGRectGetMinY(rect)), CGPointMake(0, CGRectGetMaxY(rect)), 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(fillGradient);

    [strokeColor setStroke];
    roundRect.lineWidth = 2.;
    [roundRect stroke];
    
    CGContextRestoreGState(ctx);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"highlighted"] || [keyPath isEqualToString:@"enabled"]) {
        [self setNeedsDisplay];
    }
}

@end
