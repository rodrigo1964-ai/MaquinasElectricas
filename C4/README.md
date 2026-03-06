# Capítulo 4: Transformadores

Transformadores monofásicos, trifásicos, curvas de saturación.

## 📄 Scripts Python Disponibles

### Scripts Principales
- **m1.py** - Setup transformador monofásico con curva de magnetización
- **m4.py** - Banco trifásico de transformadores

### Utilidades
- **mginit.py** - Conversión de curva RMS a curva instantánea ψ vs i
- **mgplt.py** - Ploteo de comparación de curvas de magnetización
- **fftplot.py** - Análisis FFT de variables

## 🚀 Uso

### Proyecto 1-2: Transformador Monofásico

```bash
python3 m1.py
```

**Parámetros del transformador:**
- Vrated = 120 V, Srated = 1500 VA
- Relación de espiras: 120/240
- Incluye curva de saturación Dpsi vs psisat

**Uso interactivo:**
```python
from m1 import plot_results, Zb
import numpy as np

# Ejecutar simulación con diferentes cargas
RH = 0          # Cortocircuito
# RH = 100 * Zb # Circuito abierto

# Después de simulación:
# plot_results(y, RH)
```

### Proyecto 4: Banco Trifásico

```bash
python3 m4.py
```

Parámetros idénticos a m1.py para tres transformadores.

**Configuración:**
- Rload = 9.6 Ω (carga 1.5 kVA, fp unitario por fase)
- Variable: Rn (resistencia neutro-tierra)

### Análisis de Magnetización

```bash
# 1. Convertir curva de circuito abierto
python3 mginit.py

# 2. Ejecutar simulación (en OpenModelica)

# 3. Plotear comparación
python3 mgplt.py
```

### Análisis FFT

```bash
python3 fftplot.py
```

Calcula y grafica transformada de Fourier de cualquier variable.

## ⚙️ Modelos Simulink → Convertir a Modelica

**10 modelos Simulink:**
- `S1A.M/MDL` - Transformador variante A
- `S1B.M/MDL` - Transformador variante B
- `S1C.M/MDL` - Transformador variante C
- `S4.M/MDL` - Banco trifásico
- `SMG.M/MDL` - Modelo de magnetización

### Conversión

```bash
simelica S1A.MDL -o s1a.mo
simelica S1B.MDL -o s1b.mo
simelica S1C.MDL -o s1c.mo
simelica S4.MDL -o s4.mo
simelica SMG.MDL -o smg.mo
```

### Configuración en OpenModelica

**Parámetros de m1.py:**
```python
Vrated = 120      # Voltaje nominal (V)
Srated = 1500     # Potencia nominal (VA)
Frated = 60       # Frecuencia (Hz)
NpbyNs = 0.5      # Relación espiras
r1 = 0.25         # Resistencia devanado 1 (Ω)
rp2 = 0.134       # Resistencia referida dev 2 (Ω)
xl1 = 0.056       # Reactancia fuga dev 1 (Ω)
xpl2 = 0.056      # Reactancia fuga dev 2 (Ω)
xm = 708.8        # Reactancia magnetización (Ω)
```

**Condiciones iniciales:**
```python
Psi1o = 0         # Flujo inicial dev 1
Psip2o = 0        # Flujo inicial dev 2
tstop = 0.2       # Tiempo simulación (s)
```

**Curvas de saturación:** Ver arrays Dpsi y psisat en m1.py

## 📊 Curva de Magnetización

### mginit.py

Convierte curva V-I RMS a curva ψ-i instantánea:

**Entrada (arrays V, I):**
- Voltajes RMS: 0...137.5 V
- Corrientes RMS: 0...0.4 A

**Salida:**
- `psifull`: Flujo instantáneo completo (+/-)
- `ifull`: Corriente instantánea completa (+/-)

### mgplt.py

Compara errores entre:
- Curva RMS (circuito abierto)
- Curva instantánea ψ vs i

## 📈 Gráficas Generadas

### m1.py / plot_results(y, RH)
**Figura 1:**
- Voltaje primario v1
- Voltaje secundario v2'
- Flujo mutuo ψm

**Figura 2:**
- Corriente primaria i1
- Corriente secundaria i2'

### m4.py / plot_results(y, Rn)
**Figura 1:**
- Voltaje línea primario vAB
- Voltaje línea secundario vab
- Corriente línea primaria iA
- Corriente línea secundaria ia

**Figura 2:**
- Corriente promedio primario
- Corriente promedio secundario
- Voltaje neutro-tierra vnG

### fftplot.py
- Traza temporal de variable
- Espectro de frecuencia (hasta n-ésimo armónico)

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| M1.M            | m1.py          | Transformador monofásico |
| M4.M            | m4.py          | Banco trifásico |
| MGINIT.M        | mginit.py      | Conversión curva mag |
| MGPLT.M         | mgplt.py       | Ploteo comparación |
| FFTPLOT.M       | fftplot.py     | Análisis FFT |
| S1A-C.M/MDL     | → Modelica     | Variantes transformador |
| S4.M/MDL        | → Modelica     | Banco trifásico |
| SMG.M/MDL       | → Modelica     | Magnetización |

---

Ver [README principal](../README.md) para más información.
