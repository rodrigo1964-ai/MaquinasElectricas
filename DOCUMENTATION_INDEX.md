# Documentation Index - Complete Guide to All Files

## Quick Navigation

**New User?** Start here: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

**Want to test everything?** Go to: [tools/run_all_simulations.py](tools/run_all_simulations.py)

**Need complete guide?** Read: [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md)

---

## Documentation Hierarchy

### Level 1: Quick Start (5 minutes)

📄 **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)**
- One-page reference card
- Installation in 30 seconds
- Key commands and equations
- Common issues & fixes
- **Read this first!**

### Level 2: Overview (15 minutes)

📄 **[README.md](README.md)**
- Project overview (español + English)
- All 67 converted models listed
- Statistics and features
- Usage examples
- Machine types overview

📄 **[DELIVERABLES_SUMMARY.md](DELIVERABLES_SUMMARY.md)**
- What was delivered
- Compliance with requirements
- Summary statistics
- File organization

### Level 3: Complete Guide (1-2 hours)

📄 **[SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md)** ⭐ MAIN GUIDE
- Complete installation instructions
- Equation reference for ALL machine types:
  - C2: Transformers
  - C3: Electromechanical Conversion
  - C4: Windings & MMF
  - C5: Synchronous Machines (Basic)
  - C6: Induction Machines
  - C7: Synchronous Machines (Advanced)
  - C8: DC Machines
  - C9: Induction Control
  - C10: Induction Advanced
- Parameter setup instructions
- Running & customizing simulations
- **Troubleshooting section** (6+ issues)
- Python vs OpenModelica vs Simulink comparison
- Advanced topics (eigenvalues, parameter ID, etc.)
- Complete file listing (67 files)

### Level 4: Technical Details

📄 **[tools/CONVERSION_SUMMARY.md](tools/CONVERSION_SUMMARY.md)**
- Technical conversion notes
- MDL parser implementation
- Equation derivations
- Validation approach
- File-by-file conversion status

📄 **[tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md)**
- Test suite documentation
- Comparison tool features
- Usage examples
- Expected outputs
- Advanced usage
- Performance metrics

---

## Documentation by Purpose

### For Getting Started

