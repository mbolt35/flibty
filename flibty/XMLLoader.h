////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2010 Matt Bolt
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "XML.h"
#import "XMLLoaderDelegate.h"

@class XML;

@interface XMLLoader : NSObject <NSXMLParserDelegate> {
	NSXMLParser* xmlParser;
	NSMutableArray* elementStack;
	
	__weak id<XMLLoaderDelegate> delegate;
	
	XML* currentElement;
	
	BOOL isLoading;
	BOOL isLoaded;
}

//----------------------------------
//  methods
//----------------------------------

-(id)initWithURLString:(NSString*)url;
-(id)initWithXmlString:(NSString*)xmlString;

-(void)load;

//----------------------------------
//  properties
//----------------------------------

@property(nonatomic, weak) id<XMLLoaderDelegate> delegate;
@property(readonly, nonatomic) BOOL isLoading;
@property(readonly, nonatomic) BOOL	isLoaded;
@property(readonly, nonatomic,getter=xml) XML* currentElement;

@end

@interface XMLLoader (private) 
- (BOOL)isAllWhiteSpace:(NSString*)string;
- (void)notifyDelegateOfError:(NSError*)error;
@end
