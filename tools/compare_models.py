#!/usr/bin/env python3
"""
Model Comparison and Analysis Tool
Provides side-by-side comparison of similar models, parameter sensitivity analysis,
and performance benchmarks for electrical machine simulations
"""

import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
import sys
import time
import subprocess
from scipy.integrate import solve_ivp

# Configuration
BASE_DIR = Path("/home/rodo/Maquinas")
OUTPUT_DIR = BASE_DIR / "comparison_results"
OUTPUT_DIR.mkdir(exist_ok=True)


class ModelComparator:
    """Class for comparing electrical machine models"""

    def __init__(self):
        self.results = {}
        self.models = {}

    def add_model(self, name, equations_func, params, y0, t_span):
        """Add a model for comparison"""
        self.models[name] = {
            'equations': equations_func,
            'params': params,
            'y0': y0,
            't_span': t_span
        }

    def run_comparison(self):
        """Run all models and collect results"""
        print(f"Running comparison of {len(self.models)} models...")

        for name, model in self.models.items():
            print(f"  Running {name}...", end=" ", flush=True)
            start_time = time.time()

            try:
                sol = solve_ivp(
                    model['equations'],
                    model['t_span'],
                    model['y0'],
                    method='RK45',
                    rtol=1e-6,
                    atol=1e-8,
                    max_step=1e-3,
                    dense_output=True
                )

                execution_time = time.time() - start_time

                self.results[name] = {
                    'sol': sol,
                    'time': execution_time,
                    'success': sol.success
                }

                print(f"✓ ({execution_time:.3f}s)")

            except Exception as e:
                print(f"✗ Error: {str(e)[:50]}")
                self.results[name] = {
                    'sol': None,
                    'time': 0,
                    'success': False,
                    'error': str(e)
                }

    def plot_comparison(self, state_names, title="Model Comparison"):
        """Generate side-by-side comparison plots"""

        n_models = len(self.models)
        n_states = len(state_names)

        fig, axes = plt.subplots(n_states, 1, figsize=(14, 3*n_states))
        if n_states == 1:
            axes = [axes]

        fig.suptitle(title, fontsize=16, fontweight='bold')

        # Plot each state variable
        for i, state_name in enumerate(state_names):
            ax = axes[i]

            for name, result in self.results.items():
                if result['success']:
                    sol = result['sol']
                    t_plot = np.linspace(sol.t[0], sol.t[-1], 1000)
                    y_plot = sol.sol(t_plot)

                    ax.plot(t_plot, y_plot[i], label=name, linewidth=2)

            ax.set_ylabel(state_name, fontsize=12, fontweight='bold')
            ax.legend(loc='best')
            ax.grid(True, alpha=0.3)

        axes[-1].set_xlabel('Time (s)', fontsize=12, fontweight='bold')
        plt.tight_layout()

        # Save
        filename = OUTPUT_DIR / f"{title.replace(' ', '_').lower()}.png"
        plt.savefig(filename, dpi=150, bbox_inches='tight')
        print(f"\nComparison plot saved to: {filename}")

        plt.show()


