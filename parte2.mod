# ==============================================================================
# MODELO PARTE 2: PLANIFICACIÓN INTEGRADA CON RECURSOS HUMANOS
# Tarea Computacional 1 - Optimización
# Universidad Diego Portales - Escuela de Ingeniería Industrial
# ==============================================================================

# CONJUNTOS
set PERIODOS ordered;
set PRODUCTOS;

# PARÁMETROS PRODUCTIVOS
param Demanda{PRODUCTOS, PERIODOS} >= 0;
param Utilidad{PRODUCTOS, PERIODOS} >= 0;
param HorasMaq{PRODUCTOS, PERIODOS} >= 0;
param CapacidadMaq{PERIODOS} >= 0;
param CostoInv{PERIODOS} >= 0;
param InvSeg{PERIODOS} >= 0;
param InvMax{PERIODOS} >= 0;
param InvInicial{PRODUCTOS} >= 0;

# PARÁMETROS DE RECURSOS HUMANOS
param CostoReg{PERIODOS} >= 0;      # Costo por hh en horario regular ($/hh)
param CostoExt{PERIODOS} >= 0;      # Costo por hh de horas extra ($/hh)
param CostoContr{PERIODOS} >= 0;    # Costo de contratar 1 hh ($/hh)
param CostoDesp{PERIODOS} >= 0;     # Costo de despedir 1 hh ($/hh)
param RequerimientoHH >= 0;         # Horas hombre necesarias por unidad (3 hh)
param DotacionInicial >= 0;         # Dotación inicial de fuerza laboral (300 hh)

# VARIABLES DE DECISIÓN PRODUCTIVAS
var X{PRODUCTOS, PERIODOS} >= 0;    # Unidades a producir
var V{PRODUCTOS, PERIODOS} >= 0;    # Unidades a vender
var I{PRODUCTOS, PERIODOS} >= 0;    # Inventario final

# VARIABLES DE DECISIÓN DE RRHH
var W{PERIODOS} >= 0;               # Dotación de fuerza laboral disponible (hh)
var H{PERIODOS} >= 0;               # Horas hombre contratadas
var F{PERIODOS} >= 0;               # Horas hombre despedidas
var O{PERIODOS} >= 0;               # Horas extra utilizadas

# FUNCIÓN OBJETIVO: Maximizar beneficio neto total (Ingresos - Costos Inventario - Costos RRHH)
maximize Beneficio_Neto:
    sum {p in PRODUCTOS, t in PERIODOS} Utilidad[p,t] * V[p,t]
    - sum {p in PRODUCTOS, t in PERIODOS} CostoInv[t] * I[p,t]
    - sum {t in PERIODOS} (
        CostoReg[t] * W[t] + 
        CostoExt[t] * O[t] + 
        CostoContr[t] * H[t] + 
        CostoDesp[t] * F[t]
    );

# RESTRICCIONES PRODUCTIVAS
# 1. Balance de Inventario
subject to Balance_Inv {p in PRODUCTOS, t in PERIODOS}:
    I[p,t] = (if ord(t) == 1 then InvInicial[p] else I[p, prev(t)]) + X[p,t] - V[p,t];

# 2. Cota de Demanda Máxima
subject to Cota_Demanda {p in PRODUCTOS, t in PERIODOS}:
    V[p,t] <= Demanda[p,t];

# 3. Capacidad de Maquinaria
subject to Capacidad_Maquinaria {t in PERIODOS}:
    sum {p in PRODUCTOS} HorasMaq[p,t] * X[p,t] <= CapacidadMaq[t];

# 4. Capacidad Máxima de Bodega Compartida
subject to Capacidad_Bodega {t in PERIODOS}:
    sum {p in PRODUCTOS} I[p,t] <= InvMax[t];

# 5. Inventario de Seguridad Compartido en Bodega
subject to Inventario_Seguridad {t in PERIODOS}:
    sum {p in PRODUCTOS} I[p,t] >= InvSeg[t];

# RESTRICCIONES DE RECURSOS HUMANOS
# 6. Balance de Fuerza Laboral
subject to Balance_Dotacion {t in PERIODOS}:
    W[t] = (if ord(t) == 1 then DotacionInicial else W[prev(t)]) + H[t] - F[t];

# 7. Requerimiento de Mano de Obra para Producción
subject to Requerimiento_Mano_Obra {t in PERIODOS}:
    RequerimientoHH * (sum {p in PRODUCTOS} X[p,t]) <= W[t] + O[t];
