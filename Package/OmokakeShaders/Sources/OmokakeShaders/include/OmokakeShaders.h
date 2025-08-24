//
//  OmokakeShaders.h
//  OmokakeShaders
//
//  Created by takedatakashiki on 2025/08/24.
//

#ifndef OmokakeShaders_h
#define OmokakeShaders_h

#import <Foundation/Foundation.h>

#import "ShaderTypes.h"

@interface OmokakeShaders : NSObject

@property (nonatomic, readonly) NSBundle* bundle;

- (NSBundle *)findResourceBundle;

@end

#endif /* OmokakeShaders_h */
