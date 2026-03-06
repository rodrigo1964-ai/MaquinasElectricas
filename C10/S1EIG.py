"""
Conversión automática de s1eig.mdl a Python
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
    Bloques encontrados: 85
    """
    # TODO: Implementar ecuaciones basadas en:
    # Inport: in_Ef'
    # Inport: in_vqie
    # Inport: in_vdie
    # Inport: in_Tmech
    # SubSystem: m1
    # SubSystem: tmodel
    # Inport: in_vqie
    # Inport: in_vdie
    # Inport: in_Tmech
    # Gain: 1/Tpdo
    # Gain: 1/Tpqo
    # Integrator: Edp
    # Integrator: Eqp
    # Gain: Gain2
    # Gain: Gain3
    # SubSystem: Rotor
    # Inport: Edp
    # Inport: iq
    # Inport: id
    # Inport: T_mech
    # Gain: Damp
    # Fcn: Fcn
    # Mux: Mux
    # Terminator: T
    # Sum: Tacc
    # Integrator: delta
    # Gain: gain2
    # Constant: gain3
    # Gain: gain4
    # Integrator: slip
    # Sum: wr/wb
    # Outport: out_delta
    # Outport: out_puslip
    # Outport: Tem
    # SubSystem: VIPQ
    # Inport: iq
    # Inport: vdt
    # Inport: id
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Mux: Mux
    # Outport: out_|Vt|
    # Outport: out_|I|
    # Outport: out_P
    # Outport: out_Q
    # SubSystem: qde2qdr
    # Inport: vde
    # Inport: delta 
    # Mux: Mux
    # Fcn: fcn
    # Fcn: fcn1
    # Outport: vqr
    # Outport: vdr
    # SubSystem: stator_wdg
    # Inport: Edp
    # Inport: vqir
    # Inport: vdir
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Mux: Mux
    # Mux: Mux1
    # Outport: out_vqt
    # Outport: out_vdt
    # Outport: out_iq
    # Outport: out_id
    # Sum: sum
    # Sum: sum1
    # Outport: out_|Vt|
    # Outport: out_|I|
    # Outport: out_Pgen
    # Outport: out_Qgen
    # Outport: out_delta
    # Outport: out_puslip
    # Outport: out_Tem
    # Outport: out_|Vt|
    # Outport: out_|igen|
    # Outport: out_Pgen
    # Outport: out_Qgen
    # Outport: out_delta
    # Outport: out_puslip
    # Outport: out_Tem

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
