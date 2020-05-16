/* 
    Wave Lab - Wave 3D
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Foundation

/// A container for important data about a wave in simulated 3D-space.
public struct Wave3D {
    /// This wave's source oscillator.
    public let source: Oscillator3D
    /// This wave's abstract model.
    public let model: Wave
    /// The __point in time__ this wave first starts spreading [s].
    public let t₀: TimeInterval
    
    /// Instantiates a new data model for a wave in simulated 3D-space.
    /// - Parameter source: This wave's source oscillator.
    /// - Parameter model: This wave's abstract model.
    /// - Parameter t₀: The __point in time__ this wave first starts spreading [s].
    public init(source: Oscillator3D, model: Wave, t₀: TimeInterval) {
        self.source = source
        self.model = model
        self.t₀ = t₀
    }
}
