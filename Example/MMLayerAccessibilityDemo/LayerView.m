/*
 
 The MIT License (MIT)
 
 Copyright (c) 2014 Markus Müller https://github.com/mmllr All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this
 software and associated documentation files (the "Software"), to deal in the Software
 without restriction, including without limitation the rights to use, copy, modify, merge,
 publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies
 or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 DEALINGS IN THE SOFTWARE.
 
 */
//
//  LayerView.m
//  MMLayerAccessibility
//
//  Created by Markus Müller on 07.10.13.
//  Copyright (c) 2013 Markus Müller. All rights reserved.
//

#import "LayerView.h"
#import <CALayer+NSAccessibility.h>

@implementation LayerView

#pragma mark - init

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [ self setupLayers ];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [ self setupLayers ];
    }
    return self;
}

- (void)setupLayers
{
	CALayer *layer = [ self createBackgroundLayer ];

	[ self setAccessiblityEnabledLayer:layer ];
}

- (CALayer*)createBackgroundLayer
{
	CALayer *layer = [CALayer layer];
	layer.position = CGPointMake( 0, 0 );
	layer.bounds = [self convertRectToBacking:[ self bounds ]];
	layer.backgroundColor = [ NSColor blackColor ].CGColor;
	layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	layer.layoutManager = [ CAConstraintLayoutManager layoutManager ];
	[ layer setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
		return NSAccessibilityLayoutAreaRole;
	}];
	[layer addSublayer:[self createDemoLayer]];
	[layer addSublayer:[self createTextLayer]];
	[layer addSublayer:[self createButtonLayer]];
	[layer addSublayer:[self createImageLayer]];
	return layer;
}

- (CALayer*)createDemoLayer
{
	CALayer *layer = [CALayer layer];
	layer.name = @"colorWell";
	layer.backgroundColor = [NSColor redColor].CGColor;
	layer.bounds = CGRectMake( 0, 0, 40, 40 );
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
													relativeTo:@"superlayer"
													 attribute:kCAConstraintMidX]];
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
													relativeTo:@"superlayer"
													 attribute:kCAConstraintMidY]];

	[layer setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
		return NSAccessibilityColorWellRole;
	}];
	[layer setReadableAccessibilityAttribute:NSAccessibilityDescriptionAttribute withBlock:^id{
		return NSLocalizedString(@"Choose a color", @"color well ax desctription");
	}];
	return layer;
}

- (CALayer*)createTextLayer
{
	CATextLayer *layer = [ CATextLayer layer ];
	layer.name = @"textlayer";
	layer.backgroundColor = [NSColor blueColor].CGColor;
	layer.bounds = CGRectMake(0, 0, 100, 40);
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
													relativeTo:@"superlayer"
													 attribute:kCAConstraintMidX]];
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
													relativeTo:@"colorWell"
													 attribute:kCAConstraintMaxY
														offset:10]];
	layer.string = @"Hello world";
	// accessibility
	__weak CATextLayer *weakLayer = layer;
	[layer setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
		return NSAccessibilityTextFieldRole;
	}];
	[layer setWritableAccessibilityAttribute:NSAccessibilityTitleAttribute readBlock:^id{
		return weakLayer.string;
	} writeBlock:^(NSString *value) {
		weakLayer.string = value;
	}];
	[layer setReadableAccessibilityAttribute:NSAccessibilityNumberOfCharactersAttribute withBlock:^id{
		return @([weakLayer.string length]);
	}];
	[layer setParameterizedAccessibilityAttribute:NSAccessibilityLineForIndexParameterizedAttribute
										withBlock:^id(id param) {
											return @0;
										}];
	[layer setParameterizedAccessibilityAttribute:NSAccessibilityRangeForLineParameterizedAttribute
										withBlock:^id(id param) {
											return [NSValue valueWithRange:NSMakeRange(0, [weakLayer.string length])];
										}];
	[layer setParameterizedAccessibilityAttribute:NSAccessibilityRangeForPositionParameterizedAttribute
										withBlock:^id(NSValue *param) {
											return [ NSValue valueWithRange:NSMakeRange(0, 1)];
										}];
	[layer setParameterizedAccessibilityAttribute:NSAccessibilityBoundsForRangeParameterizedAttribute withBlock:^id(id param) {
		return [NSValue valueWithRect:NSMakeRect(0, 0, 20, 20)];
	}];
	return layer;
}

- (CALayer*)createButtonLayer
{
	CATextLayer *layer = [CATextLayer layer];
	layer.name = @"button";
	layer.backgroundColor = [NSColor greenColor].CGColor;
	layer.bounds = CGRectMake( 0, 0, 40, 40 );
	layer.string = @"Button";
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
													relativeTo:@"superlayer"
													 attribute:kCAConstraintMidX]];
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
													relativeTo:@"colorWell"
													 attribute:kCAConstraintMinY
														offset:-10]];
	// accessibility
	[layer setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
		return NSAccessibilityButtonRole;
	}];
	__weak CATextLayer *weakLayer = layer;

	[layer setReadableAccessibilityAttribute:NSAccessibilityTitleAttribute
								   withBlock:^id{
									   return weakLayer.string;
								   }];
	[layer setAccessibilityAction:NSAccessibilityPressAction
						withBlock:^{
							NSLog(@"action pressed");
						}];
	return layer;

}

- (CALayer*)createImageLayer
{
	CALayer *layer = [ CALayer layer ];
	layer.bounds = CGRectMake(0, 0, 100, 100);
	layer.backgroundColor = [NSColor whiteColor].CGColor;
	layer.contents = [ NSImage imageNamed:@"Elefant" ];
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
													relativeTo:@"textlayer"
													 attribute:kCAConstraintMinX
						  offset:-40]];
	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
													relativeTo:@"superlayer"
													 attribute:kCAConstraintMidY
														offset:-10]];
	[layer setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
		return NSAccessibilityImageRole;
	}];
	[layer setReadableAccessibilityAttribute:NSAccessibilityDescriptionAttribute withBlock:^id{
		return NSLocalizedString(@"Strange elephant", @"Elephant image");
	}];
	return layer;
}


#pragma mark - NSAccessibility

#if 1

- (NSArray*)accessibilityAttributeNames
{
	static NSMutableArray *attributes = nil;

	if ( !attributes ) {
		attributes = [[super accessibilityAttributeNames] mutableCopy];
		NSArray *appendedAttributes = @[NSAccessibilityChildrenAttribute];

		for ( NSString *attribute in appendedAttributes ) {
			if ( ![attributes containsObject:attributes] ) {
				[attributes addObject:attribute];
			}
		}
	}
	return attributes;
}

- (id)accessibilityAttributeValue:(NSString *)attribute
{
	if ( [attribute isEqualToString:NSAccessibilityChildrenAttribute] ) {
		return NSAccessibilityUnignoredChildren(@[self.layer]);
	}
	return [ super accessibilityAttributeValue:attribute];
}

- (id)accessibilityHitTest:(NSPoint)aPoint
{
	NSPoint windowPoint = [ [ self window ] convertScreenToBase:aPoint ];
    CGPoint localPoint = NSPointToCGPoint([ self convertPoint:windowPoint
													 fromView:nil ] );

	CALayer *presentationLayer = [ self.layer presentationLayer ];
	CALayer *hitLayer = [ presentationLayer hitTest:localPoint ];
	return hitLayer ? NSAccessibilityUnignoredAncestor( [hitLayer modelLayer] ) : self;
}

#endif

@end
