//
//  MTKView+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/08/05.
//  Copyright © 2021 takasiki. All rights reserved.
//

#if os(xrOS)

#elseif os(iOS)
import MetalKit

extension MTKView : RenderDestinationProvider {}
#endif
