
/*
 ---------------------------------------------------------------------------
 Assimp to Scene Kit Library (AssimpKit)
 ---------------------------------------------------------------------------
 Copyright (c) 2016-17, Deepak Surti, Ison Apps, AssimpKit team
 All rights reserved.
 Redistribution and use of this software in source and binary forms,
 with or without modification, are permitted provided that the following
 conditions are met:
 * Redistributions of source code must retain the above
 copyright notice, this list of conditions and the
 following disclaimer.
 * Redistributions in binary form must reproduce the above
 copyright notice, this list of conditions and the
 following disclaimer in the documentation and/or other
 materials provided with the distribution.
 * Neither the name of the AssimpKit team, nor the names of its
 contributors may be used to endorse or promote products
 derived from this software without specific prior
 written permission of the AssimpKit team.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ---------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
#include "assimp/scene.h"       // Output data structure

@class AssimpImageCache;

@interface SCNTextureInfo : NSObject

#pragma mark - Texture metadata

/**
 The texture type: diffuse, specular etc.
 */
@property enum aiTextureType textureType;

#pragma mark - Creating a texture info

/**
 Create a texture metadata object for a material property.

 @param aiMeshIndex The index of the mesh to which this texture is applied.
 @param aiTextureType The texture type: diffuse, specular etc.
 @param aiScene The assimp scene.
 @param path The path to the scene file to load.
 @return A new texture info.
 */
- (id)initWithMeshIndex:(int)aiMeshIndex
            textureType:(enum aiTextureType)aiTextureType
                inScene:(const struct aiScene *)aiScene
                 atPath:(NSString *)path
			 imageCache:(AssimpImageCache *)imageCache;

#pragma mark - Getting texture contents
/**
 The contents of the material property which can be a texture or color.

 @return The contents which is either a texture or a color.
 */
-(id)getMaterialPropertyContents;


#pragma mark - Releasing texture resources

/**
 Releases the core graphics image resources used to load colors and textures.
 */
-(void)releaseContents;

@end
