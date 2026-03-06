# Capítulo 8: Máquinas DC

Análisis de generadores DC, motores DC, métodos de frenado y máquinas especiales.

## 📄 Scripts Python Disponibles

### Scripts de Análisis
- **m1.py** - Generador DC shunt (autogeneración, curva de magnetización)
- **m2.py** - Arranque de motor DC
- **m3a.py** - Métodos de frenado: plugging y dinámico
- **m3b.py** - Frenado regenerativo
- **m4.py** - Motor universal (AC/DC)
- **m5.py** - Motor serie para montacargas/grúa

## 🚀 Uso

### Proyecto 1: Generador Shunt

```bash
python3 m1.py
```

**Características:**
- Generador DC con excitación shunt
- Curva de magnetización
- Análisis de autogeneración
- Carga resistiva variable

**Parámetros clave:**
- Prated = 1492 W (2 HP)
- Vrated = 125 V
- Iarated = 16 A
- wmrated = 1750 rpm
- Ra = 0.24 Ω, Rf = 111 Ω
- J = 0.8 kg·m²

**Gráficas generadas:**
- Corriente de campo If vs tiempo
- Voltaje interno Ea vs tiempo
- Corriente de armadura Ia vs tiempo
- Torque electromagnético Tem
- Voltaje terminal Va

### Proyecto 2: Arranque de Motor DC

```bash
python3 m2.py
```

**Análisis transitorio:**
- Motor DC con excitación separada
- Arranque directo desde reposo
- Respuesta de corriente y velocidad
- Torque durante arranque

**Parámetros:**
- Prated = 7460 W (10 HP)
- Vrated = 220 V
- wmrated = 1490 rpm
- Ra = 0.3 Ω
- Laq = 0.012 H
- J = 2.5 kg·m²

**Gráficas:**
- Voltaje interno Ea
- Corriente de armadura Ia
- Velocidad del rotor wm

### Proyecto 3: Métodos de Frenado

#### Parte A: Plugging y Frenado Dinámico

```bash
python3 m3a.py
```

**Método de Plugging:**
- Inversión de polaridad de armadura
- Rext = 6.054 Ω
- Vbrake = -Vrated
- Frenado rápido con alta corriente

**Frenado Dinámico:**
- Desconexión de fuente, cortocircuito con resistencia
- Rext = 2.929 Ω
- Vbrake = 0 V
- Disipación de energía en resistor

**Parámetros:**
- Prated = 1492 W (2 HP)
- Ra = 0.14 Ω
- J = 0.5 kg·m²

#### Parte B: Frenado Regenerativo

```bash
python3 m3b.py
```

**Características:**
- Operación en cuatro cuadrantes
- Retorno de energía a la red
- Control de velocidad en descenso
- wraise = wmrated
- wlower = -wmrated/3

**Gráficas:**
- Velocidad del rotor wm
- Corriente de armadura Ia
- Torque eléctrico Tem
- Voltaje de armadura Va

### Proyecto 4: Motor Universal

```bash
python3 m4.py
```

**Operación AC/DC:**
- Motor serie para AC o DC
- Arranque desde reposo
- Respuesta a cambios de carga
- Comparación AC vs DC

**Parámetros:**
- Prated = 325 W
- Vrated = 120 V (RMS)
- Iarated = 3.5 A (RMS)
- wmrated = 2800 rpm
- Ra = 0.6 Ω, Rse = 0.1 Ω
- J = 0.015 kg·m²

**Casos simulados:**
1. Arranque con alimentación AC
2. Escalón de carga con AC
3. Escalón de carga con DC

**Gráficas:**
- Voltaje de alimentación Va
- Voltaje interno Ea
- Corriente de armadura Ia
- Torque electromagnético Tem

### Proyecto 5: Motor Serie para Montacargas

```bash
python3 m5.py
```

**Aplicación:**
- Motor serie para grúa/montacargas
- Características de frenado
- Control de velocidad en descenso de carga
- Cálculo de resistencia de frenado

