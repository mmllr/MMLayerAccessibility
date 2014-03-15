//
//  NSViewMMLayerAccessibiltySpec.m
//  MMLayerAccessibilityDemo
//
//  Created by Markus Müller on 15.03.14.
//  Copyright 2014 Markus Müller. All rights reserved.
//

#import "Kiwi.h"

#import <CALayer+NSAccessibility.h>

@interface CustomTestView : NSView

@end

@implementation CustomTestView

- (BOOL) accessibilityIsIgnored
{
	return NO;
}

@end

SPEC_BEGIN(NSViewMMLayerAccessibiltySpec)

describe(@"NSView+MMLayerAccessibility", ^{
	__block CustomTestView *sut = nil;
	__block CALayer *layer = nil;

	beforeEach(^{
		sut = [[CustomTestView alloc] initWithFrame:NSMakeRect(0, 0, 300, 200)];
		layer = [CALayer layer];
	});
	afterEach(^{
		sut = nil;
		layer = nil;
	});
	context(NSStringFromSelector(@selector(setAccessiblityEnabledLayer:)), ^{
		it(@"should set the layer on the view", ^{
			[[sut should] receive:@selector(setLayer:) withArguments:layer];

			[sut setAccessiblityEnabledLayer:layer];
		});
		it(@"should have the layer as its roor layer", ^{
			[sut setAccessiblityEnabledLayer:layer];

			[[sut.layer should] equal:layer];
		});
		it(@"should set the view being layer backed", ^{
			[[sut should] receive:@selector(setWantsLayer:) withArguments:theValue(YES)];

			[sut setAccessiblityEnabledLayer:layer];
		});
		it(@"should set the view as the layers accessibility parent", ^{
			[sut setAccessiblityEnabledLayer:layer];
			
			[[[layer accessibilityAttributeValue:NSAccessibilityParentAttribute] should] equal:sut];
		});
		it(@"should raise an NSInternalInconsistencyException when invoked with a nil layer", ^{
			[[theBlock(^{
				[sut setAccessiblityEnabledLayer:nil];
			}) should] raiseWithName:NSInternalInconsistencyException];
		});
	});
});

SPEC_END