1. **Installation:** [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Section "Installation"
2. **First simulation:** [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Section "Run Simulations"
3. **Understanding project:** [README.md](README.md)

### For Understanding Equations

1. **Quick lookup:** [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Section "Key Equations"
2. **Complete reference:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → Section "Machine Types & Equations"
3. **Technical details:** [tools/CONVERSION_SUMMARY.md](tools/CONVERSION_SUMMARY.md)

### For Testing

1. **Run test suite:** [tools/run_all_simulations.py](tools/run_all_simulations.py)
2. **Test documentation:** [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md)
3. **Expected results:** [DELIVERABLES_SUMMARY.md](DELIVERABLES_SUMMARY.md) → Section "Validation"

### For Comparison

1. **Run comparisons:** [tools/compare_models.py](tools/compare_models.py)
2. **Comparison docs:** [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md) → Section "Model Comparison Tool"
3. **Python vs MATLAB:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → Section "Python vs OpenModelica vs Simulink"

### For Troubleshooting

1. **Common issues:** [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Section "Common Issues & Fixes"
2. **Detailed troubleshooting:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → Section "Troubleshooting"
3. **Test suite issues:** [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md) → Section "Troubleshooting"

### For Advanced Topics

1. **Customization:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → Section "Customizing Simulations"
2. **Advanced topics:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → Section "Advanced Topics"
3. **Parameter sensitivity:** [tools/compare_models.py](tools/compare_models.py) → Option 2

---

## Documentation by Machine Type

### C2 - Transformers

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C2: Transformers"

**Equations:**
```
Primary:   V1 = R1·I1 + L1·dI1/dt + M·dI2/dt
Secondary: V2 = R2·I2 + L2·dI2/dt + M·dI1/dt
```

**Files:** S1.py, S2.py, S3.py, S4.py

### C3 - Electromechanical Energy Conversion

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C3: Electromechanical Energy Conversion"

**Files:** S2.py

### C4 - Windings & MMF

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C4: Windings & MMF"

**Files:** S1A.py, S1B.py, S1C.py, S4.py, SMG.py

### C5 - Synchronous Machines (Basic)

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C5: Synchronous Machines - Basic"

**Files:** S2.py, S3.py

### C6 - Induction Machines

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C6: Induction Machines"

**Equations (dq frame):**
```
vds = rs·ids - ωe·λqs + dλds/dt
vqs = rs·iqs + ωe·λds + dλqs/dt
Te = (3/2)·(P/2)·Lm·(iqs·idr - ids·iqr)
```

**Files:** 12 models (S1, S4EIG, S4STP, S5A, S5B, S6, plus variants)

### C7 - Synchronous Machines (Advanced) ⭐

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C7: Synchronous Machines - Advanced"

**Enhanced Models:**
- **S1_enhanced.py** - Synchronous generator (828 MVA, 7 states)
- **S4_enhanced.py** - PM motor (4 HP, 6 states)

**Equations (dq0 frame):**
```
dψq/dt = vq + rs·iq - ωb·ωm·ψd
dψd/dt = vd + rs·id + ωb·ωm·ψq
Te = ψd·iq - ψq·id
```

**Files:** 12 models (S1, S3, S3EIG, S4, S5, plus variants)

### C8 - DC Machines ⭐

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C8: DC Machines"

**Enhanced Models:**
- **S1_enhanced.py** - Shunt generator (2 HP)
- **S2_enhanced.py** - Motor starting (10 HP)
- **S3A_enhanced.py** - Braking methods (2 HP)
- **S5_enhanced.py** - Series hoist (1.5 kW)

**Equations:**
```
dIa/dt = (Va - Ea - Ra·Ia) / La
dωm/dt = (Te - Tload - D·ωm) / J
Te = Ka·Ia
Ea = Ka·ωm
```

**Files:** 16 models (S1-S5, plus variants)

### C9 - Induction Control

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C9: Induction Machine Control"

**Files:** S1C.py, S1O.py, S2C.py, S2O.py, S3.py

### C10 - Induction Advanced

**Guide:** [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "C10: Induction Machines - Advanced"

**Files:** 10 models (S1-S5, plus EIG variants)

---

## Tool Documentation

### Test Suite

**File:** [tools/run_all_simulations.py](tools/run_all_simulations.py)

**Documentation:** [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md) → "run_all_simulations.py"

**Quick Start:**
```bash
cd /home/rodo/Maquinas/tools
python3 run_all_simulations.py
```

**Features:**
- Tests all 67 S*.py files
- Colored console output
- Summary report + plots
- Error logging

### Comparison Tool

**File:** [tools/compare_models.py](tools/compare_models.py)

**Documentation:** [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md) → "compare_models.py"

**Quick Start:**
```bash
cd /home/rodo/Maquinas/tools
python3 compare_models.py
```

**Options:**
1. DC motor starting methods
2. Parameter sensitivity
3. Solver benchmark
4. Machine types

---

## Documentation by File Type

### Main Documentation

| File | Size | Purpose |
|------|------|---------|
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | 1 page | Quick start |
| [README.md](README.md) | 430 lines | Project overview |
| [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) | 1000+ lines | Complete guide |
| [DELIVERABLES_SUMMARY.md](DELIVERABLES_SUMMARY.md) | 400 lines | What was delivered |
| [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) | This file | Documentation map |

### Tool Documentation

| File | Size | Purpose |
|------|------|---------|
| [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md) | 600 lines | Test suite docs |
| [tools/CONVERSION_SUMMARY.md](tools/CONVERSION_SUMMARY.md) | 500 lines | Technical notes |

### Python Tools

| File | Size | Purpose |
|------|------|---------|
| [tools/run_all_simulations.py](tools/run_all_simulations.py) | 550 lines | Test suite |
| [tools/compare_models.py](tools/compare_models.py) | 600 lines | Comparison tool |

---

## Recommended Reading Order

### For Complete Beginners

1. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** (5 min)
   - Read "Installation" and "Run Simulations"
2. **Run first simulation** (2 min)
   ```bash
   cd /home/rodo/Maquinas/C8
   python3 S2_enhanced.py
   ```
3. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** (10 min)
   - Read rest of file
4. **[README.md](README.md)** (15 min)
   - Understand project scope
5. **[SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md)** (1 hour)
   - Read relevant machine type sections

### For Intermediate Users

1. **[SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md)** (1 hour)
   - Focus on your machine type
   - Read "Customizing Simulations"
2. **Run test suite** (5 min)
   ```bash
   cd /home/rodo/Maquinas/tools
   python3 run_all_simulations.py
   ```
3. **[tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md)** (20 min)
   - Learn comparison tools
4. **Experiment with comparisons** (30 min)
   ```bash
   python3 compare_models.py
   ```

### For Advanced Users

1. **[SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md)** → "Advanced Topics"
2. **[tools/CONVERSION_SUMMARY.md](tools/CONVERSION_SUMMARY.md)**
   - Understand equation derivations
3. **[tools/compare_models.py](tools/compare_models.py)**
   - Review code for custom comparisons
4. **Create custom analysis**

---

## Search Tips

### Find Information Quickly

**Need equations for DC machines?**
→ [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → Search "C8: DC Machines"

**How to change parameters?**
→ [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → Search "Parameter Setup"

**Simulation won't run?**
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → Search "Common Issues"

**Want to compare models?**
→ [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md) → Search "Model Comparison"

**Test suite failed?**
→ [tools/TEST_SUITE_README.md](tools/TEST_SUITE_README.md) → Search "Troubleshooting"

### Using grep to Search

```bash
# Find all mentions of "DC motor" in documentation
cd /home/rodo/Maquinas
grep -r "DC motor" *.md

# Find equation for torque
grep -r "Te =" *.md

# Find troubleshooting sections
grep -r "Troubleshooting" *.md
```

---

## Documentation Updates

All documentation is version controlled and can be updated:

**To update:**
1. Edit the relevant .md file
2. Update "Last Updated" date
3. Update version if major changes

**Last major update:** March 6, 2026

---

## Documentation Standards

All documentation follows these standards:

1. **Markdown format** - Easy to read and version control
2. **Code blocks** - Properly formatted with syntax highlighting
3. **Examples** - Concrete examples for every feature
4. **File paths** - Always absolute paths
5. **Cross-references** - Links between related documents
6. **Table of contents** - For documents >200 lines
7. **Quick start** - Every document has usage example
8. **Troubleshooting** - Common issues documented

---

## Getting Help

### Step-by-Step

1. **Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md)** for quick answers
2. **Search this index** for relevant document
3. **Read [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md)** troubleshooting section
4. **Run test suite** to verify installation
5. **Check inline comments** in simulation files

### Common Questions

**Q: Where do I start?**
A: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

**Q: How do I run a simulation?**
A: [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → "Run Simulations"

**Q: What are the equations?**
A: [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "Machine Types & Equations"

**Q: How do I test everything?**
A: [tools/run_all_simulations.py](tools/run_all_simulations.py)

**Q: How do I compare models?**
A: [tools/compare_models.py](tools/compare_models.py)

**Q: My simulation failed. What now?**
A: [SIMULINK_CONVERSION_GUIDE.md](SIMULINK_CONVERSION_GUIDE.md) → "Troubleshooting"

---

## Summary

**Total Documentation Files:** 7

**Main Files:**
1. QUICK_REFERENCE.md (quick start)
2. README.md (overview)
3. SIMULINK_CONVERSION_GUIDE.md (complete guide)
4. DELIVERABLES_SUMMARY.md (deliverables)
5. DOCUMENTATION_INDEX.md (this file)

**Tool Files:**
1. tools/TEST_SUITE_README.md
2. tools/CONVERSION_SUMMARY.md

**Coverage:**
- Installation instructions ✓
- All machine types ✓
- Parameter setup ✓
- Troubleshooting ✓
- Advanced topics ✓
- Test suite ✓
- Comparison tools ✓

---

**Start Here:** [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

**Version:** 1.0
**Last Updated:** March 6, 2026