**Parámetros:**
- Prated = 1500 W
- Vrated = 125 V
- Iarated = 13.2 A
- wmrated = 1425 rpm
- Ra = 0.24 Ω, Rse = 0.2 Ω
- J = 0.5 kg·m²

**Análisis incluido:**
- Curva torque-velocidad motoring
- Frenado con Va = Vrated
- Frenado con Va = 0
- Cálculo de Rbrake para velocidad objetivo

**Interactivo:**
- Solicita si mostrar curva de magnetización
- Calcula resistencia de frenado automáticamente

## ⚙️ Modelos Simulink → Convertir a Modelica

**12 modelos Simulink:**
- `S1.M/MDL` - Generador shunt
- `S2.M/MDL` - Arranque motor DC
- `S3A.M/MDL` - Frenado plugging y dinámico
- `S3B.M/MDL` - Frenado regenerativo
- `S4.M/MDL` - Motor universal
- `S5.M/MDL` - Motor serie (montacargas)

### Conversión

```bash
simelica S1.MDL -o s1.mo
simelica S2.MDL -o s2.mo
simelica S3A.MDL -o s3a.mo
simelica S3B.MDL -o s3b.mo
simelica S4.MDL -o s4.mo
simelica S5.MDL -o s5.mo
```

### Configuración - Generador Shunt (m1.py)

```python
# Ratings
Prated = 2 * 746      # Potencia nominal (W)
Vrated = 125          # Voltaje nominal (V)
Iarated = 16          # Corriente armadura (A)
wmrated = 1750 * (2*π)/60  # Velocidad (rad/s)

# Resistencias (Ω)
Ra = 0.24             # Armadura
Rf = 111              # Campo
Rrh = 25              # Reóstato campo
Rload = 1e6           # Carga

# Inductancias (H)
Laq = 0.018           # Armadura eje q
Lf = 10               # Campo

# Mecánica
J = 0.8               # Inercia (kg·m²)

# Curva magnetización
wmo = 2000 rpm        # Velocidad medición
SHVP1 = [...]         # Voltajes
SHIP1 = [...]         # Corrientes campo
```

### Configuración - Arranque Motor (m2.py)

```python
# Ratings
Prated = 10 * 746     # Potencia 10 HP (W)
Vrated = 220          # Voltaje (V)
wmrated = 1490 * (2*π)/60  # Velocidad (rad/s)

# Parámetros
Ra = 0.3              # Resistencia armadura (Ω)
Laq = 0.012           # Inductancia armadura (H)
J = 2.5               # Inercia (kg·m²)
D = 0.0               # Amortiguamiento
```

### Configuración - Frenado (m3a.py, m3b.py)

```python
# Ratings
Prated = 2 * 746      # Potencia 2 HP (W)
Vrated = 125          # Voltaje (V)
wmrated = 1750 * (2*π)/60  # Velocidad (rad/s)

# Parámetros
Ra = 0.14             # Resistencia armadura (Ω)
Rf = 111              # Resistencia campo (Ω)
Laq = 0.018           # Inductancia armadura (H)
Lf = 10               # Inductancia campo (H)
J = 0.5               # Inercia (kg·m²)

# Frenado plugging
Rext = 6.054          # Resistencia externa (Ω)
Vbrake = -Vrated

# Frenado dinámico
Rext = 2.929          # Resistencia externa (Ω)
Vbrake = 0

# Frenado regenerativo
wraise = wmrated
wlower = -wmrated/3
```

### Configuración - Motor Universal (m4.py)

