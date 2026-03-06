"""
Conversión automática de s3.mdl a Python
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
    Bloques encontrados: 98
    """
    # TODO: Implementar ecuaciones basadas en:
    # Inport: vqe
    # Inport: vde
    # Inport: Ex
    # Inport: Tmech
    # SubSystem: smwes
    # Inport: in_vdse
    # Inport: in_Ex
    # Inport: in_Tmech
    # Fcn: Fcn
    # Fcn: Fcn1
    # Mux: Mux1
    # SubSystem: Rotor
    # Inport: psid 
    # Inport: psiq
    # Inport: -id
    # Inport: Tmech
    # Gain: 1/2H
    # Gain: Damping
    # Product: Prod
    # Product: Prod2
    # Sum: Sum12
    # Sum: Sum14
    # Sum: Tacc
    # Integrator: del
    # Gain: gain4
    # Integrator: slip
    # Constant: we/wb
    # Outport: delta
    # Outport: wr/wb 
    # Outport: Tem
    # Outport: (wr-we)/wb
    # Terminator: T
    # Terminator: T1
    # Terminator: T2
    # Terminator: T3
    # Terminator: T4
    # SubSystem: VIPQ
    # Inport: -iqr
    # Inport: vdr
    # Inport: -idr
    # Fcn: Fcn
    # Fcn: Fcn1
    # Mux: Mux
    # Fcn: P
    # Fcn: Q
    # Outport: Out_|Vt|
    # Outport: Out_|It|
    # Outport: Pgen
    # Outport: Qgen
    # SubSystem: d_cct
    # Inport: In_wrpsiq
    # Inport: In_Ef
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Fcn: Fcn4
    # Fcn: Fcn5
    # Mux: Mux
    # Mux: Mux1
    # Mux: Mux2
    # Mux: Mux3
    # Mux: Mux4
    # Mux: Mux5
    # Integrator: psid_
    # Integrator: psipf_
    # Integrator: psipkd_
    # Outport: Out_psid
    # Outport: Out_-id
    # Outport: Out_psimd
    # Outport: Out_ipf
    # Product: prod1
    # Product: prod2
    # SubSystem: q_cct
    # Inport: In_wrpsid
    # Fcn: Fcn
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Fcn: Fcn4
    # Mux: Mux
    # Mux: Mux2
    # Mux: Mux3
    # Mux: Mux4
    # Integrator: psipkq_
    # Integrator: psiq_
    # Outport: Out_psiq
    # Outport: Out_-iq
    # Outport: Out_psimq
    # Outport: out_Pgen
    # Outport: out_Qgen
    # Outport: out_delta
    # Outport: out_Tem
    # Outport: out_(wr-we)/wb
    # Outport: Pgen
    # Outport: Qgen
    # Outport: delta
    # Outport: Tem
    # Outport: (wr-we)/wb

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
