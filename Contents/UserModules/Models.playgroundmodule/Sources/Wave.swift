/* 
    Wave Lab - Wave
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Foundation

/// A model describing a transverse wave.
public struct Wave {
    /// This wave's __oscillation object__.
    public let oscillation: Oscillation
    /// This wave's __wavelength__ [m].
    public let λ: Float
    /// This wave's __propagation velocity__ [m/s].
    public var c: Float { λ * Float(oscillation.f) }
    
    /// Instantiates a new Wave model from an oscillation and a wavelength.
    /// - Parameter oscillation: This wave's __oscillation object__.
    /// - Parameter λ: This wave's __wavelength__ [m].
    public init(oscillation: Oscillation, λ: Float) {
        self.oscillation = oscillation
        self.λ = λ
    }
    
    /// Instantiates a new Wave model from an oscillation and a propagation velocity.
    /// - Parameter oscillation: This wave's __oscillation object__.
    /// - Parameter c: This wave's __propagation velocity__ [m/s].
    public init(oscillation: Oscillation, c: Float) {
        self.init(oscillation: oscillation, λ: c / Float(oscillation.f))
    }
}
