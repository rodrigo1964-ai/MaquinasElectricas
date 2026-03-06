#!/usr/bin/env python3
"""
Comprehensive Test Suite for Converted Simulink Models
Runs all S*.py files across C2-C10 directories
Tests execution, catches errors, generates summary report and comparison plots
"""

import os
import sys
import subprocess
import time
from pathlib import Path
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime

# Configuration
BASE_DIR = Path("/home/rodo/Maquinas")
CHAPTERS = ["C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10"]
TIMEOUT = 60  # seconds per simulation
OUTPUT_DIR = BASE_DIR / "test_results"
OUTPUT_DIR.mkdir(exist_ok=True)

# Colors for terminal output
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    RESET = '\033[0m'
    BOLD = '\033[1m'


class SimulationTest:
    """Class to handle individual simulation testing"""

    def __init__(self, chapter, filename):
        self.chapter = chapter
        self.filename = filename
        self.full_path = BASE_DIR / chapter / filename
        self.success = False
        self.error_msg = None
        self.execution_time = 0
        self.output = ""

    def run(self):
        """Run the simulation file"""
        print(f"  Testing {self.chapter}/{self.filename}...", end=" ", flush=True)

        start_time = time.time()
        try:
            # Run the Python script
            result = subprocess.run(
                [sys.executable, str(self.full_path)],
                cwd=str(self.full_path.parent),
                capture_output=True,
                text=True,
                timeout=TIMEOUT
            )

            self.execution_time = time.time() - start_time
            self.output = result.stdout

            # Check for errors
            if result.returncode == 0:
                # Even with return code 0, check for common error patterns
                error_indicators = ["Error", "Exception", "Traceback", "Failed"]
                has_error = any(indicator in result.stderr for indicator in error_indicators)

                if has_error:
                    self.success = False
                    self.error_msg = result.stderr[:500]  # First 500 chars
                    print(f"{Colors.YELLOW}WARNING{Colors.RESET} ({self.execution_time:.2f}s)")
                else:
                    self.success = True
                    print(f"{Colors.GREEN}PASS{Colors.RESET} ({self.execution_time:.2f}s)")
            else:
                self.success = False
                self.error_msg = result.stderr[:500] if result.stderr else "Unknown error"
                print(f"{Colors.RED}FAIL{Colors.RESET} ({self.execution_time:.2f}s)")

        except subprocess.TimeoutExpired:
            self.execution_time = TIMEOUT
            self.success = False
            self.error_msg = f"Timeout after {TIMEOUT} seconds"
            print(f"{Colors.RED}TIMEOUT{Colors.RESET}")

        except FileNotFoundError:
            self.success = False
            self.error_msg = "File not found or not executable"
            print(f"{Colors.RED}NOT FOUND{Colors.RESET}")

        except Exception as e:
            self.success = False
            self.error_msg = str(e)[:500]
            print(f"{Colors.RED}ERROR{Colors.RESET}: {str(e)[:50]}")


def discover_simulations():
    """Discover all S*.py simulation files across chapters"""
    simulations = []

    print(f"\n{Colors.BOLD}Discovering simulation files...{Colors.RESET}")

    for chapter in CHAPTERS:
        chapter_path = BASE_DIR / chapter
        if not chapter_path.exists():
            print(f"  {chapter}: {Colors.YELLOW}Directory not found{Colors.RESET}")
            continue

        # Find all S*.py files
        sim_files = sorted(chapter_path.glob("S*.py"))

        if sim_files:
            print(f"  {chapter}: Found {len(sim_files)} files")
            for sim_file in sim_files:
                simulations.append(SimulationTest(chapter, sim_file.name))
        else:
            print(f"  {chapter}: {Colors.YELLOW}No simulation files{Colors.RESET}")

    return simulations


def run_all_tests(simulations):
    """Run all simulation tests"""
    print(f"\n{Colors.BOLD}Running {len(simulations)} simulations...{Colors.RESET}\n")

    for i, sim in enumerate(simulations, 1):
        print(f"[{i}/{len(simulations)}]", end=" ")
        sim.run()

    return simulations


