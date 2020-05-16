/*:
## Welcome to Wave Lab!
I'm Alex 👋, and together we'll dive into one of my _favorite_ scientific topics: **waves**, a physical phenomenon which, among other things, is responsible for
- the transmission of _sound_ 🔊,
- the behavior of _light_ 🔦, as well as for
- the wireless distribution of _information_ 📱 using WiFi and Bluetooth radio bands.

## The Basics
Before we familiarize ourselves with the diffusion of waves, we should first understand their source: **oscillations**.
When an _oscillator_, an air particle, for instance, is moved away from its _point of equilibrium_ and some _force_ pushes it back, it starts to move around that point continuously because of the _momentum_ created by its rebound. If we ignore the slight loss of energy over time due to friction, this movement goes on forever.

## Simulating a Harmonic Oscillator
To gain a sense of how oscillations work, let's define one by instantiating a _model object_:
*/
let myOscillation = Oscillation(
    // This oscillation's amplitude [m].
    // (Its maximum distance to
    //  the point of equilibrium)
    ŷ: 0.02,
    // This oscillation's frequency [Hz].
    // (The number of times it moves
    //  back and forth per second)
    f: 0.5
)
/*:
There are two critical components that determine an oscillation:
1. a **space component** 🚀 (the _amplitude `ŷ`_ [m]) and
2. a **time component** ⏱ (the _frequency `f`_ [Hz], _period `T`_ [m], or _angular velocity `ω`_ [1/s]).

* Experiment: If you're feeling _adventurous_ 🤔…
    - Find out what each time component does by replacing `f` with `T` and `ω`. Make use of Swift Playgrounds' suggestions and watch the diagram axes.
    - The _phase difference `φ₀`_ [RAD] (by default: 0) determines, where the simulation starts. Set it to a different value, e.g. by writing `myOscillation.φ₀ = .pi / 2`, and observe what this changes. (Make sure you change `myOscillation`'s declaration to `var`.)
---

Now, let's fire up a page which allows us to simulate a single oscillator using our model:
*/
// Import all needed frameworks.
import PlaygroundSupport
import SwiftUI
import Combine
import QuartzCore
// Instantiate the page.
let page = SingleOscillatorPage(oscillation: myOscillation)
// Assign it to this Playground page's live view.
PlaygroundPage.current.setLiveView(page)
/*:
Once you're ready, hit "Run My Code" to see the result ✅.
Control playback using the on-screen controls and switch between the live diagrams for _elongation `y`_, _velocity `v`_, and _acceleration `a`_.

Finally, after having familiarized ourselves with oscillations, let's [**dive into waves on the next page**](@next)! (No pun intended 😉.)
*/