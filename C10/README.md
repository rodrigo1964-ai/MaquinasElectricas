# Capítulo 10: Sistemas de Potencia Avanzados

Análisis de resonancia subsíncrona (SSR), estabilizadores de sistemas de potencia (PSS) y motores de imanes permanentes.

## 📄 Scripts Python Disponibles

### Parámetros de Máquinas
- **i3essr.py** - Parámetros IEEE First Benchmark Model para SSR (1977)
- **set1.py** - Generador síncrono Set 1 (920 MVA)
- **set2.py** - Generador síncrono Set 2 (911 MVA)

### Funciones Auxiliares
- **m5torqi.py** - Optimización torque-corriente para motor PM
- **m5torqv.py** - Optimización torque-voltaje para motor PM

### Scripts de Análisis Principal
- **m1.py** - Modelo transitorio de máquina síncrona con análisis de eigenvalores
- **m2.py** - Sistema multimáquina (2 generadores) con análisis de estabilidad
- **m3.py** - Resonancia subsíncrona con compensación capacitiva serie
- **m3g.py** - Resonancia subsíncrona con voltaje terminal fijo
- **m4.py** - Diseño de estabilizador de sistemas de potencia (PSS)
- **m4comp.py** - Verificación y comparación de diseño PSS
- **m5.py** - Motor de imanes permanentes autocontrolado

## 🚀 Uso

### Proyecto 1: Modelo Transitorio de Máquina Síncrona

```bash
python3 m1.py
```

Realiza:
- Carga de parámetros de máquina síncrona
- Cálculo de punto de operación en estado estacionario
- Preparación para análisis de eigenvalores y función de transferencia
- Cálculo de variables dq0

**Salida típica:**
```
Operating Point:
  P = 0.8000 pu
  Q = 0.6000 pu
  |Vt| = 1.0000 pu
  delta = 28.45 degrees
  Efo = 1.8234 pu
```

### Proyecto 2: Sistema Multimáquina

```bash
python3 m2.py
```

**Características:**
- Análisis de dos generadores interconectados
- Matriz Y-bus de la red
- Condiciones de operación para ambos generadores
- Secuencias de perturbación de torque

**Configuración:**
- Sistema base: 1000 MVA
- Generador 1: 920 MVA (Set 1)
- Generador 2: 911 MVA (Set 2)
- Análisis de fallas y disturbios

### Proyecto 3: Resonancia Subsíncrona (SSR)

```bash
python3 m3.py
```

**Análisis modal torsional:**
- Sistema de 6 masas con inercias acopladas
- Compensación capacitiva serie
- Frecuencias naturales/modales
- Matriz de formas modales
- Coeficientes de amortiguamiento

**Parámetros del sistema torsional:**
- Masa 1-4: Secciones de turbina
- Masa 5: Rotor del generador
- Masa 6: Excitador
- 5 resortes de acoplamiento

**Salida:**
- Frecuencias modales (rad/s y Hz)
- Matriz de formas modales escalada
- Gráficas de formas modales guardadas en `m3_mode_shapes.png`

```bash
python3 m3g.py
```

Variante con voltaje terminal fijo (diferente configuración de red).

### Proyecto 4: Estabilizador de Sistemas de Potencia (PSS)

```bash
python3 m4.py
```

**Diseño de PSS:**
- Cálculo de punto de operación en estado estacionario
- Derivación de funciones de transferencia:
  - Exc(s): Función de transferencia del excitador
  - GEP(s): Función de transferencia potencia eléctrica-deslizamiento
- Ganancias no lineales K1-K6
- Diagramas de Bode

**Parámetros PSS:**
```python
Ks = 120        # Ganancia PSS
Tw = 1.0        # Constante washout
T1 = 0.024      # Lead-lag T1
T2 = 0.002      # Lead-lag T2
T3 = 0.024      # Lead-lag T3
T4 = 0.24       # Lead-lag T4
```

