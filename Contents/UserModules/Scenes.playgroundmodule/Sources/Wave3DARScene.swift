/* 
    Wave Lab - Wave 3D AR-Scene
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

#if canImport(ARKit)

import SceneKit
import ARKit

/// An AR-implementation of `Wave3DScene`
public class Wave3DARScene: Wave3DScene {
    /// A node used for tracking before the scene is placed.
    public lazy var trackingIndicator: SCNNode = {
        let geometry = SCNPlane(width: 0.1, height: 0.1)
        geometry.materials.first?.diffuse.contents = #imageLiteral(resourceName: "tracking-indicator.png")
        let _trackingIndicator = SCNNode()
        _trackingIndicator.geometry = geometry
        _trackingIndicator.eulerAngles.x = -0.5 * .pi
        return _trackingIndicator
    }()
    
    public init(xAmount: Int, zAmount: Int, centerDistance: Float, radius: CGFloat) {
        super.init()
        generateOscillators(xAmount: xAmount, zAmount: zAmount, centerDistance: centerDistance, radius: radius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Stop! You're not supposed to initialize this way, smh...")
    }
    
    public func placeContent(at worldPosition: SCNVector3, viewingFrom cameraTransform: SCNMatrix4, cameraAngle: Float) {
        contentNode.worldPosition = worldPosition
        contentNode.worldPosition.y = cameraTransform.m42 - 0.5
        contentNode.eulerAngles.y = cameraAngle
        rootNode.addChildNode(contentNode)
    }
}

#endif
