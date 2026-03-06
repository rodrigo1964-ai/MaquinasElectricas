"""
Conversión automática de s3eig.mdl a Python
Generado por mdl_parser.py
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Configuración del solver
t_stop = 99
rtol = 1e-6
atol = 1e-6

def model_equations(t, y):
    """
    Sistema de ecuaciones diferenciales
    Bloques encontrados: 177
    """
    # TODO: Implementar ecuaciones basadas en:
    # Inport: In_Vq4
    # Inport: In_Vd4
    # Inport: In_Ef
    # Inport: In_Tmech
    # SubSystem: Cap
    # Inport: in_ida2b
    # Fcn: Fcn
    # Fcn: Fcn1
    # Mux: Mux
    # Integrator: vd
    # Integrator: vq
    # Outport: out_vqa2b
    # Outport: out_vda2b
    # SubSystem: ShuntCap
    # Inport: in_ida2b
    # Fcn: Fcn
    # Fcn: Fcn1
    # Mux: Mux
    # Integrator: vd
    # Integrator: vq
    # Outport: out_vqa2b
    # Outport: out_vda2b
    # Sum: Sum2
    # Sum: Sum3
    # Sum: Sum4
    # Sum: Sum5
    # Terminator: T
    # Terminator: T1
    # Terminator: T2
    # Terminator: T3
    # Terminator: T4
    # SubSystem: gen
    # Inport: in_vdse
    # Inport: in_Ef
    # Inport: in_Tmech
    # SubSystem: PQgen
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
    # SubSystem: Rotor
    # Inport: psid 
    # Inport: -iqr
    # Inport: -idr
    # Inport: Tmech
    # Gain: 1/2H_mode0
    # Gain: Damping
    # Gain: Gain
    # Gain: Gain1
    # Gain: Gain5
    # Gain: Gain6
    # Demux: Mass\nangle
    # StateSpace: Matrix\nGain
    # StateSpace: Matrix\nGain2
    # StateSpace: Matrix\nGain3
    # Mux: Modal\nangle
    # StateSpace: Modal\nspeed
    # Product: Prod
    # Product: Prod2
    # StateSpace: Qbar
    # Sum: Sum
    # Sum: Sum1
    # Sum: Sum12
    # Sum: Sum14
    # Sum: Sum2
    # Sum: Sum3
    # Sum: Sum4
    # Terminator: T
    # Terminator: T1
    # Sum: Tacc
    # Integrator: delta_mode0
    # Gain: gain4
    # Integrator: modal\nangles
    # Integrator: modal_speed
    # Integrator: slip
    # Constant: we/wb
    # Outport: delta_gen
    # Outport: wr/wb 
    # Outport: Tem
    # Outport: (wr-we)/wb
    # Outport: LPA-LPB\nShaft_torque
    # Outport: Gen-Exc\nShaft_torque
    # Terminator: T
    # Terminator: T1
    # Terminator: T2
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
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Fcn: Fcn4
    # Mux: Mux
    # Mux: Mux1
    # Mux: Mux2
    # Mux: Mux3
    # Mux: Mux4
    # Integrator: psipkq2_
    # Integrator: psipkq_
    # Integrator: psiq_
    # Outport: Out_psiq
    # Outport: Out_-iq
    # Outport: Out_psimq
    # SubSystem: qde2qdr
    # Inport: vde
    # Inport: delta 
    # Mux: Mux
    # Fcn: fcn
    # Fcn: fcn1
    # Outport: vqr
    # Outport: vdr
    # SubSystem: qdr2qde
    # Inport: -idr
    # Inport: delta
    # Mux: Mux
    # Fcn: fcn
    # Fcn: fcn1
    # Outport: -iqe
    # Outport: -ide
    # Outport: out_|Vt|
    # Outport: out_|It|
    # Outport: out_Pgen
    # Outport: out_Qgen
    # Outport: out_delta_gen
    # Outport: out_Tem
    # Outport: out_(wr-we)/wb
    # Outport: out_iqe
    # Outport: out_ide
    # Outport: out_LPA-LPB
    # Outport: out_Gen-Exc
    # SubSystem: seriesRL
    # Inport: in_vda
    # Inport: in_vqb
    # Inport: in_vdb
    # Fcn: Fcn
    # Fcn: Fcn1
    # Mux: Mux
    # Integrator: id
    # Integrator: iq
    # Outport: out_iqa2b
    # Outport: out_ida2b
    # Outport: Out_|Vt|
    # Outport: Out_Pgen
    # Outport: Out_Qgen
    # Outport: Out_slip

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
