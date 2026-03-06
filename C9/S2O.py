"""
Conversión automática de s2o.mdl a Python
Generado por mdl_parser.py
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Configuración del solver
t_stop = tstop
rtol = 1e-3
atol = 1e-3

def model_equations(t, y):
    """
    Sistema de ecuaciones diferenciales
    Bloques encontrados: 149
    """
    # TODO: Implementar ecuaciones basadas en:
    # Clock: Clock
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
    # Fcn: Fcn
    # Fcn: Fcn1
    # Mux: Mux
    # Mux: Mux1
    # Mux: Mux2
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
    # Inport: iqs
    # Inport: psiqs
    # Inport: ids
    # Inport: Tload
    # Integrator: 1/s
    # Gain: 3P/4wb
    # Sum: Sum
    # Sum: Sum1
    # Product: psidiqs
    # Product: psiqids
    # Gain: wb/2H
    # Outport: Tem_out
    # Outport: wr/wb
    # Scope: Scope
    # Selector: Selector
    # Sum: Sum
    # Terminator: T
    # Terminator: T1
    # Terminator: T2
    # Terminator: T3
    # SubSystem: Tmech
    # Fcn: Fcn1
    # Lookup: Look-Up Table
    # Outport: out_1
    # ToWorkspace: To Workspace
    # SubSystem: Variable \nFreq. source
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
    # Gain: Vb/wb
    # Integrator: cos
    # Integrator: sin
    # Constant: we
    # Outport: vag
    # Outport: vbg
    # Outport: vcg
    # SubSystem: Zero_seq
    # Integrator: Integrator
    # Sum: Sum
    # Gain: rs
    # Gain: wb/xls
    # Outport: i0s
    # SubSystem: abc2qds
    # Inport: vbg
    # Inport: vcg
    # Inport: ias+ibs+ics
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Gain: Gain
    # Integrator: Integrator
    # Mux: Mux
    # Gain: Rsg
    # Sum: Sum
    # Sum: Sum1
    # Sum: Sum2
    # Outport: vqs
    # Outport: vds
    # Outport: v0s
    # Outport: vas
    # Outport: vbs-vcs
    # SubSystem: m1o
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
