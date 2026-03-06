# Capítulo 5: Vectores Espaciales

Transformaciones de marco de referencia, secuencias, vectores espaciales.

## 📄 Scripts Python Disponibles

### Scripts Principales
- **m2.py** - Análisis de vectores espaciales (secuencias positiva y negativa)
- **m3.py** - Transformaciones de marco de referencia qd0

## 🚀 Uso

### Proyecto 2: Vectores Espaciales

```bash
python3 m2.py
```

**Interactivo:** Solicita entrada del usuario:
- `m`: Orden del armónico fundamental
- `alpha`: Factor de atenuación (0 = amplitud constante, 0.2 = espiral)
- `n`: Orden del segundo armónico (negativo para desactivar)

**Corrientes trifásicas:**
```
ia_m = 10×cos(m×2π×t)
ib_m = 10×cos(m×2π×t - 2π/3)
ic_m = 10×cos(m×2π×t - 4π/3)

ia_n = (10/n)×cos(2n×π×t)
ib_n = (10/n)×cos(2n×π×t - 2n×π/3)
ic_n = (10/n)×cos(2n×π×t - 4n×π/3)
```

**Secuencias calculadas:**
- i₁ (secuencia positiva)
- i₂ (secuencia negativa)

**Gráficas:**
- Locus de i₁ en plano complejo
- Locus de i₂ en plano complejo

### Proyecto 3: Transformación qd0

```bash
python3 m3.py
```

**Interactivo:** Solicita:
- `m`: Orden del armónico
- `alpha`: Factor de atenuación
- `nframe`: Marco de referencia (1=estationary, 2=rotor, 3=synchronous)
- `theta0`: Ángulo inicial del marco (si nframe=3)

**Transformaciones:**
1. **abc → qd0s** (marco estacionario):
   ```
   i_q0s = (2/3) × T × [ia, ib, ic]ᵀ
   ```

2. **qd0s → qd0e** (marco arbitrario):
   ```
   i_qde = R(θ) × i_q0s
   donde R(θ) = [[cos(θ), sin(θ), 0],
                  [-sin(θ), cos(θ), 0],
                  [0, 0, 1]]
   ```

**Gráficas (6 subplots):**
- Corrientes abc vs tiempo
- Corrientes qd0s vs tiempo
- Corrientes qd0e vs tiempo

## ⚙️ Modelos Simulink → Convertir a Modelica

**4 modelos Simulink:**
- `S2.M/MDL` - Vectores espaciales y secuencias
- `S3.M/MDL` - Transformaciones qd0

### Conversión

```bash
simelica S2.MDL -o s2.mo
simelica S3.MDL -o s3.mo
```

### Configuración S2 (Vectores Espaciales)

**Parámetros desde m2.py:**
```python
m = 1             # Orden armónico fundamental
alpha = 0         # Factor atenuación (0 o 0.2)
n = -1            # Segundo armónico (negativo=off)
tstop = 0.95      # Tiempo simulación
```

**Implementación:**
- Transformación de Clarke: abc → αβ0
- Cálculo secuencias: i₁, i₂

### Configuración S3 (Transformación qd0)

**Parámetros desde m3.py:**
```python
m = 1             # Orden armónico
alpha = 0         # Atenuación
nframe = 1        # Marco referencia
theta0 = 0        # Ángulo inicial
```

**Bloques:**
- abc_to_qd0s(): Transformación a marco estacionario
- qd0s_to_qd0e(): Transformación a marco arbitrario

## 📊 Conceptos Clave

### Transformación de Clarke (abc → αβ0)

```
T = (2/3) × [[1,       -1/2,      -1/2     ],
             [0,    √3/2,      -√3/2     ],
             [1/2,      1/2,       1/2     ]]
```

### Secuencias

**Secuencia positiva:**
```
i₁ = (1/3)(ia + a×ib + a²×ic)
donde a = e^(j2π/3)
```

**Secuencia negativa:**
```
i₂ = (1/3)(ia + a²×ib + a×ic)
```

### Marcos de Referencia

1. **Estacionario (qd0s):** Fijo al estator
2. **Rotor (qd0r):** Gira con rotor, θ = ωᵣt
3. **Síncrono (qd0e):** Gira a ωₑ, θ = ωₑt + θ₀

## 📈 Gráficas Generadas

### m2.py
**Figura con 2 subplots:**
- Locus de secuencia positiva i₁ (αβ plane)
- Locus de secuencia negativa i₂ (αβ plane)

**Comportamientos:**
- m>0: Rotación antihoraria (secuencia +)
- m<0: Rotación horaria (secuencia -)
- alpha>0: Trayectoria espiral

### m3.py
**Figura 1 (3 subplots):**
- ia, ib, ic vs tiempo
- iq0s, id0s, i00s vs tiempo
- iq0e, id0e, i00e vs tiempo

**Efectos del marco:**
- Estacionario: Componentes AC
- Rotor/Síncrono: Componentes DC (en régimen)

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| M2.M            | m2.py          | Vectores espaciales |
| M3.M            | m3.py          | Transformación qd0 |
| S2.M/MDL        | → Modelica     | Simulación vectores |
| S3.M/MDL        | → Modelica     | Simulación qd0 |

---

Ver [README principal](../README.md) para más información.