**Salida:** Diagrama de Bode guardado en `m4_GEP_bode.png`

```bash
python3 m4comp.py
```

Verificación del diseño PSS con diagramas de Bode adicionales.

### Proyecto 5: Motor de Imanes Permanentes

```bash
python3 m5.py
```

**Características en estado estacionario:**
- Características torque-velocidad
- Operación óptima torque/ampere
- Curvas torque vs ángulo
- Relaciones Ide-Iqe para control
- Ajuste de curvas para tablas lookup

**Motor de 70 HP:**
- 4 polos
- Voltaje nominal: 58.5√3 V RMS fase-neutro
- Voltaje de excitación del imán: 40.2√3 V

**Salidas:**
- `m5_steady_state_1.png`: Curvas torque-ángulo, Vs vs Tem, Ide vs Iqe
- `m5_steady_state_2.png`: Vq/Vd, Iq/Id, ángulos, curva P-Q

## ⚙️ Modelos Simulink → Convertir a Modelica

**28 modelos Simulink disponibles:**

### Proyecto 1: Modelo Transitorio
- `S1.M` / `S1.MDL` - Máquina síncrona modelo básico
- `S1EIG.M` / `S1EIG.MDL` - Análisis de eigenvalores

### Proyecto 2: Multimáquina
- `S2.M` / `S2.MDL` - Sistema de dos máquinas
- `S2EIG.M` / `S2EIG.MDL` - Análisis de eigenvalores multimáquina

### Proyecto 3: SSR
- `S3.M` / `S3.MDL` - SSR con compensación capacitiva serie
- `S3EIG.M` / `S3EIG.MDL` - Análisis de eigenvalores SSR
- `S3G.M` / `S3G.MDL` - SSR con voltaje terminal fijo
- `S3GEIG.M` / `S3GEIG.MDL` - Análisis de eigenvalores S3G

### Proyecto 4: PSS
- `S4.M` / `S4.MDL` - Sistema con estabilizador PSS

### Proyecto 5: Motor PM
- `S5.M` / `S5.MDL` - Motor de imanes permanentes autocontrolado

### Conversión con Simelica

```bash
# Proyecto 1
simelica S1.MDL -o s1.mo
simelica S1EIG.MDL -o s1eig.mo

# Proyecto 2
simelica S2.MDL -o s2.mo
simelica S2EIG.MDL -o s2eig.mo

# Proyecto 3
simelica S3.MDL -o s3.mo
simelica S3EIG.MDL -o s3eig.mo
simelica S3G.MDL -o s3g.mo
simelica S3GEIG.MDL -o s3geig.mo

# Proyecto 4
simelica S4.MDL -o s4.mo

# Proyecto 5
simelica S5.MDL -o s5.mo
```

### Uso en OpenModelica

1. Abrir en OMEdit: `OMEdit s3.mo`
2. Configurar parámetros desde scripts Python correspondientes
3. Configurar tiempo de simulación (típicamente 3-30 segundos)
4. Ejecutar simulación
5. Exportar resultados a Python para análisis adicional

## 📊 Conceptos y Teoría

### Resonancia Subsíncrona (SSR)

La **resonancia subsíncrona** es un fenómeno en sistemas de potencia donde:
- La compensación capacitiva serie interactúa con las inercias torsionales del eje turbina-generador
- Puede causar oscilaciones torsionales autosostenidas o crecientes
- Las frecuencias naturales del sistema torsional pueden coincidir con frecuencias eléctricas subsíncronas

**IEEE First Benchmark Model:**
- Sistema de prueba estándar IEEE (1977)
- Generador de 892 MVA
- Sistema torsional de 6 masas
- Línea de transmisión con compensación capacitiva serie

