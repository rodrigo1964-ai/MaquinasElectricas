# Capítulo 9: Control de Máquinas de Inducción

Control de motores de inducción mediante técnicas V/f y control orientado al campo (FOC).

## 📄 Scripts Python Disponibles

### Parámetros de Máquina
- **p20hp.py** - Motor inducción trifásico 20 HP

### Scripts de Control
- **m1c.py** - Control V/f en lazo cerrado con retroalimentación de velocidad
- **m1o.py** - Control V/f en lazo abierto sin retroalimentación
- **m3.py** - Control orientado al campo (Field-Oriented Control)

## 🚀 Uso

### Ver Parámetros de Máquina

```bash
python3 p20hp.py
```

**Parámetros incluidos:**
- Ratings (potencia, voltaje, corriente, velocidad)
- Resistencias e inductancias (estator y rotor)
- Inercia, polos, frecuencia
- Cantidades base y factor de torque

### Proyecto 1: Control V/f en Lazo Cerrado

```bash
python3 m1c.py
```

**Características:**
- Control de velocidad con retroalimentación
- Generación automática de curva V/f (volts por hertz)
- Arranque desde reposo con carga variable
- Grafica características de operación (torque, potencia, corriente, eficiencia)

**Simulación configurada:**
- Inicio desde velocidad cero
- Rampa de velocidad a referencia en 0.5 s
- Ciclos de carga: 0 → Trated → Trated/2 → Trated → 0
- Duración: 2 segundos

### Proyecto 1: Control V/f en Lazo Abierto

```bash
python3 m1o.py
```

**Características:**
- Control V/f sin retroalimentación de velocidad
- Misma tabla V/f que versión de lazo cerrado
- Análisis de características operacionales
- Respuesta a cambios de carga

### Proyecto 3: Control Orientado al Campo

```bash
python3 m3.py
```

**Características:**
- Field-Oriented Control (FOC) completo
- Desacoplamiento de flujo y torque
- Control de velocidad y flujo rotor independientes
- Dos configuraciones de simulación:
  - Ciclo de carga a velocidad constante
  - Ciclo de velocidad sin carga

**Configuración FOC:**
- Cálculo de flujo rotor en vacío (λdr)
- Tabla lookup velocidad-flujo para región de debilitamiento de campo
- Control independiente de ejes d-q

## ⚙️ Modelos Simulink → Convertir a Modelica

**10 modelos Simulink disponibles:**
- `S1C.M/MDL` - Control V/f en lazo cerrado
- `S1O.M/MDL` - Control V/f en lazo abierto
- `S2C.M/MDL` - Variante 2 de control en lazo cerrado
- `S2O.M/MDL` - Variante 2 de control en lazo abierto
- `S3.M/MDL` - Control orientado al campo (FOC)

### Conversión con Simelica

```bash
# Convertir modelos de control V/f
simelica S1C.MDL -o s1c.mo    # Lazo cerrado
simelica S1O.MDL -o s1o.mo    # Lazo abierto

# Convertir modelos variante 2
simelica S2C.MDL -o s2c.mo    # Lazo cerrado V2
simelica S2O.MDL -o s2o.mo    # Lazo abierto V2

# Convertir control orientado al campo
simelica S3.MDL -o s3.mo      # FOC
```

### Uso en OpenModelica

1. Abrir en OMEdit: `OMEdit s1c.mo`
2. Configurar parámetros desde `p20hp.py`:
   - Parámetros eléctricos (rs, rpr, xls, xplr, xm)
   - Parámetros mecánicos (J, P)
   - Cantidades base (Vrated, Sb, wb)
3. Simular con tstop = 2.0 s
4. Exportar resultados a Python para análisis

## 📊 Configuración - Motor 20 HP (p20hp.py)

```python
# Ratings
Sb = 20 * 746        # Potencia nominal (W)
Vrated = 220         # Voltaje línea-línea (V)
pf = 0.853           # Factor de potencia nominal
P = 4                # Número de polos
frated = 60          # Frecuencia nominal (Hz)

# Punto de operación
srated = 0.0287      # Deslizamiento nominal
Nrated = 1748.3      # Velocidad nominal (rpm)
Trated = 81.7        # Torque nominal (Nm)
iasb = 49.68         # Corriente fase nominal (A rms)

# Parámetros circuito equivalente (Ω)
rs = 0.1062          # Resistencia estator
xls = 0.2145         # Reactancia fuga estator
xplr = 0.2145        # Reactancia fuga rotor
xm = 5.8339          # Reactancia magnetización
rpr = 0.0764         # Resistencia rotor referida

# Mecánica
J = 2.8              # Inercia rotor (kg·m²)
H = 2.6              # Constante inercia (s)
```

