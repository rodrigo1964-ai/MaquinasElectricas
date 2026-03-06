# Capítulo 3: Líneas de Transmisión

Parámetros de línea, modelos de circuito, transitorios de conmutación.

## 📄 Scripts Python Disponibles

### Scripts Principales
- **m1.py** - Parámetros de línea y modelos de circuito (RL, pi nominal, pi equivalente)
- **m2.py** - Transitorios de conmutación en línea de parámetros distribuidos

## 🚀 Uso

### Proyecto 1: Modelos de Línea

```bash
python3 m1.py
```

Este script:
- Calcula parámetros RLC por metro de línea
- Determina matrices ABCD (serie RL, pi nominal, pi equivalente)
- Calcula condiciones en el extremo emisor
- Grafica diagrama circular P-Q del extremo receptor

**Salida:**
- Resistencia, inductancia, capacitancia por metro
- Matrices ABCD de los tres modelos
- Comparación VS, IS, pf entre modelos
- Diagrama P+jQ con tres curvas (0.94, 1.00, 1.06 pu)

### Proyecto 2: Transitorios de Conmutación

```bash
python3 m2.py
```

Configura parámetros para simulación de:
- Línea de transmisión de 100 millas
- Impedancia característica Zc
- Tiempo de retardo de propagación
- Atenuación de una vía
- Carga de 30 MVA, 0.8 pf

Proporciona `plot_results(y)` para graficar voltajes y corrientes.

## ⚙️ Modelos Simulink → Convertir a Modelica

**2 modelos Simulink:**
- `S2.M` / `S2.MDL` - Transitorios de línea distribuida

### Conversión

```bash
simelica S2.MDL -o s2.mo
```

### Configuración en OpenModelica

Importar parámetros desde `m2.py`:

```python
# Línea
d = 100          # Longitud (millas)
R = 0.15         # Resistencia (Ω/milla)
L = 2.96e-3      # Inductancia (H/milla)
C = 0.017e-6     # Capacitancia (F/milla)

# Fuente
Vrated = 500e3   # Voltaje nominal (V)
we = 2π×60       # Frecuencia angular
Ls = 0.1         # Inductancia fuente (H)

# Carga
SL = 30e6×(0.8+j0.6)  # Potencia compleja
```

## 📊 Parámetros Clave

### M1 - Línea de Transmisión

**Geometría:**
- D12p = 7.772 m (espaciamiento conductores)
- D1p2 = 6.858 m
- radc = 22.4 mm (radio conductor)
- GMRc = 16.3 mm
- d = 160 m (longitud línea)

**Carga:**
- PR = 40 MW/fase
- VR = 199 kV/fase
- pf = 0.9 lagging

### M2 - Transitorios

**Impedancia característica:**
- Zc = √(L/C) ≈ 417 Ω

**Tiempo de retardo:**
- tdelay = d×√(LC) ≈ 1.72 ms

**Atenuación:**
- α = exp(-(R/2)×√(C/L)×d)

## 📈 Gráficas Generadas

### M1.py
- Diagrama circular P-Q en el extremo receptor
- Tres curvas para diferentes magnitudes de VS (0.94, 1.00, 1.06 pu)

### M2.py (después de simulación)
**Figura 1:**
- Voltaje de fuente
- Voltaje del interruptor
- Corriente extremo emisor

**Figura 2:**
- Voltaje extremo emisor
- Corriente extremo receptor
- Voltaje terminal de carga

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| M1.M            | m1.py          | Parámetros y modelos de línea |
| M2.M            | m2.py          | Setup transitorios |
| S2.M/S2.MDL     | → Modelica     | Simulación transitorios |

---

Ver [README principal](../README.md) para más información.
