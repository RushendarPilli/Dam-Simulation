# Computational Simulation of Hydroelectric Dam Systems

An interactive MATLAB simulation that models the structural safety and power output of a hydroelectric dam, combining analytical fluid mechanics with numerical computational methods: integration, finite differences, derivative-based sensitivity analysis, constrained optimization, and Monte Carlo simulation.

Built as a final project for **ENGT 509 – Applied Computational Methods**.

**The entire project runs from a single file: `Final_project.m`.** No setup, no dependencies beyond base MATLAB — just open it and run.

## Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Live Interface](#live-interface)
- [Mathematical Modeling](#mathematical-modeling)
- [Computational Methods](#computational-methods)
- [Implementation](#implementation)
- [Tech Stack](#tech-stack)
- [Running It](#running-it)
- [Project Structure](#project-structure)
- [Future Work](#future-work)
- [References](#references)

## Overview

Hydroelectric power is one of the most widely used renewable energy sources due to its efficiency, reliability, and low environmental impact compared to fossil fuel systems. A hydroelectric dam converts the potential energy of stored water into electrical energy by controlling water flow through turbines. The performance of the system depends on several physical and operational parameters — water height, flow rate, structural dimensions, and mechanical efficiency — and accurate evaluation of these factors is essential for both safe operation and optimal energy production.

The structure of a dam is primarily governed by hydrostatic pressure, which increases linearly with depth and produces a nonlinear distribution of force across the dam surface. This project builds a computational model that captures the resulting trade-off between two competing goals: generating as much power as possible, while keeping the structure safe under the force of the water pushing against it.

Real analytical methods give closed-form solutions for simplified cases, but real systems involve nonlinear behavior, parameter variability, and uncertainty — which is where computational methods take over. This project combines numerical integration, finite difference approximation, derivative-based sensitivity analysis, constrained optimization, and Monte Carlo simulation into a single interactive MATLAB tool, letting you explore how these engineering trade-offs actually behave.

## Problem Statement

Hydroelectric dam systems operate under varying water levels and flow conditions, which directly influence hydrostatic pressure distribution and structural loading on the dam body. Because hydrostatic force increases nonlinearly with water height, the system is highly sensitive to small parameter changes, and inadequate evaluation of these forces can lead to unsafe operating conditions.

Existing analytical approaches provide simplified, idealized solutions but don't fully capture parameter variability, uncertainty, or the need for optimization in real-world scenarios. This project addresses that gap with a computational framework that models dam safety and power generation using both deterministic and probabilistic methods, supporting efficient and reliable operation — in line with the National Academy of Engineering's Grand Challenge of providing access to clean, sustainable energy.

## Live Interface

The app has sliders for every input and updates all outputs and plots in real time as you drag them:

- Water height (H)
- Dam width (W)
- Flow rate (Q)
- Turbine efficiency (η)
- Dam type (Gravity, Arch, Buttress, Earth-fill)
- Numerical resolution (number of integration points)
- Monte Carlo sample size
<img width="542" height="600" alt="image" src="https://github.com/user-attachments/assets/94e6fc0e-2289-451c-a7a8-62c3e58f28c3" />

**Outputs shown:**
- Bottom pressure, total force, power, safety factor, and unsafe risk %
- A schematic diagram of the dam with water level, pressure arrows, and turbine flow
- Force vs. Height
- Power vs. Flow Rate
- Sensitivity (derivative) plot
- Monte Carlo power distribution histogram
- Finite difference vs. analytical pressure comparison
<img width="997" height="719" alt="image" src="https://github.com/user-attachments/assets/2f5214fc-c124-4076-ac21-b54d1651076d" />

## Mathematical Modeling

The model uses water height, dam width, flow rate, turbine efficiency, and dam type as inputs, along with two physical constants: water density (ρ = 1000 kg/m³) and gravitational acceleration (g = 9.81 m/s²).

**Hydrostatic pressure** increases linearly with depth below the surface:

```
P = ρ g h
```

At the bottom of the dam, depth equals the full water height H, so pressure is maximum there.

**Total hydrostatic force** is found by integrating pressure over the dam's height, since pressure varies from zero at the surface to maximum at the bottom. A thin horizontal strip of the dam face has area dA = W·dh, and the force on that strip is dF = P·dA = ρgh·W·dh. Integrating from the surface to the bottom of the dam:

```
F = ∫[0 to H] ρgh·W dh = ½ ρ g H² W
```

Because force scales with H², small increases in water height cause rapidly increasing structural load — a key insight the simulation makes visible.

**Power output** from the turbines is proportional to flow rate and head height:

```
Power = η ρ g Q H
```

Since η, ρ, g, and H are held constant for a given scenario, power increases linearly with flow rate.

**Safety factor** compares the dam's rated maximum force capacity to the actual force it experiences:

```
Safety Factor = F_max / F
```

The simulation interprets this as: **Safe** if SF ≥ 2, **Warning** if 1 ≤ SF < 2, and **Unsafe** if SF < 1.

## Computational Methods

This is where the project goes beyond a plug-and-chug calculator — each numerical method is implemented alongside its analytical counterpart so results can be cross-validated against theory.

**Numerical integration (Trapezoidal Rule).** The analytical force solution is cross-checked by numerically integrating pressure over depth using MATLAB's `trapz`, discretizing the dam height into segments and summing trapezoidal areas under the pressure curve.

```
F ≈ trapz(h, ρ·g·h·W)
```

**Derivative-based sensitivity analysis.** Taking the derivative of the force equation with respect to height shows how sensitive total force is to changes in water level:

```
dF/dH = ρ g H W
```

This is computed numerically in MATLAB using `gradient`, and quantifies how much riskier the dam becomes per additional meter of water height.

**Finite difference approximation.** Since dP/dh = ρg, pressure at each depth step can be built up incrementally rather than solved analytically:

```
P(i) = P(i-1) + ρ g Δh
```

Because the underlying relationship is linear, this method reproduces the exact analytical pressure profile — which serves as a validation check that the numerical implementation is correct.

**Constrained optimization.** The model searches across a range of candidate water heights to find the one that **maximizes power** while keeping the safety factor at or above a minimum threshold:

```
F_max / (½ ρ g H² W) ≥ 1.5
```

This directly demonstrates the safety/power trade-off at the heart of dam engineering.

**Monte Carlo simulation for uncertainty.** Real-world operating conditions vary — flow rate fluctuates, height isn't perfectly constant, efficiency drifts. The simulation runs thousands of trials with randomly perturbed height, flow rate, and efficiency (drawn from normal distributions around the chosen inputs), recalculating force, safety factor, and power for each trial. Risk is reported as:

```
Risk (%) = (Number of unsafe cases / Total cases) × 100
```

This gives a probabilistic risk percentage rather than a single deterministic answer.

**Dimensionless validation.** A dimensionless parameter is computed and checked against its expected theoretical value:

```
π = F / (ρ g H² W) → should equal 0.5
```

If the simulation's numbers are correct, this ratio should land almost exactly on 0.5 regardless of the specific input values — a quick sanity check that the whole model is internally consistent.

## Implementation

The project is implemented entirely in **MATLAB**, chosen for its strong built-in support for numerical computation, visualization, and GUI development.

**Key MATLAB functions used:**
- `trapz()` — numerical integration via the trapezoidal rule
- `gradient()` — numerical derivatives for sensitivity analysis
- `linspace()` — generating evenly spaced sample points
- `randn()` — generating randomized values for Monte Carlo simulation
- `plot()` and `histogram()` — visualizing results

**User Interface.** The GUI is built using MATLAB's native `uicontrol` and `uipanel` components — sliders for every input parameter, a dropdown for dam type, and a results panel that lists all computed values. Six live plots surround a central schematic of the dam itself, and everything recalculates and redraws automatically the moment any slider moves.


## Tech Stack

- **MATLAB** (GUI built with `uicontrol`, `uipanel`)
- Core functions: `trapz`, `gradient`, `linspace`, `randn`, `plot`, `histogram`

## Running It

1. Clone the repo.
2. Open `Final_project.m` in MATLAB.
3. Run the script — no toolboxes beyond base MATLAB are required.
4. Use the sliders on the left to change inputs; all plots and the results panel update live.

## Project Structure

    ├── Final_project.m              # Main MATLAB app — this single file is all you need to run the project
    ├── Dam_Simulation_Report.pdf    # Full written report with derivations, methodology, and analysis
    ├── .gitattributes
    └── README.md

## Future Work

- Extend from a 2D idealized dam to a full 3D geometry (length, curvature, thickness)
- Model 3D pressure distribution and flow behavior
- Incorporate structural stress and material properties
- Move from simplified force balances to CFD / finite element analysis
- Build out a proper 3D visualization of flow and pressure
- Explore integration with real-world sensor data as a digital twin

## References

- White, F. M. (2016). *Fluid Mechanics* (8th ed.). McGraw-Hill Education.
- Munson, B. R., Gerhart, P. M., Gerhart, A. L., Hochstein, J. I., Young, D. F., & Okiishi, T. H. (2019). *Munson, Young, and Okiishi's Fundamentals of Fluid Mechanics* (8th ed.). Wiley.
- Chapra, S. C., & Canale, R. P. *Numerical Methods for Engineers: With Personal Computer Applications*. McGraw-Hill.
- Fishman, G. (1996). *Monte Carlo: Concepts, Algorithms, and Applications*. Springer.
- National Academy of Engineering. (2008). *Grand Challenges for Engineering*.

---

*This project applies concepts from applied computational methods — numerical integration, finite difference methods, derivative-based sensitivity analysis, constrained optimization, and Monte Carlo simulation — to a real engineering system, connecting coursework math to a physically interpretable, interactive model.*
