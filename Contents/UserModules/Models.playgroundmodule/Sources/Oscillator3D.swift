/* 
    Wave Lab - Oscillator 3D
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import SceneKit

/// A container for important data about an oscillator in simulated 3D-space.
public struct Oscillator3D: Hashable, Equatable {
    /// A reference to this oscillator's node in the scene.
    public let node: SCNNode
    /// An array containing bulk computed distance values to each wave's source for later use.
    public var distances = [Float]()
    
    /// Instantiates a new data model for an oscillator in simulated 3D-space.
    /// - Parameter node: A reference to this oscillator's node in the scene.
    public init(node: SCNNode) {
        self.node = node
    }
}
