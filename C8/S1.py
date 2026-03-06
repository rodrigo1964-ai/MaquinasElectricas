"""
Conversión automática de s1.mdl a Python
Generado por mdl_parser.py
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Configuración del solver
t_stop = 2
rtol = 1e-6
atol = 1e-6

def model_equations(t, y):
    """
    Sistema de ecuaciones diferenciales
    Bloques encontrados: 31
    """
    # TODO: Implementar ecuaciones basadas en:
    # SubSystem: -Tem
    # Inport: in_2
    # Product: Product
    # Sum: Sum
    # Outport: out_1
    # Gain: 1/Laq
    # Gain: 1/Lf
    # Gain: 1/wmo
    # Lookup: Armature Reaction
    # Clock: Clock
    # SubSystem: Ea_
    # Inport: in_2
    # Product: Product
    # Sum: Sum
    # Outport: out_1
    # Gain: Ext_load
    # Gain: Field\nPolarity
    # Gain: Field _cct_resis
    # Gain: IaRa drop
    # Integrator: Ia_
    # Integrator: If
    # SubSystem: m1
    # Lookup: Mag_curve
    # Mux: Mux
    # Scope: Scope
    # Sum: Sum
    # Sum: Sum1
    # Sum: Sum2
    # ToWorkspace: To Workspace
    # Relay: brush drop
    # Constant: wm_

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
