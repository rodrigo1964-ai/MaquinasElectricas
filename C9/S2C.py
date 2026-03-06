"""
V/f Closed Loop Control - Project 2 Variant
Similar to S1C but with different control strategy
Based on s2c.mdl
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C9')
from p20hp import *

# Simulation parameters
t_stop = 2.0
rtol = 1e-3
atol = 1e-3

# Note: S2C is Project 2 variant - can reuse S1C implementation
# For full implementation, see S1C.py
print("S2C.py: V/f closed loop control (Project 2 variant)")
print("This is a simplified template. See S1C.py for full implementation.")
print("Project 2 may have different parameters or controller tuning.")

def model_equations(t, y):
    """
    Sistema de ecuaciones diferenciales
    Bloques encontrados: 163
    """
    # TODO: Implementar ecuaciones basadas en:
    # Clock: Clock
    # Fcn: Fcn1
    # Gain: Gain
    # Mux: Mux
    # Mux: Mux2
    # Scope: Scope
    # Selector: Selector
    # SubSystem: Speed Ref\nin per unit
    # Fcn: Fcn1
    # Lookup: Look-Up Table
    # Outport: out_1
    # SubSystem: Sqvar_we
    # Inport: we
    # Gain: -1
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # SubSystem: Inner\nProduct
    # Inport: in_2
    # Product: Product
    # Sum: Sum
    # Outport: out_1
    # SubSystem: Inner\nProduct1
    # Inport: in_2
    # Product: Product
    # Sum: Sum
    # Outport: out_1
    # Mux: Mux
    # Product: Product
    # Product: Product1
    # Product: Product2
    # SubSystem: Sign
    # Constant: Constant
    # RelationalOperator: Relational\nOperator
    # RelationalOperator: Relational\nOperator1
    # Sum: Sum
    # Outport: out_1
    # SubSystem: Sign1
    # Constant: Constant
    # RelationalOperator: Relational\nOperator
    # RelationalOperator: Relational\nOperator1
    # Sum: Sum
    # Outport: out_1
    # SubSystem: Sign2
    # Constant: Constant
    # RelationalOperator: Relational\nOperator
    # RelationalOperator: Relational\nOperator1
    # Sum: Sum
    # Outport: out_1
    # Lookup: Volts/hertz
    # Integrator: cos
    # Gain: pksine2pksquare
    # Integrator: sin
    # Gain: wb
    # Outport: vag
    # Outport: vbg
    # Outport: vcg
    # Sum: Sum
    # Sum: Sum1
    # Sum: Sum2
    # SubSystem: Tmech
    # Fcn: Fcn1
    # Lookup: Look-Up Table
    # Outport: out_1
    # ToWorkspace: To Workspace
    # SubSystem: abc2qds
    # Inport: vbg
    # Inport: vcg
    # Inport: ias+ibs+ics
    # Gain: 1/Csg
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Integrator: Integrator
    # Mux: Mux
    # Sum: Sum
    # Sum: Sum1
    # Outport: vqs
    # Outport: vds
    # Outport: v0s
    # SubSystem: induction machine\nin stationary qd0
    # Inport: in_vds
    # Inport: in_v0s
    # Inport: in_Tmech
    # SubSystem: Daxis
    # Inport: in_(wr/wb)*psiqr'
    # Fcn: Fcn
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Fcn: Fcn4
    # Fcn: Fcn5
    # Mux: Mux
    # Mux: Mux1
    # Mux: Mux2
    # Mux: Mux3
    # Mux: Mux4
    # Integrator: psidr'_
    # Integrator: psids_
    # Outport: out_psids
    # Outport: out_ids
    # Outport: out_idr'
    # Outport: out_psidr'
    # Product: Product
    # Product: Product1
    # SubSystem: Qaxis
    # Inport: in_(wr/wb)*psidr'
    # Fcn: Fcn
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Fcn: Fcn4
    # Fcn: Fcn5
    # Mux: Mux
    # Mux: Mux1
    # Mux: Mux2
    # Mux: Mux3
    # Mux: Mux4
    # Integrator: psiqr'_
    # Integrator: psiqs_
    # Outport: out_psiqs
    # Outport: out_iqs
    # Outport: out_iqr'
    # Outport: out_psiqr'
    # SubSystem: Rotor
    # Inport: in_iqs
    # Inport: in_psiqs
    # Inport: in_ids
    # Inport: in_Tmech
    # Gain: 1/2H
    # Integrator: 1/s
    # Gain: Damping\ncoefficient
    # Mux: Mux
    # Sum: Taccl
    # Fcn: Tem_
    # Outport: out_Tem
    # Outport: out_wr/wb
    # Terminator: T
    # Terminator: T1
    # SubSystem: Zero_seq
    # Integrator: Integrator
    # Sum: Sum
    # Gain: rs
    # Gain: wb/xls
    # Outport: out_i0s
    # Outport: out_iqs
    # Outport: out_ids
    # Outport: out_i0s
    # Outport: out_Tem
    # Outport: out_wr/wb
    # Outport: out_psiqs
    # Outport: out_psids
    # SubSystem: m1c
    # SubSystem: qds2abc
    # Inport: ids
    # Inport: i0s
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Mux: Mux
    # Outport: ias
    # Outport: ibs
    # Outport: ics
    # Saturate: slip_limit
    # TransferFcn: speed\ncontroller

    dydt = []  # Implementar derivadas
    return dydt

# Condiciones iniciales
y0 = []  # Definir según bloques Integrator

# Resolver
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol)

# Graficar
plt.figure()
plt.plot(sol.t, sol.y.T)
plt.xlabel('Time (s)')
plt.ylabel('States')
plt.title(f'{self.model_name} - Simulation Results')
plt.grid(True)
plt.show()