**Parámetros clave (i3essr.py):**
```python
Vrated = 18 kV         # Voltaje nominal
Prated = 892 MVA       # Potencia nominal
H = 2.89               # Constante de inercia
xd = 1.79              # Reactancia eje d
xq = 1.71              # Reactancia eje q
Tpdo = 4.3             # Constante transitoria d
Tpqo = 0.85            # Constante transitoria q
```

### Estabilizador de Sistemas de Potencia (PSS)

El **PSS** es un dispositivo de control que:
- Añade amortiguamiento a oscilaciones electromecánicas
- Mejora la estabilidad de sistemas de potencia
- Se implementa típicamente en el sistema de excitación

**Estructura típica:**
```
Input (deslizamiento) → Washout → Lead-Lag → Lead-Lag → Limitador → Output
```

**Función de transferencia:**
```
PSS(s) = Ks × (sTw)/(1+sTw) × (1+sT1)/(1+sT2) × (1+sT3)/(1+sT4)
```

**Diseño (m4.py):**
- Determina funciones de transferencia linealizadas
- Calcula Exc(s) y GEP(s)
- Usa análisis de Bode para ajustar parámetros
- Verifica estabilidad con lugares de raíces

### Motor Síncrono de Imanes Permanentes (PM)

**Características:**
- Excitación de campo por imanes permanentes (no devanado de campo)
- Control vectorial en marco dq
- Operación óptima: máximo torque por ampere

**Ecuaciones torque electromagnético:**
```
Te = (xd - xq)×Id×Iq + xmd×Ipm×Iq

donde:
  Ipm = Em/xmd  (corriente equivalente del imán)
```

**Control óptimo (m5.py):**
- Determina ángulo γ óptimo para cada punto de operación
- Genera tablas lookup Ide(Iqe) y Vs(Tem)
- Ajuste polinomial para implementación en controlador

## 📈 Parámetros por Modelo

### IEEE SSR Benchmark (i3essr.py)
```python
Prated = 892 MVA      # Potencia nominal
Vrated = 18 kV        # Voltaje nominal
Frated = 60 Hz        # Frecuencia
Poles = 2             # Número de polos
H = 2.89              # Constante de inercia
xd = 1.79, xq = 1.71  # Reactancias síncronas
xpd = 0.169           # Reactancia transitoria d
xppd = 0.135          # Reactancia subtransitoria d
Tpdo = 4.3 s          # Constante de tiempo transitoria
KA = 50               # Ganancia excitador
```

### Generador Set 1 (set1.py)
```python
Prated = 828.315 MVA  # Potencia nominal
Vrated = 18 kV        # Voltaje nominal
Poles = 4             # Número de polos
H = 3.77              # Constante de inercia
xd = 1.790, xq = 1.660
xpd = 0.355, xpq = 0.570
Tpdo = 7.9 s, Tpqo = 0.410 s
Domega = 2            # Amortiguamiento
```

### Generador Set 2 (set2.py)
```python
Prated = 911 MVA      # Potencia nominal
Vrated = 18 kV        # Voltaje nominal
H = 2.5               # Constante de inercia
xd = 2.040, xq = 1.960
xpd = 0.266, xpq = 0.262
Tpdo = 6.0 s, Tpqo = 0.9 s
```

### Motor PM de 70 HP (m5.py)
```python
Prated = 70 × 746 W   # Potencia nominal
Vrated = 58.5√3 V     # Voltaje fase-neutro
Poles = 4             # Número de polos
Frated = 113 Hz       # Frecuencia base
Em = 40.2√3 V         # Voltaje excitación imán
xd = 0.097 pu         # Reactancia eje d
xq = 0.193 pu         # Reactancia eje q
J_rotor = 0.292 Nms²  # Inercia rotor
```

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| I3ESSR.M        | i3essr.py      | Parámetros IEEE SSR benchmark |
| SET1.M          | set1.py        | Parámetros generador Set 1 |
| SET2.M          | set2.py        | Parámetros generador Set 2 |
| M5TORQI.M       | m5torqi.py     | Función optimización torque-I |
| M5TORQV.M       | m5torqv.py     | Función optimización torque-V |
| M1.M            | m1.py          | Modelo transitorio |
| M2.M            | m2.py          | Sistema multimáquina |
| M3.M            | m3.py          | SSR con capacitor serie |
| M3G.M           | m3g.py         | SSR voltaje fijo |
| M4.M            | m4.py          | Diseño PSS |
| M4COMP.M        | m4comp.py      | Verificación PSS |
| M5.M            | m5.py          | Motor PM autocontrolado |
| S1-S5.M/MDL     | → Modelica     | Modelos dinámicos |