def compare_dc_starting_methods():
    """Compare different DC motor starting methods"""

    print("\n" + "="*80)
    print("DC MOTOR STARTING METHODS COMPARISON")
    print("="*80)

    # Parameters
    Prated = 10 * 746  # 10 HP
    Vrated = 220
    wmrated = 1490 * (2*np.pi) / 60
    Ra = 0.3
    La = 0.012
    J = 2.5
    D = 0.0
    Ka = (Vrated - Ra * (Prated/Vrated)) / wmrated

    print(f"Machine: 10 HP, 220 V, {wmrated*60/(2*np.pi):.0f} RPM")
    print(f"Parameters: Ra={Ra} Ω, La={La} H, Ka={Ka:.4f}, J={J} kg·m²")

    # Method 1: Direct-on-line starting
    def dol_equations(t, y):
        Ia, wm = y
        Va = Vrated
        Ea = Ka * wm
        Te = Ka * Ia
        Tload = 0

        dIa_dt = (Va - Ea - Ra*Ia) / La
        dwm_dt = (Te - Tload - D*wm) / J

        return [dIa_dt, dwm_dt]

    # Method 2: Starting with external resistance (Rext = 2 Ω for first 0.5s)
    def resistor_start_equations(t, y):
        Ia, wm = y
        if t < 0.5:
            Rext = 2.0
            Va = Vrated * Ra / (Ra + Rext)
        else:
            Rext = 0
            Va = Vrated

        Ea = Ka * wm
        Te = Ka * Ia
        Tload = 0

        dIa_dt = (Va - Ea - (Ra + Rext)*Ia) / La
        dwm_dt = (Te - Tload - D*wm) / J

        return [dIa_dt, dwm_dt]

    # Method 3: Reduced voltage starting (60% voltage for first 0.5s)
    def reduced_voltage_equations(t, y):
        Ia, wm = y
        if t < 0.5:
            Va = 0.6 * Vrated
        else:
            Va = Vrated

        Ea = Ka * wm
        Te = Ka * Ia
        Tload = 0

        dIa_dt = (Va - Ea - Ra*Ia) / La
        dwm_dt = (Te - Tload - D*wm) / J

        return [dIa_dt, dwm_dt]

    # Setup comparator
    comp = ModelComparator()
    comp.add_model("Direct-On-Line", dol_equations, None, [0, 0], (0, 2.0))
    comp.add_model("External Resistor", resistor_start_equations, None, [0, 0], (0, 2.0))
    comp.add_model("Reduced Voltage", reduced_voltage_equations, None, [0, 0], (0, 2.0))

    # Run comparison
    comp.run_comparison()

    # Plot results
    state_names = [
        'Armature Current (A)',
        'Speed (rad/s)'
    ]
    comp.plot_comparison(state_names, "DC Motor Starting Methods Comparison")

    # Print statistics
    print("\n" + "-"*80)
    print("STARTING STATISTICS:")
    print("-"*80)
    for name, result in comp.results.items():
        if result['success']:
            sol = result['sol']
            Ia_peak = np.max(np.abs(sol.y[0]))
            wm_final = sol.y[1, -1]
            t_95 = np.argmax(sol.y[1] >= 0.95*wmrated)
            if t_95 > 0:
                time_to_95 = sol.t[t_95]
            else:
                time_to_95 = np.inf

            print(f"\n{name}:")
            print(f"  Peak current: {Ia_peak:.1f} A ({Ia_peak/(Prated/Vrated):.2f}x rated)")
            print(f"  Final speed: {wm_final*60/(2*np.pi):.0f} RPM")
            print(f"  Time to 95% speed: {time_to_95:.3f} s")


def compare_sync_vs_pm_motor():
    """Compare wound-rotor synchronous motor vs PM motor"""

    print("\n" + "="*80)
    print("SYNCHRONOUS MOTOR COMPARISON: Wound Rotor vs PM")
    print("="*80)

    # This would require importing the actual models
    # For now, we'll create simplified versions

    print("Note: This comparison requires full model implementations.")
    print("See C7/S1_enhanced.py and C7/S4_enhanced.py for complete models.")


