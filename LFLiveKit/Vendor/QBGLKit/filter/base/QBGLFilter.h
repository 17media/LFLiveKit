//
//  QBGLFilter.h
//  Qubi
//
//  Created by Ken Sun on 2016/8/21.
//  Copyright © 2016年 Qubi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <UIKit/UIKit.h>
#import "QBGLUtils.h"

typedef NS_ENUM(NSUInteger, QBGLImageRotation) {
    QBGLImageRotationNone,
    QBGLImageRotationLeft,
    QBGLImageRotationRight,
    QBGLImageRotationFlipVertical,
    QBGLImageRotationFlipHorizonal,
    QBGLImageRotationRightFlipVertical,
    QBGLImageRotationRightFlipHorizontal,
    QBGLImageRotation180
};

@class QBGLProgram;
@class QBGLDrawable;

@interface QBGLFilter : NSObject

@property (strong, nonatomic, readonly) QBGLProgram *program;

@property (nonatomic) QBGLImageRotation inputRotation;
@property (nonatomic) CGSize inputSize;
@property (nonatomic) CGSize outputSize;

@property (nonatomic) CVOpenGLESTextureCacheRef textureCacheRef;
@property (nonatomic) GLuint outputTextureId;

@property (nonatomic, readonly) CVPixelBufferRef outputPixelBuffer;

- (instancetype)initWithVertexShader:(const char *)vertexShader
                      fragmentShader:(const char *)fragmentShader;

/**
 * Subclass should call this method when ready to load.
 */
- (void)loadTextures;

/**
 * Subclass should always call [super deleteTextures].
 */
- (void)deleteTextures;

- (void)loadBGRA:(CVPixelBufferRef)pixelBuffer;

- (void)loadTexture:(GLuint)textureId;

/**
 * Prepare for drawing from texture index and return the next available active texture index.
 */
- (GLuint)renderAtIndex:(GLuint)index;

/**
 * Prepare for drawing from texture 0 and return the next available active texture index.
 */
- (GLuint)render;

- (NSArray<QBGLDrawable*> *)renderTextures;

- (void)draw;

- (void)setRotation:(float)degrees flipHorizontal:(BOOL)flip;

@end