## 💡 Ejemplos de Uso

### Ejemplo 1: Análisis Modal de SSR

```bash
python3 m3.py
```

**Resultado esperado:**
```
Torsional Modes of a 6 mass inertia system
Natural/modal frequencies:
  rad/sec: [0, 98.5, 127.3, 161.2, 202.7, 289.1]
  Hz: [0, 15.7, 20.3, 25.7, 32.3, 46.0]

Mode shapes saved to m3_mode_shapes.png
```

### Ejemplo 2: Diseño Completo de PSS

```bash
# Paso 1: Calcular funciones de transferencia
python3 m4.py

# Paso 2: Verificar diseño
python3 m4comp.py
```

**Analiza:**
- Respuesta en frecuencia de GEP(s)
- Efecto del PSS en estabilidad
- Diagramas de Bode con y sin PSS

### Ejemplo 3: Caracterización Motor PM

```bash
python3 m5.py
```

**Genera:**
- Características torque-ángulo para múltiples puntos de operación
- Relación Ide vs Iqe (para control de corriente)
- Voltaje requerido vs torque (para control de velocidad)
- Curva P-Q del motor

### Ejemplo 4: Análisis Multimáquina

```bash
python3 m2.py
```

**Configura:**
- Red con 2 generadores y bus infinito
- Matriz Y-bus modificada
- Condiciones iniciales para simulación
- Secuencia de perturbaciones de torque

## 📚 Referencias

### IEEE SSR Benchmark
IEEE Committee Report, "First Benchmark Model for Computer Simulation of Subsynchronous Resonance,"
*IEEE Transactions on Power Apparatus and Systems*, Vol. PAS-96, No. 5, Sept/Oct 1977, pp. 1565-1572.

### Motor PM
Bose, B. K., "A High-Performance Inverter-Fed Drive System of an Interior Permanent Magnet Synchronous Machine,"
*IEEE Transactions on Industry Applications*, Vol. 24, No. 6, Nov/Dec 1988, pp. 987-997.

## 🔧 Requisitos

```bash
pip install numpy scipy matplotlib
```

**Librerías opcionales para extensión:**
```bash
pip install control        # Para análisis avanzado de sistemas de control
pip install sympy          # Para manipulación simbólica
```

## ⚠️ Notas Importantes

### Funciones Simulink
Los scripts de análisis calculan condiciones de estado estacionario y parámetros del sistema. Para simulación dinámica completa, los modelos Simulink (.MDL) deben convertirse a:
- Modelica (usando simelica)
- Python/scipy (implementación manual de ODEs)
- Librería python-control

### Linearización
Funciones MATLAB `trim` y `linmod` requieren implementación manual o uso de:
- `scipy.integrate.solve_ivp` con optimización
- Librería `python-control` para análisis de sistemas lineales

### Conversión MATLAB → Python
Todos los archivos .M han sido convertidos a .py con:
- Indexación ajustada (MATLAB 1-based → Python 0-based)
- Funciones numéricas: NumPy/SciPy
- Gráficas: matplotlib
- Números complejos: 1j en lugar de i

---

Ver [README principal](../README.md) para más información sobre el repositorio completo.

Ver [README_CONVERSION.md](README_CONVERSION.md) para detalles técnicos de la conversión MATLAB-Python.