def parameter_sensitivity_analysis():
    """Perform parameter sensitivity analysis on DC motor"""

    print("\n" + "="*80)
    print("PARAMETER SENSITIVITY ANALYSIS - DC Motor Inertia")
    print("="*80)

    # Base parameters
    Prated = 10 * 746
    Vrated = 220
    wmrated = 1490 * (2*np.pi) / 60
    Ra = 0.3
    La = 0.012
    D = 0.0
    Ka = (Vrated - Ra * (Prated/Vrated)) / wmrated

    # Vary inertia
    J_values = [1.0, 2.5, 5.0, 7.5, 10.0]  # kg·m²

    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    fig.suptitle('Parameter Sensitivity Analysis: Inertia Effect on DC Motor Starting',
                 fontsize=16, fontweight='bold')

    results_summary = []

    for J in J_values:
        def equations(t, y):
            Ia, wm = y
            Va = Vrated
            Ea = Ka * wm
            Te = Ka * Ia
            Tload = 0

            dIa_dt = (Va - Ea - Ra*Ia) / La
            dwm_dt = (Te - Tload - D*wm) / J

            return [dIa_dt, dwm_dt]

        sol = solve_ivp(
            equations,
            (0, 3.0),
            [0, 0],
            method='RK45',
            rtol=1e-6,
            max_step=1e-3,
            dense_output=True
        )

        t_plot = np.linspace(0, 3, 1000)
        y_plot = sol.sol(t_plot)

        # Plot current
        axes[0, 0].plot(t_plot, y_plot[0], label=f'J={J} kg·m²', linewidth=2)

        # Plot speed
        axes[0, 1].plot(t_plot, y_plot[1]*60/(2*np.pi), label=f'J={J} kg·m²', linewidth=2)

        # Plot torque
        Te_plot = Ka * y_plot[0]
        axes[1, 0].plot(t_plot, Te_plot, label=f'J={J} kg·m²', linewidth=2)

        # Plot power
        P_plot = Te_plot * y_plot[1]
        axes[1, 1].plot(t_plot, P_plot/1000, label=f'J={J} kg·m²', linewidth=2)

        # Calculate statistics
        Ia_peak = np.max(np.abs(y_plot[0]))
        t_95_idx = np.argmax(y_plot[1] >= 0.95*wmrated)
        t_95 = t_plot[t_95_idx] if t_95_idx > 0 else np.inf

        results_summary.append({
            'J': J,
            'Ia_peak': Ia_peak,
            't_95': t_95
        })

    # Format plots
    axes[0, 0].set_ylabel('Armature Current (A)', fontweight='bold')
    axes[0, 0].legend()
    axes[0, 0].grid(True, alpha=0.3)

    axes[0, 1].set_ylabel('Speed (RPM)', fontweight='bold')
    axes[0, 1].legend()
    axes[0, 1].grid(True, alpha=0.3)

    axes[1, 0].set_xlabel('Time (s)', fontweight='bold')
    axes[1, 0].set_ylabel('Torque (N·m)', fontweight='bold')
    axes[1, 0].legend()
    axes[1, 0].grid(True, alpha=0.3)

    axes[1, 1].set_xlabel('Time (s)', fontweight='bold')
    axes[1, 1].set_ylabel('Power (kW)', fontweight='bold')
    axes[1, 1].legend()
    axes[1, 1].grid(True, alpha=0.3)

    plt.tight_layout()

    # Save
    filename = OUTPUT_DIR / "sensitivity_analysis_inertia.png"
    plt.savefig(filename, dpi=150, bbox_inches='tight')
    print(f"\nSensitivity analysis saved to: {filename}")

    # Print summary
    print("\n" + "-"*80)
    print("SENSITIVITY ANALYSIS RESULTS:")
    print("-"*80)
    print(f"{'Inertia (kg·m²)':<20} {'Peak Current (A)':<20} {'Time to 95% (s)':<20}")
    print("-"*80)
    for res in results_summary:
        print(f"{res['J']:<20.1f} {res['Ia_peak']:<20.1f} {res['t_95']:<20.3f}")

    plt.show()


def performance_benchmark():
    """Benchmark solver performance for different methods"""

    print("\n" + "="*80)
    print("SOLVER PERFORMANCE BENCHMARK")
    print("="*80)

    # Test case: DC motor starting
    Prated = 10 * 746
    Vrated = 220
    wmrated = 1490 * (2*np.pi) / 60
    Ra = 0.3
    La = 0.012
    J = 2.5
    D = 0.0
    Ka = (Vrated - Ra * (Prated/Vrated)) / wmrated

    def equations(t, y):
        Ia, wm = y
        Va = Vrated
        Ea = Ka * wm
        Te = Ka * Ia

        dIa_dt = (Va - Ea - Ra*Ia) / La
        dwm_dt = (Te - D*wm) / J

        return [dIa_dt, dwm_dt]

    # Test different solvers
    methods = ['RK45', 'RK23', 'DOP853', 'LSODA', 'BDF']
    tolerances = [(1e-3, 1e-6), (1e-6, 1e-8), (1e-9, 1e-11)]

    results = []

    print("\nTesting solver methods and tolerances...")
    print(f"{'Method':<15} {'rtol':<12} {'atol':<12} {'Time (s)':<12} {'Function Evals':<15}")
    print("-"*80)

    for method in methods:
        for rtol, atol in tolerances:
            try:
                start_time = time.time()

                sol = solve_ivp(
                    equations,
                    (0, 2.0),
                    [0, 0],
                    method=method,
                    rtol=rtol,
                    atol=atol,
                    max_step=1e-3
                )

                exec_time = time.time() - start_time
                n_evals = sol.nfev

                results.append({
                    'method': method,
                    'rtol': rtol,
                    'atol': atol,
                    'time': exec_time,
                    'evals': n_evals,
                    'success': sol.success
                })

                print(f"{method:<15} {rtol:<12.1e} {atol:<12.1e} {exec_time:<12.4f} {n_evals:<15}")

            except Exception as e:
                print(f"{method:<15} {rtol:<12.1e} {atol:<12.1e} {'FAILED':<12} {str(e)[:30]}")

    # Plot benchmark results
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))
    fig.suptitle('Solver Performance Benchmark', fontsize=16, fontweight='bold')

    # Group by method
    method_names = []
    method_times = []
    method_evals = []

    for method in methods:
        method_results = [r for r in results if r['method'] == method and r['success']]
        if method_results:
            avg_time = np.mean([r['time'] for r in method_results])
            avg_evals = np.mean([r['evals'] for r in method_results])

            method_names.append(method)
            method_times.append(avg_time)
            method_evals.append(avg_evals)

    # Plot execution time
    ax1.bar(method_names, method_times, color='steelblue', alpha=0.7)
    ax1.set_ylabel('Average Execution Time (s)', fontweight='bold')
    ax1.set_xlabel('Solver Method', fontweight='bold')
    ax1.set_title('Execution Time Comparison')
    ax1.grid(axis='y', alpha=0.3)

    # Add value labels
    for i, (name, time_val) in enumerate(zip(method_names, method_times)):
        ax1.text(i, time_val + 0.001, f'{time_val:.4f}s', ha='center', va='bottom')

    # Plot function evaluations
    ax2.bar(method_names, method_evals, color='coral', alpha=0.7)
    ax2.set_ylabel('Average Function Evaluations', fontweight='bold')
    ax2.set_xlabel('Solver Method', fontweight='bold')
    ax2.set_title('Function Evaluations Comparison')
    ax2.grid(axis='y', alpha=0.3)

    # Add value labels
    for i, (name, evals) in enumerate(zip(method_names, method_evals)):
        ax2.text(i, evals + 10, f'{int(evals)}', ha='center', va='bottom')

    plt.tight_layout()

    filename = OUTPUT_DIR / "performance_benchmark.png"
    plt.savefig(filename, dpi=150, bbox_inches='tight')
    print(f"\nBenchmark results saved to: {filename}")

    plt.show()