def generate_summary_report(simulations):
    """Generate comprehensive summary report"""

    # Calculate statistics
    total = len(simulations)
    passed = sum(1 for s in simulations if s.success)
    failed = total - passed
    total_time = sum(s.execution_time for s in simulations)
    avg_time = total_time / total if total > 0 else 0

    # Group by chapter
    by_chapter = {}
    for sim in simulations:
        if sim.chapter not in by_chapter:
            by_chapter[sim.chapter] = {"passed": 0, "failed": 0, "files": []}

        if sim.success:
            by_chapter[sim.chapter]["passed"] += 1
        else:
            by_chapter[sim.chapter]["failed"] += 1
        by_chapter[sim.chapter]["files"].append(sim)

    # Console report
    print(f"\n{'='*80}")
    print(f"{Colors.BOLD}SIMULATION TEST SUMMARY{Colors.RESET}")
    print(f"{'='*80}")
    print(f"Total simulations: {total}")
    print(f"{Colors.GREEN}Passed: {passed}{Colors.RESET}")
    print(f"{Colors.RED}Failed: {failed}{Colors.RESET}")
    print(f"Success rate: {(passed/total*100):.1f}%")
    print(f"Total execution time: {total_time:.2f}s")
    print(f"Average time per simulation: {avg_time:.2f}s")

    print(f"\n{Colors.BOLD}Results by Chapter:{Colors.RESET}")
    for chapter in CHAPTERS:
        if chapter in by_chapter:
            stats = by_chapter[chapter]
            total_ch = stats["passed"] + stats["failed"]
            success_rate = (stats["passed"] / total_ch * 100) if total_ch > 0 else 0
            status_color = Colors.GREEN if stats["failed"] == 0 else Colors.YELLOW if success_rate >= 50 else Colors.RED
            print(f"  {chapter}: {status_color}{stats['passed']}/{total_ch} passed{Colors.RESET} ({success_rate:.0f}%)")

    # Failed simulations details
    if failed > 0:
        print(f"\n{Colors.BOLD}Failed Simulations:{Colors.RESET}")
        for sim in simulations:
            if not sim.success:
                print(f"\n  {Colors.RED}{sim.chapter}/{sim.filename}{Colors.RESET}")
                if sim.error_msg:
                    # Print first line of error
                    first_line = sim.error_msg.split('\n')[0]
                    print(f"    Error: {first_line[:100]}")

    print(f"\n{'='*80}\n")

    # Generate text report file
    report_file = OUTPUT_DIR / f"test_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
    with open(report_file, 'w') as f:
        f.write("="*80 + "\n")
        f.write("SIMULINK TO PYTHON CONVERSION - TEST REPORT\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write("="*80 + "\n\n")

        f.write(f"Total simulations tested: {total}\n")
        f.write(f"Passed: {passed}\n")
        f.write(f"Failed: {failed}\n")
        f.write(f"Success rate: {(passed/total*100):.1f}%\n")
        f.write(f"Total execution time: {total_time:.2f}s\n")
        f.write(f"Average time per simulation: {avg_time:.2f}s\n\n")

        f.write("-"*80 + "\n")
        f.write("RESULTS BY CHAPTER\n")
        f.write("-"*80 + "\n\n")

        for chapter in CHAPTERS:
            if chapter in by_chapter:
                stats = by_chapter[chapter]
                f.write(f"{chapter}:\n")
                f.write(f"  Total files: {stats['passed'] + stats['failed']}\n")
                f.write(f"  Passed: {stats['passed']}\n")
                f.write(f"  Failed: {stats['failed']}\n")
                f.write(f"  Success rate: {(stats['passed']/(stats['passed']+stats['failed'])*100):.1f}%\n\n")

                # List all files
                for sim in stats["files"]:
                    status = "✓ PASS" if sim.success else "✗ FAIL"
                    f.write(f"    {status:8} {sim.filename:30} ({sim.execution_time:.2f}s)\n")
                    if not sim.success and sim.error_msg:
                        f.write(f"             Error: {sim.error_msg[:200]}\n")
                f.write("\n")

        if failed > 0:
            f.write("-"*80 + "\n")
            f.write("DETAILED ERROR MESSAGES\n")
            f.write("-"*80 + "\n\n")

            for sim in simulations:
                if not sim.success:
                    f.write(f"{sim.chapter}/{sim.filename}:\n")
                    f.write(f"{sim.error_msg}\n")
                    f.write("\n" + "-"*40 + "\n\n")

    print(f"Detailed report saved to: {report_file}")

    return by_chapter, report_file


def generate_comparison_plots(simulations, by_chapter):
    """Generate visualization plots for test results"""

    print(f"\n{Colors.BOLD}Generating comparison plots...{Colors.RESET}")

    # Create figure with multiple subplots
    fig = plt.figure(figsize=(16, 10))
    fig.suptitle('Simulink to Python Conversion - Test Results', fontsize=16, fontweight='bold')

    # 1. Overall Success Rate (Pie Chart)
    ax1 = plt.subplot(2, 3, 1)
    passed = sum(1 for s in simulations if s.success)
    failed = len(simulations) - passed
    colors_pie = ['#2ecc71', '#e74c3c']
    ax1.pie([passed, failed], labels=[f'Passed\n({passed})', f'Failed\n({failed})'],
            autopct='%1.1f%%', colors=colors_pie, startangle=90)
    ax1.set_title('Overall Success Rate', fontweight='bold')

    # 2. Results by Chapter (Bar Chart)
    ax2 = plt.subplot(2, 3, 2)
    chapters = sorted(by_chapter.keys())
    passed_counts = [by_chapter[ch]["passed"] for ch in chapters]
    failed_counts = [by_chapter[ch]["failed"] for ch in chapters]
    x = np.arange(len(chapters))
    width = 0.35
    ax2.bar(x - width/2, passed_counts, width, label='Passed', color='#2ecc71')
    ax2.bar(x + width/2, failed_counts, width, label='Failed', color='#e74c3c')
    ax2.set_xlabel('Chapter')
    ax2.set_ylabel('Number of Simulations')
    ax2.set_title('Results by Chapter', fontweight='bold')
    ax2.set_xticks(x)
    ax2.set_xticklabels(chapters)
    ax2.legend()
    ax2.grid(axis='y', alpha=0.3)

    # 3. Execution Time Distribution
    ax3 = plt.subplot(2, 3, 3)
    exec_times = [s.execution_time for s in simulations if s.success]
    if exec_times:
        ax3.hist(exec_times, bins=20, color='#3498db', edgecolor='black', alpha=0.7)
        ax3.axvline(np.mean(exec_times), color='red', linestyle='--',
                    label=f'Mean: {np.mean(exec_times):.2f}s')
        ax3.set_xlabel('Execution Time (seconds)')
        ax3.set_ylabel('Number of Simulations')
        ax3.set_title('Execution Time Distribution', fontweight='bold')
        ax3.legend()
        ax3.grid(axis='y', alpha=0.3)

    # 4. Success Rate by Chapter (%)
    ax4 = plt.subplot(2, 3, 4)
    success_rates = []
    for ch in chapters:
        total_ch = by_chapter[ch]["passed"] + by_chapter[ch]["failed"]
        rate = (by_chapter[ch]["passed"] / total_ch * 100) if total_ch > 0 else 0
        success_rates.append(rate)

    bars = ax4.bar(chapters, success_rates, color=['#2ecc71' if r == 100 else '#f39c12' if r >= 50 else '#e74c3c' for r in success_rates])
    ax4.axhline(y=100, color='green', linestyle='--', alpha=0.5, label='100%')
    ax4.set_xlabel('Chapter')
    ax4.set_ylabel('Success Rate (%)')
    ax4.set_title('Success Rate by Chapter', fontweight='bold')
    ax4.set_ylim([0, 105])
    ax4.grid(axis='y', alpha=0.3)

    # Add value labels on bars
    for bar, rate in zip(bars, success_rates):
        height = bar.get_height()
        ax4.text(bar.get_x() + bar.get_width()/2., height + 1,
                f'{rate:.0f}%', ha='center', va='bottom', fontsize=9)

    # 5. Files per Chapter
    ax5 = plt.subplot(2, 3, 5)
    file_counts = [by_chapter[ch]["passed"] + by_chapter[ch]["failed"] for ch in chapters]
    ax5.bar(chapters, file_counts, color='#9b59b6', alpha=0.7)
    ax5.set_xlabel('Chapter')
    ax5.set_ylabel('Number of Files')
    ax5.set_title('Simulation Files per Chapter', fontweight='bold')
    ax5.grid(axis='y', alpha=0.3)

    # Add value labels
    for i, (ch, count) in enumerate(zip(chapters, file_counts)):
        ax5.text(i, count + 0.2, str(count), ha='center', va='bottom', fontsize=10)

    # 6. Top 10 Slowest Simulations
    ax6 = plt.subplot(2, 3, 6)
    successful_sims = [s for s in simulations if s.success]
    if successful_sims:
        slowest = sorted(successful_sims, key=lambda s: s.execution_time, reverse=True)[:10]
        labels = [f"{s.chapter}/{s.filename[:15]}" for s in slowest]
        times = [s.execution_time for s in slowest]

        y_pos = np.arange(len(labels))
        ax6.barh(y_pos, times, color='#e67e22', alpha=0.7)
        ax6.set_yticks(y_pos)
        ax6.set_yticklabels(labels, fontsize=8)
        ax6.invert_yaxis()
        ax6.set_xlabel('Execution Time (seconds)')
        ax6.set_title('Top 10 Slowest Simulations', fontweight='bold')
        ax6.grid(axis='x', alpha=0.3)

        # Add value labels
        for i, (time, label) in enumerate(zip(times, labels)):
            ax6.text(time + 0.1, i, f'{time:.2f}s', va='center', fontsize=8)

    plt.tight_layout()

    # Save plot
    plot_file = OUTPUT_DIR / f"test_results_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
    plt.savefig(plot_file, dpi=150, bbox_inches='tight')
    print(f"Comparison plots saved to: {plot_file}")

    # Show plot
    plt.show()

    return plot_file


def generate_machine_type_summary():
    """Generate summary of machine types across all chapters"""

    machine_types = {
        "C2": "Transformers - Basic Analysis",
        "C3": "Electromechanical Energy Conversion",
        "C4": "Windings and MMF",
        "C5": "Synchronous Machines - Basic",
        "C6": "Induction Machines",
        "C7": "Synchronous Machines - Advanced",
        "C8": "DC Machines",
        "C9": "Induction Machine Control",
        "C10": "Induction Machines - Advanced"
    }

    print(f"\n{Colors.BOLD}Machine Types Summary:{Colors.RESET}")
    for chapter, description in machine_types.items():
        print(f"  {Colors.CYAN}{chapter}{Colors.RESET}: {description}")


def main():
    """Main execution function"""

    print(f"\n{Colors.BOLD}{Colors.MAGENTA}{'='*80}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.MAGENTA}SIMULINK TO PYTHON CONVERSION - COMPREHENSIVE TEST SUITE{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.MAGENTA}{'='*80}{Colors.RESET}")
    print(f"Base directory: {BASE_DIR}")
    print(f"Output directory: {OUTPUT_DIR}")
    print(f"Chapters to test: {', '.join(CHAPTERS)}")

    # Generate machine type summary
    generate_machine_type_summary()

    # Discover all simulations
    simulations = discover_simulations()

    if not simulations:
        print(f"\n{Colors.RED}No simulation files found!{Colors.RESET}")
        return 1

    print(f"\n{Colors.BOLD}Total simulations discovered: {len(simulations)}{Colors.RESET}")

    # Run all tests
    start_time = time.time()
    simulations = run_all_tests(simulations)
    total_test_time = time.time() - start_time

    # Generate reports
    by_chapter, report_file = generate_summary_report(simulations)

    # Generate plots
    try:
        plot_file = generate_comparison_plots(simulations, by_chapter)
    except Exception as e:
        print(f"{Colors.YELLOW}Warning: Could not generate plots: {e}{Colors.RESET}")
        plot_file = None

    # Final summary
    print(f"\n{Colors.BOLD}Test Suite Complete!{Colors.RESET}")
    print(f"Total test time: {total_test_time:.2f}s")
    print(f"Results saved to: {OUTPUT_DIR}")

    # Return exit code based on results
    failed_count = sum(1 for s in simulations if not s.success)
    return 0 if failed_count == 0 else 1


if __name__ == "__main__":
    try:
        exit_code = main()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        print(f"\n\n{Colors.YELLOW}Test suite interrupted by user{Colors.RESET}")
        sys.exit(130)
    except Exception as e:
        print(f"\n{Colors.RED}Unexpected error: {e}{Colors.RESET}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
