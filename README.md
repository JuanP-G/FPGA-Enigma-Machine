<div align="center">

# 🔐 FPGA Enigma Machine
### Implementación Hardware VHDL sobre Artix-7

![Badge VHDL](https://img.shields.io/badge/Language-VHDL-blue)
![Badge FPGA](https://img.shields.io/badge/Hardware-Basys3-red)
![Badge Tool](https://img.shields.io/badge/Tool-Vivado-green)

<br>

**Una reconstrucción digital de la criptografía electromecánica de la Segunda Guerra Mundial.** Hardware dedicado configurado para emular rotores, reflectores y aritmética modular en tiempo real.

[Explorar RTL](#arquitectura) • [Manual de Uso](#manual) • [Ver Autores](#creditos)

<img src="assets/concept_datapath.png" alt="Concepto Datapath" width="80%">
<br>
<em>Figura 1: Diseño conceptual original del flujo de datos (Datapath).</em>

</div>

---

## <a name="resumen"></a>📋 Resumen del Proyecto

Este proyecto implementa una **Máquina Enigma** funcional utilizando lógica digital pura. El sistema ha sido diseñado separando estrictamente la ruta de datos (Datapath) de la lógica de control (FSM), permitiendo un cifrado polialfabético en tiempo real.

### Características Principales
* ⚙️ **Mecánica Virtual:** Simulación del movimiento físico de los rotores (trinquete).
* 🧮 **Aritmética Modular:** ALU dedicada para operaciones `MOD 26`.
* 🛡️ **Fiabilidad:** Debouncing hardware de 50ms para pulsadores.
* 📟 **Visualización:** Salida multiplexada en 7-segmentos.

---

## <a name="arquitectura"></a>🏗️ Arquitectura Hardware

El diseño se ha sintetizado en una FPGA **Xilinx Artix-7** (Basys 3).

### 1. Jerarquía Top-Level
Integra la Unidad de Control, el Datapath y los controladores de periféricos.
<img src="assets/rtl_top.png" alt="RTL Top Level" width="100%">

### 2. Unidad de Control
Una máquina de estados finitos (Moore) gestiona la secuencia de cifrado.
* **Estados S2-S3:** Cálculo matemático de la letra.
* **Estados S4-S6:** Lógica mecánica (decisión de giro de rotores).

<img src="assets/rtl_fsm.png" alt="RTL FSM" width="100%">

### 3. ALU Modular (El Corazón)
Sustituye el cableado físico de los rotores mediante sumas y restas de offsets.
> `Salida = (Entrada + Offset_Rotor) mod 26`

<img src="assets/rtl_alu.png" alt="RTL ALU" width="100%">

---

## <a name="manual"></a>🎮 Manual de Operación

A continuación se muestra el mapa de interfaz de la placa. **Es obligatorio realizar un RESET al encender la FPGA.**

> 📸 **Nota:** Esta guía visual corresponde a la configuración física en la placa Basys 3.

<div align="center">
    <img src="assets/manual_interface.png" alt="Mapa de Interfaz Física" width="90%">
</div>

### Tabla de Referencia Rápida

| Componente | Función | Detalles |
| :--- | :--- | :--- |
| **A. Displays** | Visualización | **[ Rotores \| Entrada \| Salida ]** |
| **B. Botones** | Control | `Centro`: Reset Total / `Derecho`: Cifrar Letra |
| **C. Switches [0-4]** | Entrada Datos | Selección de letra en binario (Ver tabla abajo). |
| **D. Switches [13-14]** | Config. Rotores | Selección de rodillo/tabla interna. |
| **E. Switch [15]** | Modo | ⬇️ Cifrar / ⬆️ Descifrar |

<details>
<summary><strong>🔻 Desplegar Tabla de Códigos Binarios (A-Z)</strong></summary>
<br>

| Letra | Binario | Letra | Binario | Letra | Binario |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **A** | 00000 | **J** | 01001 | **S** | 10010 |
| **B** | 00001 | **K** | 01010 | **T** | 10011 |
| **C** | 00010 | **L** | 01011 | **U** | 10100 |
| **D** | 00011 | **M** | 01100 | **V** | 10101 |
| **E** | 00100 | **N** | 01101 | **W** | 10110 |
| **F** | 00101 | **O** | 01110 | **X** | 10111 |
| **G** | 00110 | **P** | 01111 | **Y** | 11000 |
| **H** | 00111 | **Q** | 10000 | **Z** | 11001 |
| **I** | 01000 | **R** | 10001 | | |

</details>

---

## <a name="creditos"></a>👥 Créditos

Proyecto desarrollado para la asignatura de **Ingeniería de Computadores**.

<div align="center">

| [**Juan Pastrana García**](https://github.com/GustoffotsuG) | [**Omar Ouahri Vigil**](https://github.com/theomaaroo) |
| :---: | :---: |
| Diseño Datapath & RTL | Lógica de Control & FSM |

</div>
