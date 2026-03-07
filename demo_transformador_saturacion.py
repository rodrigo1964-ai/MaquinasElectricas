"""
Demo: Transformador monofásico con saturación magnética
Muestra el efecto de la saturación en la corriente de magnetización
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

# Parámetros del transformador (de m1.py)
Vrated = 120  # V
Srated = 1500  # VA
Frated = 60  # Hz
wb = 2*np.pi*Frated
Vpk = Vrated*np.sqrt(2)

r1 = 0.25    # Resistencia primario (Ω)
rp2 = 0.134  # Resistencia secundario referido (Ω)
xl1 = 0.056  # Reactancia fuga primario (Ω)
xpl2 = 0.056 # Reactancia fuga secundario (Ω)
xm = 708.8   # Reactancia magnetización (Ω)

# Curva de saturación Dpsi vs psisat (extraída de m1.py - versión reducida)
# Dpsi es la corriente de magnetización equivalente
# psisat es el flujo de saturación
Dpsi_array = np.array([
    -2454.6, -2412.6, -2370.5, -2328.5, -2286.4, -2244.4, -2202.3,
    -2160.3, -2118.2, -2076.1, -2034.1, -1992.0, -1950.0, -1907.9,
    -1823.8, -1739.7, -1655.6, -1571.5, -1487.4, -1403.3, -1319.2,
    -1235.1, -1151.0, -1066.9, -982.76, -898.65, -814.55, -730.44,
    -646.43, -562.89, -479.53, -396.75, -313.96, -231.17, -154.04,
    -81.619, -19.566, 0.0, 19.566, 81.619, 154.04, 231.17, 313.96,
    396.75, 479.53, 562.89, 646.43, 730.44, 814.55, 898.65, 982.76,
    1066.9, 1151.0, 1235.1, 1319.2, 1403.3, 1487.4, 1571.5, 1655.6,
    1739.7, 1823.8, 1907.9, 1950.0, 1992.0, 2034.1, 2076.1, 2118.2,
    2160.3, 2202.3, 2244.4, 2286.4, 2328.5, 2370.5, 2412.6, 2454.6
])

psisat_array = np.array([
    -170.21, -169.93, -169.65, -169.36, -169.08, -168.80, -168.52,
    -168.23, -167.95, -167.67, -167.38, -167.10, -166.82, -166.54,
    -165.69, -165.12, -164.56, -163.99, -163.43, -162.86, -162.29,
    -161.73, -161.16, -160.60, -160.03, -159.47, -158.90, -158.34,
    -157.39, -156.07, -154.57, -152.68, -150.80, -146.08, -137.60,
    -122.52, -84.672, 0.0, 84.672, 122.52, 137.60, 146.08, 150.80,
    152.68, 154.57, 156.07, 157.39, 158.34, 158.90, 159.47, 160.03,
    160.60, 161.16, 161.73, 162.29, 162.86, 163.43, 163.99, 164.56,
    165.12, 165.69, 166.54, 166.82, 167.10, 167.38, 167.67, 167.95,
    168.23, 168.52, 168.80, 169.08, 169.36, 169.65, 169.93, 170.21
])

# Crear función de interpolación para saturación
saturation_curve = interp1d(psisat_array, Dpsi_array, kind='linear',
                            bounds_error=False, fill_value='extrapolate')

def transformer_saturated(t, y, RH_value):
    """
    Transformador con saturación magnética
    Estados: psi1 (flujo primario), psi2' (flujo secundario referido)
    """
    psi1, psi2p = y

    # Voltaje aplicado (senoidal)
    v1 = Vpk * np.sin(wb * t)

    # Flujos de fuga
    psi_l1 = xl1/wb * (psi1 - 0) / (xl1/wb)  # Simplificado
    psi_l2p = xpl2/wb * (psi2p - 0) / (xpl2/wb)

    # Flujo mutuo (sin saturación sería lineal)
    psi_m_linear = (psi1 - psi_l1 + psi2p - psi_l2p)

    # Aplicar saturación usando la curva
    Dpsi_sat = saturation_curve(psi_m_linear)
    psi_m = psi_m_linear - Dpsi_sat * xm/wb

    # Corrientes
    i1 = (psi1 - psi_m) / (xl1/wb)
    i2p = (psi2p - psi_m) / (xpl2/wb)

    # Voltaje secundario (carga resistiva)
    v2p = -RH_value * i2p

    # Ecuaciones diferenciales
    dpsi1_dt = v1 - r1*i1
    dpsi2p_dt = v2p - rp2*i2p

    return [dpsi1_dt, dpsi2p_dt]

# Simular tres casos: sin carga, carga media, cortocircuito
casos = [
    ('Circuito abierto (sin carga)', 960.0),
    ('Carga nominal', 9.6),
    ('Cortocircuito', 0.01)
]

print("="*70)
print("SIMULACIÓN: TRANSFORMADOR CON SATURACIÓN MAGNÉTICA")
print("="*70)
print(f"Transformador: {Vrated} V, {Srated} VA, {Frated} Hz")
print(f"Curva de saturación: {len(psisat_array)} puntos")
print("="*70)

fig, axes = plt.subplots(3, 2, figsize=(14, 10))

for idx, (nombre, RH) in enumerate(casos):
    print(f"\nCaso {idx+1}: {nombre} (RH = {RH:.2f} Ω)")

    # Condiciones iniciales
    y0 = [0.0, 0.0]

    # Simular 3 ciclos
    t_span = [0, 3/Frated]
    sol = solve_ivp(lambda t, y: transformer_saturated(t, y, RH),
                    t_span, y0, method='RK45', max_step=1e-5,
                    dense_output=True, rtol=1e-6)

    # Evaluar en puntos uniformes
    t = np.linspace(0, 3/Frated, 2000)
    y = sol.sol(t)
    psi1, psi2p = y

    # Calcular corrientes y voltajes
    i1 = np.zeros_like(t)
    i2p = np.zeros_like(t)
    v2p = np.zeros_like(t)

    for i, ti in enumerate(t):
        # Recalcular corrientes en cada punto
        psi_m_linear = (psi1[i] + psi2p[i])
        Dpsi_sat = saturation_curve(psi_m_linear)
        psi_m = psi_m_linear - Dpsi_sat * xm/wb

        i1[i] = (psi1[i] - psi_m) / (xl1/wb)
        i2p[i] = (psi2p[i] - psi_m) / (xpl2/wb)
        v2p[i] = -RH * i2p[i]

    v1 = Vpk * np.sin(wb * t)

    # Estadísticas
    print(f"  Corriente primaria pico: {np.abs(i1).max():.2f} A")
    print(f"  Corriente secundaria pico: {np.abs(i2p).max():.2f} A")
    print(f"  Flujo máximo: {np.abs(psi1).max():.2f} Wb")

    # Graficar
    row = idx

    # Voltaje y corriente primario
    ax1 = axes[row, 0]
    ax1_twin = ax1.twinx()
    ax1.plot(t*1000, v1, 'b-', label='v1', linewidth=1.5)
    ax1_twin.plot(t*1000, i1, 'r-', label='i1', linewidth=1.5)
    ax1.set_xlabel('Tiempo (ms)')
    ax1.set_ylabel('Voltaje (V)', color='b')
    ax1_twin.set_ylabel('Corriente (A)', color='r')
    ax1.set_title(f'{nombre} - Primario')
    ax1.grid(True, alpha=0.3)
    ax1.tick_params(axis='y', labelcolor='b')
    ax1_twin.tick_params(axis='y', labelcolor='r')

    # Curva B-H (flujo vs corriente de magnetización)
    ax2 = axes[row, 1]
    ax2.plot(i1, psi1, 'g-', linewidth=2)
    ax2.set_xlabel('Corriente magnetización (A)')
    ax2.set_ylabel('Flujo (Wb)')
    ax2.set_title(f'{nombre} - Curva B-H (Saturación)')
    ax2.grid(True)

    # Mostrar saturación
    if np.abs(i1).max() > 2:
        ax2.text(0.5, 0.95, 'SATURACIÓN\nVISIBLE',
                transform=ax2.transAxes, fontsize=12,
                verticalalignment='top', bbox=dict(boxstyle='round',
                facecolor='yellow', alpha=0.7))

plt.tight_layout()
plt.savefig('transformador_saturacion.png', dpi=150)
print(f"\n{'='*70}")
print("Gráfica guardada: transformador_saturacion.png")
print("="*70)
print("\n📊 OBSERVACIONES:")
print("• Circuito abierto: Muestra saturación magnética en la curva B-H")
print("• Carga nominal: Curva B-H más lineal, menor saturación")
print("• Cortocircuito: Alta corriente, limitada principalmente por resistencias")
print("\n✅ ¡Simulación completada!")

# plt.show()
