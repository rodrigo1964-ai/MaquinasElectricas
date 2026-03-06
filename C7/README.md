# Capítulo 7: Máquinas Síncronas

Análisis de generadores y motores síncronos, máquinas de imanes permanentes.

## 📄 Scripts Python Disponibles

### Scripts de Análisis
- **m1.py** - Características de operación de máquina síncrona
- **m3.py** - Análisis linealizado de generador síncrono
- **m4.py** - Motor síncrono de imanes permanentes
- **m5.py** - Modelo 2×3 con acoplamiento
- **plot5c.py** - Comparación de proyectos

### Parámetros
- **set1.py** - Conjunto de parámetros Set 1
- **set3a.py** - Conjunto de parámetros Set 3A
- **set3b.py** - Conjunto de parámetros Set 3B
- **set3c.py** - Conjunto de parámetros Set 3C

## 🚀 Uso

### Proyecto 1: Características de Operación

```bash
python3 m1.py
```

Calcula y grafica características operacionales de máquina síncrona.

### Proyecto 3: Análisis Linealizado

```bash
python3 m3.py
```

**Linealización en punto de operación:**
- Estado estacionario
- Eigenvalores del sistema
- Análisis de estabilidad

### Proyecto 4: Motor de Imanes Permanentes

```bash
python3 m4.py
```

Análisis de motor PM:
- Control de corriente
- Torque electromagnético
- Características V/I

### Proyecto 5: Modelo 2×3

```bash
python3 m5.py
```

Máquina con dos devanados de campo y tres de armadura.

## ⚙️ Modelos Simulink → Convertir a Modelica

**14 modelos Simulink:**
- `S1.M/MDL` - Máquina síncrona estándar
- `S3.M/MDL` - Modelo alternativo
- `S3EIG.M/MDL` - Análisis de eigenvalores
- `S4.M/MDL` - Motor PM
- `S5.M/MDL` - Máquina 2×3

### Conversión

```bash
simelica S1.MDL -o s1.mo
simelica S3.MDL -o s3.mo
simelica S3EIG.MDL -o s3eig.mo
simelica S4.MDL -o s4.mo
simelica S5.MDL -o s5.mo
```

### Configuración - Set1.py

```python
# Ratings
Vrated = 230      # Voltaje nominal (V)
Srated = 5e3      # Potencia nominal (VA)
f = 60            # Frecuencia (Hz)
p = 2             # Pares de polos

# Resistencias (Ω)
rs = 0.5          # Estator
rf = 1.5          # Campo
rkd = 0.8         # Amortiguador eje d
rkq = 0.6         # Amortiguador eje q

# Inductancias (H)
Lls = 0.01        # Fuga estator
Llf = 0.015       # Fuga campo
Llkd = 0.012      # Fuga amortiguador d
Llkq = 0.012      # Fuga amortiguador q
Lmd = 0.15        # Magnetización eje d
Lmq = 0.10        # Magnetización eje q

# Mecánica
J = 0.5           # Inercia (kg·m²)
D = 0.01          # Amortiguamiento
```

## 📊 Modelo en Marco dq0

### Ecuaciones Eléctricas

**Eje directo (d):**
```
vd = -rs×id - ωe×Lq×iq + dψd/dt
ψd = Ld×id + Lmd×if
```

**Eje cuadratura (q):**
```
vq = -rs×iq + ωe×Ld×id + dψq/dt
ψq = Lq×iq
```

**Campo:**
```
vf = rf×if + dψf/dt
ψf = Lf×if + Lmd×id
```

### Torque Electromagnético

```
Te = (3/2)×(p/2)×(ψd×iq - ψq×id)
```

### Ecuación Mecánica

```
J×dωm/dt = Te - Tm - D×ωm
```

## 📈 Análisis de Estabilidad (m3.py)

### Linealización

Sistema linealizado:
```
Δẋ = A×Δx + B×Δu
Δy = C×Δx + D×Δu
```

**Estados:** Δδ, Δωm, Δid, Δiq, Δif

### Eigenvalores

- Modos electromecánicos
- Modos eléctricos
- Análisis de amortiguamiento

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| M1.M            | m1.py          | Características operación |
| M3.M            | m3.py          | Linealización |
| M4.M            | m4.py          | Motor PM |
| M5.M            | m5.py          | Modelo 2×3 |
| PLOT5C.M        | plot5c.py      | Comparaciones |
| SET1.M          | set1.py        | Parámetros Set 1 |
| SET3A-C.M       | set3a-c.py     | Parámetros Set 3 |
| S1-S5.M/MDL     | → Modelica     | Modelos dinámicos |

---

Ver [README principal](../README.md) para más información.
