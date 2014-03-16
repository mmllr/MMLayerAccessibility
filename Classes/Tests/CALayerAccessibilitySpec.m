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
//  CALayerAccessibilitySpec.m
//  MMLayerAccessibility
//
//  Created by Markus Müller on 03.10.13.
//  Copyright 2013 Markus Müller. All rights reserved.
//

#import <Kiwi.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <CALayer+NSAccessibility.h>
#import <CALayer+MMLayerAccessibilityPrivate.h>

SPEC_BEGIN(CALayerAccessibilitySpec)

describe(@"CALayer+NSAccessibility", ^{
	__block CALayer *sut = nil;
	__block NSArray *defaultAttributes = nil;
	beforeAll(^{
		defaultAttributes = @[NSAccessibilityParentAttribute, NSAccessibilitySizeAttribute, NSAccessibilityPositionAttribute, NSAccessibilityWindowAttribute, NSAccessibilityTopLevelUIElementAttribute, NSAccessibilityRoleAttribute, NSAccessibilityRoleDescriptionAttribute, NSAccessibilityEnabledAttribute, NSAccessibilityFocusedAttribute];
	});
	afterAll(^{
		defaultAttributes = nil;
	});

	beforeEach(^{
		sut = [ CALayer layer ];
	});
	afterEach(^{
		sut = nil;
	});
	context(@"a new instance", ^{
		it(@"should exist", ^{
			[[ sut shouldNot ] beNil ];
		});
		it(@"should conform to the MMLayerAccessibility protocol", ^{
			[[sut should] conformToProtocol:@protocol(MMLayerAccessibility)];
		});
		context(@"MMLayerAccessibility", ^{
			context(NSStringFromSelector(@selector(setReadableAccessibilityAttribute:withBlock:)), ^{
				it(@"should respond to setReadableAccessibilityAttribute:withBlock", ^{
					[[sut should] respondToSelector:@selector(setReadableAccessibilityAttribute:withBlock:)];
				});
				it(@"should throw an NSInternalInconsistencyException when if invoked with nil attribute", ^{
					[[theBlock(^{
						[sut setReadableAccessibilityAttribute:nil withBlock:^id{
							return nil;
						}];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
				it(@"should throw an NSInternalInconsistencyException when invoked with empty handler", ^{
					[[theBlock(^{
						[sut setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:nil ];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
			});
			context(NSStringFromSelector(@selector(setWritableAccessibilityAttribute:readBlock:writeBlock:)), ^{
				it(@"should respond to setWritableAccessibilityAttribute:readBlock:writeBlock:", ^{
					[[sut should] respondToSelector:@selector(setWritableAccessibilityAttribute:readBlock:writeBlock:)];
				});
				it(@"should throw an NSInternalInconsistencyException when invoked with nil attribute", ^{
					[[theBlock(^{
						[sut setWritableAccessibilityAttribute:nil readBlock:^id{
							return nil;
						} writeBlock:^(id value) {
						}];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
				it(@"should raise an NSInternalInconsistencyException with empty getter", ^{
					[[theBlock(^{
						[sut setWritableAccessibilityAttribute:NSAccessibilityRoleAttribute readBlock:nil writeBlock:^(id value){
						}];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
				it(@"should raise an NSInternalInconsistencyException with empty setter", ^{
					[[theBlock(^{
						[sut setWritableAccessibilityAttribute:NSAccessibilityRoleAttribute readBlock:(id(^)(void))^{
							return nil;
						}writeBlock:nil];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
				it(@"should raise an NSInternalInconsistencyException with empty handlers", ^{
					[[theBlock(^{
						[sut setWritableAccessibilityAttribute:NSAccessibilityRoleAttribute readBlock:nil writeBlock:nil ];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
				
			});
			context(NSStringFromSelector(@selector(removeAccessibilityAttribute:)), ^{
				it(@"should respond to removeAccessibilityAttribute:", ^{
					[[sut should] respondToSelector:@selector(removeAccessibilityAttribute:)];
				});
				it(@"should raise an NSInternalInconsistencyException with nil attribute", ^{
					[[theBlock(^{
						[sut removeAccessibilityAttribute:nil];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
				it(@"should not remove a build in attribute", ^{
					NSView *viewMock = [NSView nullMock];
					NSWindow *windowMock = [NSWindow nullMock];
					[viewMock stub:@selector(accessibilityAttributeValue:) andReturn:windowMock];
					[sut stub:@selector(mm_accessibilityParent) andReturn:viewMock];

					for (NSString *attribute in defaultAttributes) {
						[sut removeAccessibilityAttribute:attribute];
						[[[sut accessibilityAttributeValue:attribute] shouldNot] beNil];
					}
				});
			});
			context(NSStringFromSelector(@selector(setAccessibilityAction:withBlock:)), ^{
				it(@"should respond tor setAccessibilityAction:withBlock:", ^{
					[[sut should] respondToSelector:@selector(setAccessibilityAction:withBlock:)];
				});
				it(@"should throw an NSInternalInconsistencyException when if invoked with nil attribute", ^{
					[[theBlock(^{
						[sut setAccessibilityAction:nil withBlock:^{
						}];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});

				it(@"should raise an NSInternalInconsistencyException with empty action handler", ^{
					[[theBlock(^{
						[sut setAccessibilityAction:NSAccessibilityPressAction
										  withBlock:nil ];
					}) should] raise];
				});
				
			});
			context(NSStringFromSelector(@selector(setParameterizedAccessibilityAttribute:withBlock:)), ^{
				it(@"should respond to accessibilityParameterizedAttributeNames", ^{
					[[sut should] respondToSelector:@selector(accessibilityParameterizedAttributeNames)];
				});
				it(@"should throw an NSInternalInconsistencyException when if invoked with nil attribute", ^{
					[[theBlock(^{
						[sut setParameterizedAccessibilityAttribute:nil withBlock:^id(id value){
							return nil;
						}];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
				it(@"should raise an NSInternalInconsistencyException with empty handler", ^{
					[[theBlock(^{
						[sut setParameterizedAccessibilityAttribute:NSAccessibilityLineForIndexParameterizedAttribute withBlock:nil];
					}) should] raiseWithName:NSInternalInconsistencyException];
				});
			});
		});
		context(@"NSAccessibility conformance", ^{
			it(@"should respond to accessibilityAttributeValue:", ^{
				[ [ sut should ] respondToSelector:@selector(accessibilityAttributeValue:)];
			});
			it(@"should respond to accessibilitySetValue:forAttribute:", ^{
				[[ sut should ] respondToSelector:@selector(accessibilitySetValue:forAttribute:)];
			});
			it(@"should respond to accessibilityAttributeNames", ^{
				[[sut should] respondToSelector:@selector(accessibilityAttributeNames)];
			});
			it(@"should respond to accessibilityIsAttributeSettable", ^{
				[[sut should] respondToSelector:@selector(accessibilityIsAttributeSettable:)];
			});
			it(@"should respond to accessibilityParameterizedAttributeNames", ^{
				[[sut should] respondToSelector:@selector(accessibilityParameterizedAttributeNames)];
			});
			it(@"should respond to accessibilityAttributeValue:forParameter:", ^{
				[[sut should] respondToSelector:@selector(accessibilityAttributeValue:forParameter:)];
			});
			it(@"should respond to accessibilityActionNames", ^{
				[[sut should] respondToSelector:@selector(accessibilityActionNames)];
			});
			it(@"should respond to accessibilityPerformAction:", ^{
				[[sut should] respondToSelector:@selector(accessibilityPerformAction:)];
			});
			it(@"should respond to accessibilityActionDescription:", ^{
				[[sut should] respondToSelector:@selector(accessibilityActionDescription:)];
			});
			it(@"should respond to accessibilityIsIgnored", ^{
				[[ sut should ] respondToSelector:@selector(accessibilityIsIgnored) ];
			});
			it(@"should respond to accessibilityHitTest:", ^{
				[[sut should] respondToSelector:@selector(accessibilityHitTest:)];
			});
		});
		context(@"default attributes", ^{
			it(@"should have the correct default attributes count", ^{
				[[[sut should] have:[defaultAttributes count] ] accessibilityAttributeNames];
			});
			it(@"should handle default attributes", ^{
				[[[sut accessibilityAttributeNames] should] containObjectsInArray:defaultAttributes];
			});
		});
		context(@"attributes", ^{
			it(@"should return NSAccessibilityUnknownRole for role attribute", ^{
				[[[sut accessibilityAttributeValue:NSAccessibilityRoleAttribute] should] equal:NSAccessibilityUnknownRole];
			});
			it(@"should return nil for accessibilityAttributeValue with nil attribute name", ^{
				[[[sut accessibilityAttributeValue:nil] should] beNil];
			});
			it(@"should return NO for the default NSAccessibilityFocusedAttribute", ^{
				[[[sut accessibilityAttributeValue:NSAccessibilityFocusedAttribute] should] beNo];
			});
			it(@"should return YES for the default NSAccessibilityEnabledAttribute", ^{
				[[[sut accessibilityAttributeValue:NSAccessibilityEnabledAttribute] should] beYes];
			});
			it(@"should raise when asking for its NSAccessibilityParentAttribute without a parent", ^{
				[[theBlock(^{
					[sut accessibilityAttributeValue:NSAccessibilityParentAttribute];
				}) should] raiseWithName:NSInternalInconsistencyException
				 reason:@"No accessibility parent available"];
			});
		});
		context(@"parameterized attributes", ^{
			it(@"should have zero paremterized attribute names", ^{
				[[[sut should] have:0] accessibilityParameterizedAttributeNames];
			});
			context(@"layer with parameterized attribute", ^{
				__block NSNumber *handlerInvoked = nil;

				beforeEach(^{
					[sut setParameterizedAccessibilityAttribute:NSAccessibilityLineForIndexParameterizedAttribute withBlock:^id(id param) {
						return handlerInvoked = @YES;
					}];
				});
				afterEach(^{
					handlerInvoked = nil;
				});
				it(@"should return the parameterized attribute in accessibilityParameterizedAttributeNames", ^{
					[[[sut accessibilityParameterizedAttributeNames] should] contain:NSAccessibilityLineForIndexParameterizedAttribute];
				});
				it(@"should invoke the handler", ^{
					[[[sut accessibilityAttributeValue:NSAccessibilityLineForIndexParameterizedAttribute
										  forParameter:@0 ] should] beYes];
				});
				context(@"removing the parameterized attribute", ^{
					beforeEach(^{
						[sut removeAccessibilityAttribute:NSAccessibilityLineForIndexParameterizedAttribute];
					});
					it(@"should have no NSAccessibilityLineForIndexParameterizedAttribute", ^{
						[[[sut accessibilityParameterizedAttributeNames] shouldNot] contain:NSAccessibilityLineForIndexParameterizedAttribute];
					});
				});
			});
		});
		context(@"actions", ^{
			it(@"should have zero actions", ^{
				[[[sut should] have:0] accessibilityActionNames];
			});
		});
		it(@"should return YES to accessibilityIsIgnored",^{
			[[ theValue([ sut accessibilityIsIgnored ]) should ] beYes ];
		});
		it(@"should throw if invoked with empty handlers", ^{
			[[theBlock(^{
				[sut setWritableAccessibilityAttribute:NSAccessibilityRoleAttribute
								readBlock:nil
							   writeBlock:nil ];
			}) should] raise];
		});
		
	});
	context(@"unignored layer", ^{
		beforeEach(^{
			[sut setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
				return NSAccessibilityImageRole;
			}];
		});
		context(@"with children", ^{
			__block NSArray *sublayers = nil;
			
			beforeEach(^{
				sublayers = @[[CALayer layer], [CALayer layer]];
				
				for (CALayer * child in sublayers) {
					[child setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
						return NSAccessibilityImageRole;
					}];
					[sut addSublayer:child];
				}
			});
			afterEach(^{
				sublayers = nil;
			});
			it(@"should return unignored sublayers for NSAccessibilityChildrenAttribute", ^{
				[[[sut accessibilityAttributeValue:NSAccessibilityChildrenAttribute] should] equal:sut.sublayers];
			});
			it(@"should return its unignored parent for NSAccessibilityParentAttribute", ^{
				[[[[sublayers firstObject] accessibilityAttributeValue:NSAccessibilityParentAttribute] should] equal:NSAccessibilityUnignoredAncestor(sut)];
			});
			it(@"should throw an exception if layer is not associated with a view and has no superlayer when asked for its parent", ^{
				[[ theBlock(^{
					[sut accessibilityAttributeValue:NSAccessibilityParentAttribute];
				}) should ] raiseWithName:NSInternalInconsistencyException reason:@"No accessibility parent available" ];
			});
			context(@"removing the children", ^{
				beforeEach(^{
					sut.sublayers = nil;
				});
				it(@"should not have the NSAccessibilityChildrenAttribute", ^{
					[[[sut accessibilityAttributeNames] shouldNot] contain:NSAccessibilityChildrenAttribute];
				});
			});
		});
		context(@"layer in view", ^{
			__block NSWindow *window = nil;
			__block NSView *view = nil;
			
			beforeEach(^{
				window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 400, 400)
													 styleMask:NSTitledWindowMask
													   backing:NSBackingStoreBuffered
														 defer:NO];
				[window setReleasedWhenClosed:NO];
				view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 400)];
				[view setAccessiblityEnabledLayer:sut];
				[window setContentView:view];
			});
			afterEach(^{
				[view removeFromSuperview];
				[window setContentView:nil];
				[window close];
				view = nil;
				window = nil;
			});
			context(@"accessibility parent", ^{
				it(@"should not return for its accessibility parent", ^{
					[[[sut accessibilityAttributeValue:NSAccessibilityParentAttribute] shouldNot] beNil];
				});
			});
			it(@"should return a top level ui attribute value", ^{
				[[[sut accessibilityAttributeValue:NSAccessibilityTopLevelUIElementAttribute] shouldNot] beNil];
			});
			it(@"should return the window for accessibility window attribute", ^{
				id axWindow = [sut accessibilityAttributeValue:NSAccessibilityWindowAttribute];
				[[ axWindow should] equal:window];
			});
			context(NSAccessibilitySizeAttribute, ^{
				__block CGSize expectedSize = CGSizeZero;

				beforeEach(^{
					expectedSize = sut.bounds.size;
				});
				context(@"coordinate space conversions", ^{
					NSRect expectedRectInLayer = NSMakeRect(0, 0, 400, 400);
					NSRect expectedRectInWindow = NSMakeRect(50, 50, 400, 400);
					NSRect expectedRectInScreen = NSMakeRect(200, 200, 400, 400);

					beforeEach(^{
						window = [NSWindow nullMock];
						view = [NSView nullMock];
						[view stub:@selector(layer) andReturn:sut];
						[view stub:@selector(window) andReturn:window];
						[view stub:@selector(convertRectFromLayer:) andReturn:theValue(expectedRectInLayer)];
						[view stub:@selector(convertRect:fromView:) andReturn:theValue(expectedRectInWindow)];
						[sut stub:@selector(mm_containingView) andReturn:view];
						[sut stub:@selector(mm_accessibilityParent) andReturn:view];
						[window stub:@selector(convertRectToScreen:) andReturn:theValue(expectedRectInScreen)];
					});
					it(@"should ask the view to convert the layers rect from layer", ^{
						[[view should] receive:@selector(convertRectFromLayer:) withArguments:theValue(sut.frame)];

						[sut accessibilityAttributeValue:NSAccessibilitySizeAttribute];
					});
					it(@"should convert the layers frame to window coordinates", ^{
						[[view should] receive:@selector(convertRect:fromView:) withArguments:theValue(expectedRectInLayer), [KWNull null]];
						
						[sut accessibilityAttributeValue:NSAccessibilitySizeAttribute];
					});
					it(@"should convert the window rect to screen coordinares", ^{
						[[window should] receive:@selector(convertRectToScreen:) withArguments:theValue(expectedRectInWindow)];
						
						[sut accessibilityAttributeValue:NSAccessibilitySizeAttribute];
					});
				});
				context(@"when layers contentScale is 1", ^{
					beforeEach(^{
						[window stub:@selector(backingScaleFactor) andReturn:theValue(1.)];
						sut.contentsScale = 1.;
					});
					it(@"should return its size for NSAccessibilitySizeAttribute", ^{
						[[[sut accessibilityAttributeValue:NSAccessibilitySizeAttribute] should] equal:[NSValue valueWithSize:expectedSize]];
					});
				});
				context(@"when layers contentScale is 2", ^{
					beforeEach(^{
						[window stub:@selector(backingScaleFactor) andReturn:theValue(2.)];
						sut.contentsScale = 2.;
					});
					it(@"should return its size for NSAccessibilitySizeAttribute", ^{
						[[[sut accessibilityAttributeValue:NSAccessibilitySizeAttribute] should] equal:[NSValue valueWithSize:expectedSize]];
					});
				});
			});
			it(@"should return its position for NSAccessibilityPositionAttribute", ^{
				CGPoint pointInView = [view.layer convertPoint:sut.frame.origin
													 fromLayer:sut.superlayer];
				NSPoint windowPoint = [view convertPoint:NSPointFromCGPoint(pointInView)
												  toView:nil ];
				NSValue *expectedPosition = [NSValue valueWithPoint:[window convertRectToScreen:NSMakeRect(windowPoint.x, windowPoint.y, 1,1)].origin];
				[[[sut accessibilityAttributeValue:NSAccessibilityPositionAttribute] should] equal:expectedPosition];
			});
			it(@"should return a focused ui element", ^{
				[[[sut accessibilityFocusedUIElement] shouldNot] beNil];
			});
			it(@"should return its window for the focusted ui element", ^{
				[[[sut accessibilityFocusedUIElement] should] equal:window];
			});
			context(@"hit testing", ^{
				__block NSPoint screenPoint;
				
				beforeEach(^{
					NSPoint pointInView = NSMakePoint(NSMidX([view bounds]), NSMidY([view bounds]));
					NSPoint windowPoint = [view convertPoint:NSPointFromCGPoint(pointInView)
													  toView:nil ];
					screenPoint = [window convertRectToScreen:NSMakeRect(windowPoint.x, windowPoint.y, 1,1)].origin;
				});
				it(@"should return itself when hit tested", ^{
					[[[sut accessibilityHitTest:screenPoint] should] equal:sut];
				});
				context(@"child layers", ^{
					__block CALayer *child;
					
					beforeEach(^{
						child = [CALayer layer];
						[child setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
							return NSAccessibilityImageRole;
						}];
						child.frame = CGRectInset(sut.bounds, 20, 20);
						[sut addSublayer:child];
					});
					afterEach(^{
						child = nil;
						sut.sublayers = nil;
					});
					it(@"should return the child when hit tested", ^{
						[[[sut accessibilityHitTest:screenPoint] should] equal:child];
					});
				});
			});
		});
	});
	context(@"layer with read-only role attribute", ^{
		beforeEach(^{
			[sut setReadableAccessibilityAttribute:NSAccessibilityRoleAttribute withBlock:^id{
				return NSAccessibilityImageRole;
			}];
		});
		it(@"should also have the NSAccessibilityRoleDescriptionAttribute attribute", ^{
			[[[sut accessibilityAttributeNames] should] contain:NSAccessibilityRoleDescriptionAttribute];
		});
		it(@"should have a non-empty NSAccessibilityRoleDescriptionAttribute value", ^{
			[[[sut accessibilityAttributeValue:NSAccessibilityRoleDescriptionAttribute] shouldNot] beNil];
		});
		it(@"should have a matching role description", ^{
			[[[sut accessibilityAttributeValue:NSAccessibilityRoleDescriptionAttribute] should] equal:NSAccessibilityRoleDescriptionForUIElement(sut)];
		});
		it(@"should return the role returned from getter block", ^{
			[[[sut accessibilityAttributeValue:NSAccessibilityRoleAttribute] should] equal:NSAccessibilityImageRole];
		});
		it(@"should contain the custom attribue in accessibilityActionNames", ^{
			[[[sut accessibilityAttributeNames] should] contain:NSAccessibilityRoleAttribute];
		});
		context(@"remove role attribute", ^{
			beforeEach(^{
				[sut removeAccessibilityAttribute:NSAccessibilityRoleAttribute];
			});
			it(@"should still contain role attribute", ^{
				[[[sut accessibilityAttributeNames] should] contain:NSAccessibilityRoleAttribute];
			});
			it(@"should return unknown role", ^{
				[[[sut accessibilityAttributeValue:NSAccessibilityRoleAttribute] should] equal:NSAccessibilityUnknownRole];
			});
		});
	});
	context(@"writable attributes", ^{
		__block NSNumber *value = nil;
		
		beforeEach(^{
			[sut setWritableAccessibilityAttribute:NSAccessibilityValueAttribute
										 readBlock:^id{
											 return value;
										 }
										writeBlock:^(id aValue){
											value = aValue;
										}];
		});
		afterEach(^{
			value = nil;
			[sut setWritableAccessibilityAttribute:NSAccessibilityValueAttribute
										 readBlock:^id{
											 return value;
										 }
										writeBlock:^(id aValue) {
											value = aValue;
										}];
		});
		it(@"should return YES for provided writable attribute", ^{
			[[theValue([sut accessibilityIsAttributeSettable:NSAccessibilityValueAttribute]) should] beYes];
		});
		it(@"should return NO for unprovided attribute", ^{
			[[theValue([sut accessibilityIsAttributeSettable:NSAccessibilityFilenameAttribute]) should] beNo];
		});
		context(@"setting the attribute", ^{
			beforeEach(^{
				[sut accessibilitySetValue:@YES
							  forAttribute:NSAccessibilityValueAttribute];
			});
			afterEach(^{
				value = nil;
			});

			it(@"should invoke the setter block", ^{
				[[value should] beYes];
			});
			it(@"should read the previously written value", ^{
				[[[sut accessibilityAttributeValue:NSAccessibilityValueAttribute] should] beYes];
			});
		});
		context(@"removing custom handlers", ^{
			beforeEach(^{
				[sut removeAccessibilityAttribute:NSAccessibilityValueAttribute];
			});
			it(@"should not have the removed attribute", ^{
				[[[sut accessibilityAttributeNames] shouldNot] contain:NSAccessibilityValueAttribute];
			});
			it(@"should return NO for accessibilityIsAttributeSettable with the removed attribute", ^{
				[[theValue([sut accessibilityIsAttributeSettable:NSAccessibilityValueAttribute]) should] beNo];
			});
		});
	});
	context(@"accessibility actions", ^{
		__block NSNumber *actionInvoked = nil;

		beforeEach(^{
			[sut setAccessibilityAction:NSAccessibilityPressAction withBlock:^{
				actionInvoked = @YES;
			}];
		});
		afterEach(^{
			actionInvoked = nil;
		});
		it(@"should have one action", ^{
			[[[sut should] have:1] accessibilityActionNames];
		});
		it(@"should have the action", ^{
			[[[sut accessibilityActionNames] should] contain:NSAccessibilityPressAction];
		});
		it(@"should return the action descripton", ^{
			[[[sut accessibilityActionDescription:NSAccessibilityPressAction] should] equal:NSAccessibilityActionDescription(NSAccessibilityPressAction)];
		});
		context(@"performing the action", ^{
			beforeEach(^{
				[sut accessibilityPerformAction:NSAccessibilityPressAction];
			});
			it(@"should have invoked the action", ^{
				[[actionInvoked should] beYes];
			});
		});
	});
});

SPEC_END