```python
# Ratings
Prated = 325          # Potencia (W)
Vrated = 120          # Voltaje RMS (V)
Iarated = 3.5         # Corriente RMS (A)
Frated = 60           # Frecuencia (Hz)
wmrated = 2800 * (2*π)/60  # Velocidad (rad/s)

# Parámetros
Ra = 0.6              # Resistencia armadura (Ω)
Rse = 0.1             # Resistencia serie (Ω)
Laq = 0.010           # Inductancia armadura (H)
Lse = 0.026           # Inductancia serie (H)
J = 0.015             # Inercia (kg·m²)

# Curva magnetización
wmo = 1500 rpm        # Velocidad medición
SEVP4 = [...]         # Voltajes
SEIP4 = [...]         # Corrientes
```

### Configuración - Motor Serie Montacargas (m5.py)

```python
# Ratings
Prated = 1500         # Potencia (W)
Vrated = 125          # Voltaje (V)
Iarated = 13.2        # Corriente (A)
wmrated = 1425 * (2*π)/60  # Velocidad (rad/s)

# Parámetros
Ra = 0.24             # Resistencia armadura (Ω)
Rse = 0.2             # Resistencia serie (Ω)
Laq = 0.018           # Inductancia armadura (H)
Lse = 0.044           # Inductancia serie (H)
J = 0.5               # Inercia (kg·m²)

# Frenado
wbrake = -400 rpm     # Velocidad frenado
Vbrake = Vrated o 0   # Voltaje durante frenado
# Rbrake se calcula automáticamente
```

## 📊 Modelo de Máquina DC

### Ecuaciones Básicas

**Voltaje de armadura:**
```
Va = Ea + Ra×Ia + La×dIa/dt
```

**Voltaje interno (back-EMF):**
```
Ea = ka×φ×wm
```

donde:
- ka: constante de armadura
- φ: flujo de campo
- wm: velocidad mecánica

**Torque electromagnético:**
```
Tem = ka×φ×Ia
```

**Ecuación mecánica:**
```
J×dwm/dt = Tem - Tload - D×wm
```

### Circuito de Campo

**Excitación shunt (paralelo):**
```
Vf = Rf×If + Lf×dIf/dt
φ = f(If)  [curva magnetización]
```

**Excitación serie:**
```
Ia = If
φ = f(Ia)
```

### Métodos de Frenado

**1. Plugging:**
- Inversión de voltaje: Va = -Vrated
- Alta corriente inicial
- Requiere resistencia limitadora
- Detención rápida

**2. Dinámico:**
- Desconexión de fuente
- Disipación en resistencia
- Menor corriente que plugging
- Frenado suave

**3. Regenerativo:**
- Ea > Va
- Flujo de potencia invertido
- Retorno energía a fuente
- Control cuatro cuadrantes

## 📈 Características por Tipo

### Generador Shunt
- Autogeneración por magnetismo residual
- Regulación de voltaje con reóstato de campo
- Característica voltaje-carga

### Motor Shunt
- Velocidad aproximadamente constante
- Torque proporcional a corriente
- Buena regulación de velocidad

### Motor Serie
- Alto torque de arranque
- Velocidad variable con carga
- Ideal para tracción y elevación
- Peligro en vacío (velocidad excesiva)

### Motor Universal
- Operación AC o DC
- Alto torque/peso
- Velocidad alta
- Aplicaciones: herramientas portátiles

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| M1.M            | m1.py          | Generador shunt |
| M2.M            | m2.py          | Arranque motor DC |
| M3A.M           | m3a.py         | Frenado plugging/dinámico |
| M3B.M           | m3b.py         | Frenado regenerativo |
| M4.M            | m4.py          | Motor universal |
| M5.M            | m5.py          | Motor serie montacargas |
| S1.M/MDL        | → Modelica     | Simulación generador |
| S2.M/MDL        | → Modelica     | Simulación arranque |
| S3A.M/MDL       | → Modelica     | Simulación frenado A |
| S3B.M/MDL       | → Modelica     | Simulación frenado B |
| S4.M/MDL        | → Modelica     | Simulación universal |
| S5.M/MDL        | → Modelica     | Simulación serie |

---

Ver [README principal](../README.md) para más información.