## 🎛️ Técnicas de Control

### Control V/f (Volts por Hertz)

**Principio:** Mantener flujo constante variando V y f proporcionalmente.

**Ecuación básica:**
```
V/f = constante = E/we = λ
```

**Ventajas:**
- Simple implementación
- Control escalar (sin transformaciones)
- Adecuado para aplicaciones de velocidad variable

**Limitaciones:**
- Respuesta dinámica limitada
- Acoplamiento entre flujo y torque

**Implementación:**
- Tabla lookup V vs f precalculada
- Compensación de caída resistiva a bajas frecuencias
- Lazo cerrado: control PI de velocidad
- Lazo abierto: frecuencia directa desde referencia

### Control Orientado al Campo (FOC)

**Principio:** Desacoplar control de flujo y torque mediante transformación al marco de referencia síncrono.

**Transformaciones:**
```
abc → αβ (Clarke)
αβ → dq (Park)
```

**Variables controladas:**
- **Eje d:** Control de flujo rotor (isd, λdr)
- **Eje q:** Control de torque (isq, Te)

**Ecuación de torque:**
```
Te = (3/2) × (P/2) × λdr × isq
```

**Ventajas:**
- Respuesta dinámica rápida
- Control independiente de flujo y torque
- Alto rendimiento en todo el rango de operación
- Debilitamiento de campo para alta velocidad

**Requerimientos:**
- Sensores de posición/velocidad
- Estimador o medición de flujo rotor
- Procesamiento en tiempo real (DSP/microcontrolador)

## 📈 Características Generadas

### m1c.py / m1o.py
- Curvas torque-velocidad
- Potencia desarrollada vs velocidad
- Corriente de estator vs velocidad
- Eficiencia vs velocidad
- Curva V/f característica del motor

### m3.py
- Características de operación completas
- Tabla lookup velocidad-flujo para FOC
- Perfiles de simulación para:
  - Ciclo de carga a velocidad constante
  - Ciclo de velocidad sin carga

## 🔧 Condiciones de Simulación

### Condiciones Iniciales (todas configuraciones)
```python
Psiqso = 0      # Flujo eje q estator
Psidso = 0      # Flujo eje d estator
Psipqro = 0     # Flujo eje q rotor
Psipdro = 0     # Flujo eje d rotor
wrbywbo = 0     # Velocidad rotor (p.u.)
```

### Perfil de Velocidad (m1c, m1o, m3 - Estudio 1)
```python
time_wref = [0, 0.5, 4]
speed_wref = [0, 1, 1]     # En p.u. (1 = velocidad base)
```

### Perfil de Carga (m1c, m1o, m3 - Estudio 1)
```python
time_tmech = [0, 0.75, 0.75, 1.0, 1.0, 1.25, 1.25, 1.5, 1.5, 2]
tmech_tmech = [0, 0, -Trated, -Trated, -Trated/2,
               -Trated/2, -Trated, -Trated, 0, 0]
```

### Perfil Velocidad Variable (m3 - Estudio 2)
```python
time_wref = [0, 0.25, 0.5, 1.0, 1.25, 1.5]
speed_wref = [0, wbm/2, wbm/2, -wbm/2, -wbm/2, 0]
tmech = 0      # Sin carga
```

## 🔗 Archivos Relacionados

| Archivo Original | Archivo Python | Descripción |
|-----------------|----------------|-------------|
| P20HP.M         | p20hp.py       | Parámetros 20 HP |
| M1C.M           | m1c.py         | Control V/f lazo cerrado |
| M1O.M           | m1o.py         | Control V/f lazo abierto |
| M3.M            | m3.py          | Control FOC |
| S1C.M/MDL       | → Modelica     | Modelo lazo cerrado |
| S1O.M/MDL       | → Modelica     | Modelo lazo abierto |
| S2C.M/MDL       | → Modelica     | Modelo V2 lazo cerrado |
| S2O.M/MDL       | → Modelica     | Modelo V2 lazo abierto |
| S3.M/MDL        | → Modelica     | Modelo FOC |

---

Ver [README principal](../README.md) para más información.
