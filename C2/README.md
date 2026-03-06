# Capítulo 2: Circuitos Básicos y Simulación

Análisis de circuitos básicos: VCO, RLC, resonancia.

## 📄 Scripts Python Disponibles

### Scripts Principales
- **m1.py** - Ploteo de resultados de simulación VCO
- **m2.py** - Simulación de circuito RLC con parámetros
- **m3.py** - Circuito RL con excitación AC
- **m4.py** - Circuito resonante serie con análisis de frecuencia

### Utilidades
- **m2init.py** - Inicialización para M2
- **m2plot.py** - Funciones de ploteo para M2

## 🚀 Uso

### Ejemplo: Análisis RLC

```bash
python3 m2.py
```

Este script:
- Define parámetros del circuito (Rs, L, C)
- Configura condiciones iniciales
- Proporciona función `plot_results(y)` para graficar

### Ejemplo: Circuito Resonante

```bash
python3 m4.py
```

- Calcula frecuencia de resonancia
- Grafica admitancia vs frecuencia
- Grafica potencia vs frecuencia
- Proporciona `plot_simulation_results(y)`

## ⚙️ Modelos Simulink → Convertir a Modelica

**8 modelos Simulink disponibles:**
- `S1.M` / `S1.MDL` - Modelo VCO
- `S2.M` / `S2.MDL` - Circuito RLC
- `S3.M` / `S3.MDL` - Circuito RL
- `S4.M` / `S4.MDL` - Circuito resonante serie

### Conversión con Simelica

```bash
# Convertir modelos Simulink a Modelica
simelica S1.MDL -o s1.mo
simelica S2.MDL -o s2.mo
simelica S3.MDL -o s3.mo
simelica S4.MDL -o s4.mo
```

### Uso en OpenModelica

1. Abrir en OMEdit: `OMEdit s2.mo`
2. Configurar parámetros desde `m2.py`:
   - Rs = 50 Ω
   - L = 0.1 H
   - C = 1000 µF
   - VS_mag = 100 V
3. Simular con tstop = 0.5 s
4. Exportar resultados a Python para análisis

## 📊 Parámetros por Modelo

### M2 - Circuito RLC
```python
Rs = 50          # Resistencia (Ω)
L = 0.1          # Inductancia (H)
C = 1000e-6      # Capacitancia (F)
VS_mag = 100     # Voltaje escalón (V)
vCo = 0          # V_capacitor inicial
iLo = 0          # I_inductor inicial
tstop = 0.5      # Tiempo simulación
```

### M3 - Circuito RL
```python
R = 0.4          # Resistencia (Ω)
L = 0.04         # Inductancia (H)
we = 314         # Frecuencia (rad/s)
Vac_mag = 100    # Voltaje AC (V)
```

### M4 - Resonancia Serie
```python
R = 12           # Resistencia (Ω)
L = 0.231e-3     # Inductancia (H)
C = 0.1082251e-6 # Capacitancia (F)
wo = √(1/LC)     # Frecuencia resonante
```

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| M1.M            | m1.py          | Ploteo VCO |
| M2.M            | m2.py          | Parámetros y plots RLC |
| M3.M            | m3.py          | RL con AC |
| M4.M            | m4.py          | Resonancia serie |
| S1.M/S1.MDL     | → Modelica     | Simulación VCO |
| S2.M/S2.MDL     | → Modelica     | Simulación RLC |
| S3.M/S3.MDL     | → Modelica     | Simulación RL |
| S4.M/S4.MDL     | → Modelica     | Simulación resonancia |

---

Ver [README principal](../README.md) para instrucciones generales.
