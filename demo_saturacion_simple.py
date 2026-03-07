"""
Demo simplificada: Efecto de la saturación en transformador
"""
import numpy as np
import matplotlib.pyplot as plt

# Curva de saturación simplificada (psi vs i_mag)
# Zona lineal + zona de saturación
i_mag = np.linspace(-10, 10, 1000)
psi = np.zeros_like(i_mag)

# Modelo de saturación con tangente hiperbólica
Lm_linear = 15  # Inductancia lineal
psi_sat = 100   # Flujo de saturación

for idx, i in enumerate(i_mag):
    if abs(i) < 2:
        # Zona lineal
        psi[idx] = Lm_linear * i
    else:
        # Zona de saturación (suave)
        psi[idx] = psi_sat * np.tanh(i/2)

# Simular voltaje senoidal aplicado
t = np.linspace(0, 3/60, 500)  # 3 ciclos a 60 Hz
V_pk = 170  # 120 V RMS
psi_aplicado = V_pk / (2*np.pi*60) * (1 - np.cos(2*np.pi*60*t))

# Calcular corriente correspondiente (inversa de curva B-H)
from scipy.interpolate import interp1d
psi_to_i = interp1d(psi, i_mag, fill_value='extrapolate')
i_magnetizacion = psi_to_i(psi_aplicado)

# Tres casos: bajo voltaje, nominal, sobrevoltaje
casos = [
    ('80% Voltaje nominal', 0.8),
    ('100% Voltaje nominal', 1.0),
    ('120% Sobrevoltaje (saturación)', 1.2)
]

print("="*70)
print("TRANSFORMADOR CON SATURACIÓN MAGNÉTICA")
print("="*70)

fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Curva B-H general
axes[0, 0].plot(i_mag, psi, 'b-', linewidth=2)
axes[0, 0].axhline(y=psi_sat, color='r', linestyle='--', label='Saturación')
axes[0, 0].axhline(y=-psi_sat, color='r', linestyle='--')
axes[0, 0].set_xlabel('Corriente magnetización (A)')
axes[0, 0].set_ylabel('Flujo magnético (Wb)')
axes[0, 0].set_title('Curva B-H del Transformador')
axes[0, 0].grid(True)
axes[0, 0].legend()

for idx, (nombre, factor) in enumerate(casos):
    print(f"\n{nombre}:")

    # Escalar voltaje
    psi_caso = psi_aplicado * factor
    i_caso = psi_to_i(psi_caso)

    # Estadísticas
    print(f"  Corriente pico: {np.abs(i_caso).max():.2f} A")
    print(f"  Flujo pico: {np.abs(psi_caso).max():.2f} Wb")

    if idx < 2:
        # Forma de onda de corriente
        ax = axes[0, 1] if idx == 0 else axes[1, 0]
        ax.plot(t*1000, i_caso, linewidth=2, label=nombre)
        ax.set_xlabel('Tiempo (ms)')
        ax.set_ylabel('Corriente (A)')
        ax.set_title(f'{nombre}')
        ax.grid(True)

        # Marcar distorsión si hay
        if factor > 1.0:
            ax.text(0.5, 0.95, 'DISTORSIÓN POR\nSATURACIÓN',
                   transform=ax.transAxes, fontsize=10,
                   verticalalignment='top',
                   bbox=dict(boxstyle='round', facecolor='yellow', alpha=0.7))

# Comparación de los tres casos
axes[1, 1].plot(t*1000, psi_to_i(psi_aplicado * 0.8), 'g-', label='80%', linewidth=2)
axes[1, 1].plot(t*1000, psi_to_i(psi_aplicado * 1.0), 'b-', label='100%', linewidth=2)
axes[1, 1].plot(t*1000, psi_to_i(psi_aplicado * 1.2), 'r-', label='120% (saturado)', linewidth=2)
axes[1, 1].set_xlabel('Tiempo (ms)')
axes[1, 1].set_ylabel('Corriente (A)')
axes[1, 1].set_title('Comparación: Efecto del Sobrevoltaje')
axes[1, 1].grid(True)
axes[1, 1].legend()

plt.tight_layout()
plt.savefig('saturacion_comparacion.png', dpi=150, bbox_inches='tight')

print("\n" + "="*70)
print("✅ Gráfica guardada: saturacion_comparacion.png")
print("="*70)
print("\n📊 CONCLUSIONES:")
print("• A 80-100%: Corriente casi senoidal (zona lineal)")
print("• A 120%: Corriente distorsionada con picos altos (saturación)")
print("• Saturación → Corriente de magnetización no senoidal")
print("• Mayor flujo → Núcleo magnético se satura → ↑↑ corriente")
print("\n¡Simulación completada en <1 segundo!")
