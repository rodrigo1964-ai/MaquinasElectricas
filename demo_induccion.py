"""
Demo rápida: Arranque de motor de inducción 20 HP
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Parámetros del motor 20 HP (de p20hp.py)
rs = 0.1062    # Resistencia estator (Ω)
rr = 0.0764    # Resistencia rotor (Ω)
xls = 0.2145   # Reactancia fuga estator (Ω)
xlr = 0.2145   # Reactancia fuga rotor (Ω)
xm = 5.8339    # Reactancia magnetización (Ω)
J = 2.8        # Inercia (kg·m²)
p = 2          # Pares de polos
wb = 2*np.pi*60  # Frecuencia base (rad/s)

# Inductancias
Ls = xls/wb + xm/wb
Lr = xlr/wb + xm/wb
Lm = xm/wb

def motor_induccion(t, y):
    """Ecuaciones del motor en marco estacionario"""
    psi_qs, psi_ds, psi_qr, psi_dr, wr = y

    # Voltajes aplicados (arranque directo con 460V L-L)
    Vph = 460/np.sqrt(3)  # Voltaje de fase
    vqs = Vph * np.sqrt(2) * np.sin(wb*t)
    vds = Vph * np.sqrt(2) * np.cos(wb*t)

    # Corrientes
    det = Ls*Lr - Lm**2
    iqs = (Lr*psi_qs - Lm*psi_qr) / det
    ids = (Lr*psi_ds - Lm*psi_dr) / det
    iqr = (Ls*psi_qr - Lm*psi_qs) / det
    idr = (Ls*psi_dr - Lm*psi_ds) / det

    # Derivadas flujos
    dpsi_qs = vqs - rs*iqs
    dpsi_ds = vds - rs*ids
    dpsi_qr = -rr*iqr - wr*psi_dr
    dpsi_dr = -rr*idr + wr*psi_qr

    # Torque electromagnético
    Te = (3/2) * (p/2) * (psi_ds*iqs - psi_qs*ids)

    # Carga (arranque sin carga → 50% carga después)
    Tload = 30 if t > 0.5 else 0

    # Velocidad
    dwr = (Te - Tload) / J

    return [dpsi_qs, dpsi_ds, dpsi_qr, dpsi_dr, dwr]

# Condiciones iniciales (motor en reposo)
y0 = [0, 0, 0, 0, 0]

# Simular 2 segundos
print("Simulando arranque motor inducción 20 HP...")
sol = solve_ivp(motor_induccion, [0, 2.0], y0,
                method='RK45', max_step=0.001, rtol=1e-5)

# Extraer resultados
t = sol.t
psi_qs, psi_ds, psi_qr, psi_dr, wr = sol.y

# Calcular variables de interés
det = Ls*Lr - Lm**2
iqs = (Lr*psi_qs - Lm*psi_qr) / det
ids = (Lr*psi_ds - Lm*psi_dr) / det
iqr = (Ls*psi_qr - Lm*psi_qs) / det

# Corriente de estator (magnitud)
Is = np.sqrt(iqs**2 + ids**2)

# Velocidad en RPM
n_rpm = wr * 60 / (2*np.pi)

# Torque
Te = (3/2) * (p/2) * (psi_ds*iqs - psi_qs*ids)

# Velocidad síncrona
ns = 60 * 60 / p  # 1800 RPM para 60 Hz, 2 polos

# Resultados
print(f"\n{'='*60}")
print(f"RESULTADOS DEL ARRANQUE")
print(f"{'='*60}")
print(f"Corriente de arranque pico: {Is.max():.1f} A")
print(f"Torque de arranque pico: {Te.max():.1f} N·m")
print(f"Velocidad final: {n_rpm[-1]:.0f} RPM (síncrona: {ns:.0f} RPM)")
print(f"Deslizamiento final: {100*(ns-n_rpm[-1])/ns:.2f}%")
print(f"Corriente final: {Is[-1]:.1f} A")
print(f"Torque final: {Te[-1]:.1f} N·m")

# Gráficas
fig, axes = plt.subplots(3, 1, figsize=(10, 8))

axes[0].plot(t, Is)
axes[0].set_ylabel('Corriente (A)')
axes[0].set_title('Arranque Motor de Inducción 20 HP')
axes[0].grid(True)

axes[1].plot(t, Te)
axes[1].set_ylabel('Torque (N·m)')
axes[1].grid(True)
axes[1].axhline(y=30, color='r', linestyle='--', label='Carga aplicada')
axes[1].legend()

axes[2].plot(t, n_rpm)
axes[2].axhline(y=ns, color='r', linestyle='--', label='Velocidad síncrona')
axes[2].set_ylabel('Velocidad (RPM)')
axes[2].set_xlabel('Tiempo (s)')
axes[2].grid(True)
axes[2].legend()

plt.tight_layout()
plt.savefig('arranque_induccion.png', dpi=150)
print(f"\nGráfica guardada: arranque_induccion.png")
plt.show()

print(f"\n¡Simulación completada!")