def compare_machine_types():
    """Compare different machine types side by side"""

    print("\n" + "="*80)
    print("MACHINE TYPE COMPARISON")
    print("="*80)

    print("\nMachine types in repository:")
    print("-"*80)

    machine_types = {
        "C2": {"name": "Transformers", "complexity": "★☆☆☆☆", "applications": "Power distribution"},
        "C3": {"name": "Electromechanical Conversion", "complexity": "★★☆☆☆", "applications": "Actuators, sensors"},
        "C4": {"name": "Windings & MMF", "complexity": "★★★☆☆", "applications": "Machine design"},
        "C5": {"name": "Synchronous Machines (Basic)", "complexity": "★★★☆☆", "applications": "Generators, large motors"},
        "C6": {"name": "Induction Machines", "complexity": "★★★★☆", "applications": "Industrial drives"},
        "C7": {"name": "Synchronous Machines (Advanced)", "complexity": "★★★★★", "applications": "Power systems"},
        "C8": {"name": "DC Machines", "complexity": "★★★☆☆", "applications": "Variable speed drives"},
        "C9": {"name": "Induction Control", "complexity": "★★★★☆", "applications": "Motor control"},
        "C10": {"name": "Induction Advanced", "complexity": "★★★★★", "applications": "Research, analysis"}
    }

    print(f"{'Chapter':<10} {'Machine Type':<35} {'Complexity':<15} {'Applications':<30}")
    print("-"*80)
    for chapter, info in machine_types.items():
        print(f"{chapter:<10} {info['name']:<35} {info['complexity']:<15} {info['applications']:<30}")

    print("\nFor detailed comparison of specific models, use:")
    print("  compare_dc_starting_methods() - Different starting methods")
    print("  parameter_sensitivity_analysis() - Parameter variations")
    print("  performance_benchmark() - Solver performance")


def main():
    """Main menu for comparison tool"""

    print("\n" + "="*80)
    print("ELECTRICAL MACHINE MODEL COMPARISON TOOL")
    print("="*80)
    print("\nAvailable comparisons:")
    print("  1. DC Motor Starting Methods")
    print("  2. Parameter Sensitivity Analysis")
    print("  3. Solver Performance Benchmark")
    print("  4. Machine Types Overview")
    print("  5. Run All Comparisons")
    print("  0. Exit")

    while True:
        choice = input("\nSelect option (0-5): ").strip()

        if choice == '1':
            compare_dc_starting_methods()
        elif choice == '2':
            parameter_sensitivity_analysis()
        elif choice == '3':
            performance_benchmark()
        elif choice == '4':
            compare_machine_types()
        elif choice == '5':
            compare_dc_starting_methods()
            parameter_sensitivity_analysis()
            performance_benchmark()
            compare_machine_types()
            print("\n✓ All comparisons complete!")
            break
        elif choice == '0':
            print("Exiting...")
            break
        else:
            print("Invalid option. Please select 0-5.")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nInterrupted by user. Exiting...")
        sys.exit(0)
    except Exception as e:
        print(f"\nError: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
