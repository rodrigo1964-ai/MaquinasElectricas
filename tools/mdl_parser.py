"""
Parser para archivos Simulink .MDL
Extrae bloques, conexiones y parámetros para conversión a Python/Modelica
"""
import re
from typing import Dict, List, Tuple

class MDLParser:
    """Parser básico para archivos Simulink .MDL"""

    def __init__(self, mdl_file: str):
        self.mdl_file = mdl_file
        self.model_name = ""
        self.solver_config = {}
        self.blocks = []
        self.connections = []

    def parse(self):
        """Parse completo del archivo MDL"""
        with open(self.mdl_file, 'r') as f:
            content = f.read()

        self._parse_model_config(content)
        self._parse_blocks(content)
        self._parse_connections(content)

        return {
            'model_name': self.model_name,
            'solver': self.solver_config,
            'blocks': self.blocks,
            'connections': self.connections
        }

    def _parse_model_config(self, content: str):
        """Extrae configuración del modelo"""
        # Nombre del modelo
        match = re.search(r'Name\s+"([^"]+)"', content)
        if match:
            self.model_name = match.group(1)

        # Configuración del solver
        patterns = {
            'StopTime': r'StopTime\s+"([^"]+)"',
            'Solver': r'Solver\s+(\w+)',
            'RelTol': r'RelTol\s+"([^"]+)"',
            'AbsTol': r'AbsTol\s+"([^"]+)"',
            'MaxStep': r'MaxStep\s+"([^"]+)"',
        }

        for key, pattern in patterns.items():
            match = re.search(pattern, content)
            if match:
                self.solver_config[key] = match.group(1)

    def _parse_blocks(self, content: str):
        """Extrae bloques del sistema"""
        # Patrón para encontrar bloques
        block_pattern = r'Block\s*{([^}]+)}'

        for match in re.finditer(block_pattern, content, re.DOTALL):
            block_text = match.group(1)
            block = self._parse_single_block(block_text)
            if block:
                self.blocks.append(block)

    def _parse_single_block(self, block_text: str) -> Dict:
        """Parse de un bloque individual"""
        block = {}

        # BlockType
        match = re.search(r'BlockType\s+(\w+)', block_text)
        if match:
            block['type'] = match.group(1)

        # Name
        match = re.search(r'Name\s+"([^"]+)"', block_text)
        if match:
            block['name'] = match.group(1)

        # Position
        match = re.search(r'Position\s+\[([^\]]+)\]', block_text)
        if match:
            block['position'] = match.group(1)

        # Parámetros específicos por tipo
        if block.get('type') == 'Gain':
            match = re.search(r'Gain\s+"([^"]+)"', block_text)
            if match:
                block['gain'] = match.group(1)

        elif block.get('type') == 'Integrator':
            match = re.search(r'InitialCondition\s+"([^"]+)"', block_text)
            if match:
                block['initial'] = match.group(1)

        return block if block else None

    def _parse_connections(self, content: str):
        """Extrae conexiones entre bloques"""
        # Patrón para líneas de conexión
        line_pattern = r'Line\s*{([^}]+)}'

        for match in re.finditer(line_pattern, content, re.DOTALL):
            line_text = match.group(1)

            # Source
            src_match = re.search(r'SrcBlock\s+"([^"]+)"', line_text)
            # Destination
            dst_match = re.search(r'DstBlock\s+"([^"]+)"', line_text)

            if src_match and dst_match:
                self.connections.append({
                    'from': src_match.group(1),
                    'to': dst_match.group(1)
                })

    def to_python_scipy(self) -> str:
        """Genera código Python con scipy.integrate"""
        code = f'''"""
Conversión automática de {self.model_name}.mdl a Python
Generado por mdl_parser.py
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Configuración del solver
t_stop = {self.solver_config.get('StopTime', '1.0')}
rtol = {self.solver_config.get('RelTol', '1e-6')}
atol = {self.solver_config.get('AbsTol', '1e-6')}

def model_equations(t, y):
    """
    Sistema de ecuaciones diferenciales
    Bloques encontrados: {len(self.blocks)}
    """
    # TODO: Implementar ecuaciones basadas en:
'''

        for block in self.blocks:
            code += f"    # {block.get('type', 'Unknown')}: {block.get('name', 'unnamed')}\n"

        code += '''
    dydt = []  # Implementar derivadas
    return dydt

# Condiciones iniciales
y0 = []  # Definir según bloques Integrator

# Resolver
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol)

# Graficar
plt.figure()
plt.plot(sol.t, sol.y.T)
plt.xlabel('Time (s)')
plt.ylabel('States')
plt.title(f'{self.model_name} - Simulation Results')
plt.grid(True)
plt.show()
'''
        return code

    def to_modelica(self) -> str:
        """Genera código Modelica básico"""
        code = f'''model {self.model_name}
  "Conversión automática de {self.model_name}.mdl"

  // Parámetros
  parameter Real t_stop = {self.solver_config.get('StopTime', '1.0')};

  // Variables de estado
'''

        for block in self.blocks:
            if block.get('type') == 'Integrator':
                name = block.get('name', 'state').replace(' ', '_')
                initial = block.get('initial', '0')
                code += f"  Real {name}(start={initial});\n"

        code += '''

equation
  // TODO: Implementar ecuaciones basadas en el diagrama de bloques

annotation(experiment(StopTime=t_stop));
end {self.model_name};
'''
        return code

    def print_summary(self):
        """Imprime resumen del modelo"""
        print(f"\n{'='*60}")
        print(f"Modelo: {self.model_name}")
        print(f"{'='*60}")
        print(f"\n📊 Configuración del Solver:")
        for key, value in self.solver_config.items():
            print(f"  {key}: {value}")

        print(f"\n🔧 Bloques ({len(self.blocks)}):")
        block_types = {}
        for block in self.blocks:
            btype = block.get('type', 'Unknown')
            block_types[btype] = block_types.get(btype, 0) + 1

        for btype, count in sorted(block_types.items()):
            print(f"  {btype}: {count}")

        print(f"\n🔗 Conexiones: {len(self.connections)}")
        for conn in self.connections[:5]:  # Primeras 5
            print(f"  {conn['from']} → {conn['to']}")
        if len(self.connections) > 5:
            print(f"  ... y {len(self.connections) - 5} más")


# Función de ayuda
def convert_mdl(mdl_file: str, output_format='python'):
    """
    Convierte archivo .MDL a Python o Modelica

    Args:
        mdl_file: Ruta al archivo .MDL
        output_format: 'python' o 'modelica'
    """
    parser = MDLParser(mdl_file)
    model_info = parser.parse()

    parser.print_summary()

    if output_format == 'python':
        code = parser.to_python_scipy()
        output_file = mdl_file.replace('.MDL', '.py').replace('.mdl', '.py')
    else:
        code = parser.to_modelica()
        output_file = mdl_file.replace('.MDL', '.mo').replace('.mdl', '.mo')

    with open(output_file, 'w') as f:
        f.write(code)

    print(f"\n✅ Código generado: {output_file}")
    return output_file


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Uso: python mdl_parser.py archivo.mdl [python|modelica]")
        sys.exit(1)

    mdl_file = sys.argv[1]
    output_format = sys.argv[2] if len(sys.argv) > 2 else 'python'

    convert_mdl(mdl_file, output_format)
