"""
Conversión automática de s4eig.mdl a Python
Generado por mdl_parser.py
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Configuración del solver
t_stop = 999999
rtol = 1e-3
atol = 1e-6

def model_equations(t, y):
    """
    Sistema de ecuaciones diferenciales
    Bloques encontrados: 64
    """
    # TODO: Implementar ecuaciones basadas en:
    # Inport: vqse
    # Inport: vdse
    # Inport: Tmech
    # SubSystem: Daxis
    # Inport: in_(wr/wb)*psiqr'
    # Inport: in_psiqs
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
    # Inport: (wr-we)*psidr'/wb
    # Inport: in_psids
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
    # Inport: in_iqse
    # Inport: in_psiqse
    # Inport: in_idse
    # Inport: in_Tmech
    # Gain: 1/2H
    # Integrator: 1/s
    # Gain: Damping\ncoefficient
    # Mux: Mux
    # Sum: Taccl
    # Fcn: Tem
    # Outport: out_Tem
    # Outport: out_wr/wb
    # Sum: Sum
    # Terminator: T
    # Terminator: T1
    # Constant: we/wb
    # Outport: out_1
    # Outport: out_2
    # Outport: out_3
    # Outport: out_4

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
