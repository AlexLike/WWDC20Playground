/*:
## Conquering another dimension
Until now, we have only worked with a single oscillator in _one spatial dimension_. What, though, happens if this oscillator is part of some bigger system 🤔?

Let's examine this question by studying 🔬 a real-world example: When we pluck a guitar 🎸, its strings vibrate, causing nearby air particles to start moving. Their oscillation propagates _spacially outwards_, as a chain reaction ripples through the particles.

![an illustration showing how the spreading of waves takes time and space](wave-illustration.png)

The **propagation velocity**, a metric for measuring how quickly this happens, differs across mediums: Light carried by _electromagnetic waves_, for instance, spreads faster than _mechanically sustained_ sound, which is why we perceive lightning ⚡️ before thunder 💥.

Physicists call the phenomenon of oscillations propagating through space, **waves**.

## Simulating a Wave in 3D-space
To illustrate how waves work, let's define one by again instantiating a _model object_:
*/
let myWave = Wave(
    // This wave's source oscillation model.
    oscillation: Oscillation(
        ŷ: 0.3,
        f: 0.6
    ),
    // This wave's propagation velocity [m/s].
    // (The distance traveled within one second)
    c: 0.9
)
/*:
There are three critical components that determine a wave:
1. its **source oscillation's space component** 🚀 (the _amplitude `ŷ`_ [m]),
2. its **source oscillation's time component** ⏱ (the _frequency `f`_ [Hz], _period `T`_ [m], or _angular velocity `ω`_ [1/s]), and
3. the _propagation velocity `c`_ [m/s] or another **space component** 📏 (the _wavelength `λ`_ [m]).

* Experiment: If you're feeling _adventurous_ 🤔…
    - Find out how `c`, `λ`, and `f` intertwine. (Pro tip: Browse through this playground's code and locate the `Wave` _model definition_.)
---

Again, let's fire up a page which allows us to simulate a wave using our model:
*/
// Import all needed frameworks.
import PlaygroundSupport
import SwiftUI
import SceneKit
import Accelerate
#if canImport(ARKit)
import ARKit // On macOS, AR is unavailable.
#endif
// Instantiate the page.
let page = Wave3DPage(
    wave: myWave,
    // The amount of oscillators on the x-axis.
    xAmount: 30,
    // The amount of oscillators on the z-axis.
    zAmount: 30,
    // The distance between two neighboring oscillators' centers [m].
    centerDistance: 0.06,
    // The radius of each oscillator [m].
    radius: 0.02
)
// Assign it to this Playground page's live view.
PlaygroundPage.current.setLiveView(page)
/*:
Once you're ready, hit "Run My Code" to see the result ✅.
Use gestures to navigate the 3D-view and tap an oscillator to _force our defined oscillation_ onto it.
If you're using iPad, tap the "Explore in AR" button to put this model in your living room 😱. Moving around will be significantly more comfortable and immersive.

* Experiment: Tap two oscillators of neighboring corners and observe how a **standing wave** forms inbetween: Some oscillators continuously move at maximum amplitude, while some don't move at all.

That's it 😄! If everything went as planned, when you hear the term "wave" next time, you will no longer think of these: 🌊.

Thank you so much for joining me on this quick educative journey!
Hope to see you soon online at WWDC20!
*/