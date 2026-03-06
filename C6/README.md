# Capítulo 6: Máquinas de Inducción

Análisis de máquinas de inducción trifásicas y monofásicas.

## 📄 Scripts Python Disponibles

### Parámetros de Máquinas
- **p1hp.py** - Motor inducción trifásico 1 HP
- **p20hp.py** - Motor inducción trifásico 20 HP
- **psph.py** - Motor inducción monofásico 1/4 HP

### Scripts de Análisis
- **m1.py** - Setup Proyectos 1 y 3, funciones de ploteo
- **m2fig.py** - Curvas torque-velocidad (genera plots automáticamente)
- **m4.py** - Linealización de máquina
- **m4stp.py** - Respuesta al escalón
- **m4ustp.py** - Respuesta unitaria (scipy.signal)
- **m5.py** - Estudio de voltaje neutro
- **m6.py** - Análisis estado estacionario motor monofásico

## 🚀 Uso

### Ver Parámetros de Máquina

```bash
python3 p20hp.py    # Parámetros 20 HP
```

**Parámetros incluidos:**
- Ratings (potencia, voltaje, corriente, velocidad)
- Resistencias e inductancias
- Inercia, polos, frecuencia

### Proyecto 2: Curvas Torque-Velocidad

```bash
python3 m2fig.py
```

Genera automáticamente curvas T-ω para diferentes condiciones.

### Proyecto 4: Linealización y Respuesta

```bash
python3 m4.py       # Setup linealización
python3 m4stp.py    # Respuesta escalón
python3 m4ustp.py   # Respuesta unitaria
```

### Proyecto 6: Motor Monofásico

```bash
python3 m6.py
```

Análisis completo estado estacionario con gráficas automáticas.

## ⚙️ Modelos Simulink → Convertir a Modelica

**12 modelos Simulink:**
- `S1.M/MDL` - Máquina en marco estacionario
- `S4EIG.M/MDL` - Marco síncrono para análisis eigenvalores
- `S4STP.M/MDL` - Respuesta al escalón
- `S5A.M/MDL` - Con voltaje neutro (variante A)
- `S5B.M/MDL` - Con voltaje neutro (variante B)
- `S6.M/MDL` - Motor monofásico con conmutación de capacitor

### Conversión

```bash
simelica S1.MDL -o s1.mo
simelica S4EIG.MDL -o s4eig.mo
simelica S4STP.MDL -o s4stp.mo
simelica S5A.MDL -o s5a.mo
simelica S5B.MDL -o s5b.mo
simelica S6.MDL -o s6.mo
```

### Configuración - Motor 20 HP (p20hp.py)

```python
# Ratings
Vrated = 460      # Voltaje línea (V)
Srated = 20e3/746 # Potencia (W)
n_rpm = 1746      # Velocidad nominal (rpm)

# Parámetros circuito equivalente
rs = 0.294        # Resistencia estator (Ω)
rr = 0.156        # Resistencia rotor (Ω)
Xls = 0.503       # Reactancia fuga estator (Ω)
Xlr = 0.229       # Reactancia fuga rotor (Ω)
Xm = 13.25        # Reactancia magnetización (Ω)

# Mecánica
J = 1.662         # Inercia (kg·m²)
p = 2             # Pares de polos
```

## 📊 Modelos en Marco de Referencia

### Marco Estacionario (S1)
Variables: ψqs, ψds, ψ0s, ψqr, ψdr

**Ecuaciones:**
```
v_qs = rs×i_qs + dψ_qs/dt
v_ds = rs×i_ds + dψ_ds/dt
v_qr = rr×i_qr + dψ_qr/dt - ωr×ψ_dr
v_dr = rr×i_dr + dψ_dr/dt + ωr×ψ_qr
```

### Marco Síncrono (S4EIG, S4STP)
Variables: ψqe, ψde, ψ0e, ψqr, ψdr

**Rotación:** θe = ωe×t

## 📈 Gráficas Generadas

### m2fig.py
- Curvas torque-velocidad para diferentes voltajes/frecuencias
- Múltiples condiciones de operación

### m6.py
- Análisis completo motor monofásico
- Curvas características en estado estacionario

### m4ustp.py
- Respuesta temporal de corrientes y torque
- Análisis transitorio

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| P1HP.M          | p1hp.py        | Parámetros 1 HP |
| P20HP.M         | p20hp.py       | Parámetros 20 HP |
| PSPH.M          | psph.py        | Parámetros 1/4 HP |
| M1.M            | m1.py          | Setup proyectos |
| M2FIG.M         | m2fig.py       | Curvas T-ω |
| M4-M6.M         | m4-m6.py       | Análisis varios |
| S1-S6.M/MDL     | → Modelica     | Modelos dinámicos |

---

Ver [README principal](../README.md) para más información.
