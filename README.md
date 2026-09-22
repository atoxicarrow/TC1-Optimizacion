# Tarea Computacional 1 - Optimización
**Universidad Diego Portales | Escuela de Ingeniería Industrial**

Repositorio privado que contiene la resolución completa de la **Tarea Computacional 1 (TC1)** de Optimización, incluyendo informe ejecutivo en formato PDF, planilla Excel con Solver, modelos y scripts en AMPL, y gráficos de soporte.

---

## Contenido del Repositorio

- **`Informe_TC1_Optimizacion.pdf`**: Informe ejecutivo formal (6 páginas) presentado al Gerente de Operaciones con resumen ejecutivo, formulación matemática completa, análisis de resultados, respuestas a preguntas planteadas (b, d, h, i, j, k, l), supuestos y sugerencias metodológicas.
- **`TC1_Solucion_Optimizacion.xlsx`**: Planilla Excel con el modelamiento de ambas partes:
  - *Parte 1 - Modelo Base*: Parámetros, variables de decisión, balance de inventario, restricciones de maquinaria y bodega, función objetivo y configuración lista para Solver.
  - *Parte 2 - Con RRHH*: Extensión con dotación regular, contratación, despido, sobretiempo y costos de recursos humanos.
  - *Comparación y Análisis*: Cuadro comparativo financiero y operativo de escenarios.
- **Modelos AMPL**:
  - `parte1.mod`, `parte1.dat`, `parte1.run`: Modelo productivo base sin RRHH.
  - `parte2.mod`, `parte2.dat`, `parte2.run`: Modelo integrado con gestión de recursos humanos.
- **Gráficos Generados (300 DPI)**:
  - `fig1_comparacion_financiera.png`: Ingresos, costos y beneficio neto por escenario.
  - `fig2_produccion_demanda.png`: Planes de producción mensual vs demanda máxima.
  - `fig3_inventario_bodega.png`: Inventario mensual vs stock de seguridad y capacidad máxima de bodega.
  - `fig4_recursos_humanos.png`: Dotación, sobretiempo, contrataciones y despidos.
- **Archivos Base**:
  - `Tarea_computacional_1.pdf`: Pauta e instrucciones de la tarea.
  - `TC1 tablas.xlsx`: Datos originales provistos por la cátedra.

---

## Instrucciones de Ejecución

### 1. Modelos AMPL
Para ejecutar los modelos en AMPL, abrir la consola de AMPL en este directorio y correr:
```ampl
# Parte 1
include parte1.run;

# Parte 2
include parte2.run;
```

### 2. Planilla Excel y Solver
1. Abrir `TC1_Solucion_Optimizacion.xlsx`.
2. Ir a la pestaña `Parte 1 - Modelo Base` o `Parte 2 - Con RRHH`.
3. Abrir la herramienta **Solver** en la pestaña *Datos*.
4. Verificar que el método de resolución seleccionado sea **Simplex LP**.
5. Presionar **Resolver**.
