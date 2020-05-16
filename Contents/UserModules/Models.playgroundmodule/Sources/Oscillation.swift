/* 
    Wave Lab - Oscillation
    Copyright © 2020 Alexander Zank. All rights reserved.
    Available under the MIT license.
*/

import Foundation
import CoreGraphics

/// A model describing a harmonic osciallating motion.
public struct Oscillation {
    /// This oscillation's __amplitude__ [m].
    public var ŷ: CGFloat
    /// This oscillation's __frequency__ [Hz].
    public var f: TimeInterval
    /// This oscillation's __period__ [s].
    public var T: TimeInterval { 1/f }
    /// This oscillation's __angular speed__ [1/s].
    public var ω: TimeInterval { 2 * Double.pi * f }
    /// The __initial phase difference__ [RAD] of this oscillator compared to the standard sine-based oscillation. (0 ≤ φ₀ ≤ 2π).
    public var φ₀: Double = 0
    /// This oscillation's __maximum velocity__ [m/s].
    public var v̂: CGFloat { ŷ * CGFloat(ω) }
    /// This oscillation's __maximum acceleration__ [m/s²].
    public var â: CGFloat { ŷ * pow(CGFloat(ω), 2) }
    
    /// Instantiates a new Oscillation model from an amplitude and frequency.
    /// - Parameter ŷ: This oscillation's __amplitude__ [m].
    /// - Parameter f: This oscillation's __frequency__ [Hz].
    public init(ŷ: CGFloat, f: TimeInterval) {
        self.ŷ = ŷ
        self.f = f
    }
    
    /// Instantiates a new Oscillation model from an amplitude and period.
    /// - Parameter ŷ: This oscillation's __amplitude__ [m].
    /// - Parameter T: This oscillation's __period__ [s].
    public init(ŷ: CGFloat, T: TimeInterval) {
        self.init(ŷ: ŷ, f: 1 / T)
    }
    
    /// Instantiates a new Oscillation model from an amplitude and angular speed.
    /// - Parameter ŷ: This oscillation's __amplitude__ [m].
    /// - Parameter ω: This oscillation's __angular speed__ [1/s].
    public init(ŷ: CGFloat, ω: TimeInterval) {
        self.init(ŷ: ŷ, f: ω / (2 * Double.pi))
    }
    
    /// This oscillator's primary equation of motion.
    /// - Parameter t: A __point in time__. The amount of seconds after the oscillator starts to elongate.
    /// - Returns: The oscillator's __current elongation__ for the given point in time.
    public func y(_ t: Double) -> CGFloat {
        ŷ * CGFloat(sin(ω * t + φ₀))
    }
    
    /// This oscillator's secondary equation of motion.
    /// - Parameter t: A __point in time__. The amount of seconds after the oscillator starts to elongate.
    /// - Returns: The oscillator's __current velocity__ for the given point in time.
    public func v(_ t: Double) -> CGFloat {
        ŷ * CGFloat(ω * cos(ω * t + φ₀))
    }
    
    /// This oscillator's tertiary equation of motion.
    /// - Parameter t: A __point in time__. The amount of seconds after the oscillator starts to elongate.
    /// - Returns: The oscillator's __current acceleration__ for the given point in time.
    public func a(_ t: Double) -> CGFloat {
        -ŷ * CGFloat(pow(ω, 2)*sin(ω * t + φ₀))
    }
}
