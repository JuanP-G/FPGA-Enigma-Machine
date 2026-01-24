# MANUAL DE OPERACIÓN: Enigma FPGA (Basys 3)

**Versión:** 1.0  
**Plataforma:** Digilent Basys 3 (Artix-7)  
**Autores:** Juan Pastrana García & Omar Ouahri Vigil

---

## 1. Mapa de Interfaz Física
Consulta este mapa antes de operar. La placa se divide en tres zonas funcionales:

| Zona | Componentes | Función |
| :--- | :--- | :--- |
| **Configuración** | Switches 13, 14, 15 | Ajustes de la máquina (Rotores y Modo). |
| **Datos** | Switches 0-4 | Entrada de la letra a procesar. |
| **Control** | Botones Centro y Derecho | Reset y Ejecución. |

### [cite_start]Detalle de Switches (Entradas) [cite: 260]
* **SW[4:0] (Derecha):** Selección de letra en binario (A=0 ... Z=25).
    * *Ejemplo:* `00000` = A, `00001` = B.
* **SW[14:13] (Centro-Izq):** Selección de Rodillo (Tabla de sustitución). Cambiar esto altera todo el cifrado.
* **SW[15] (Izquierda):** Modo de Operación.
    * ⬇️ **Abajo (0):** Cifrar.
    * ⬆️ **Arriba (1):** Descifrar.

### [cite_start]Detalle de Botones (Acción) [cite: 264]
* **BTN-C (Centro):** `RESET`. Obligatorio al encender. Pone los contadores a 0.
* **BTN-R (Derecha):** `CIFRAR`. Ejecuta la transformación y mueve los mecanismos.

---

## 2. Guía Paso a Paso

### Paso 1: Inicialización
1.  Conecta la placa Basys 3 y cárga el bitstream.
2.  Pulsa **BTN-C (Reset)**.
3.  Verifica el Display: Debe mostrar `00 00` en los dígitos izquierdos (Rotores en posición inicial).

### Paso 2: Configuración
1.  Selecciona el **Modo Cifrado** (SW15 abajo).
2.  Elige una configuración de rotores con SW[14:13] (por ejemplo, ambos abajo para Rotor I).

### Paso 3: Proceso de Cifrado
1.  Introduce la letra "A" (Todos los SW[4:0] abajo).
2.  [cite_start]Mira el **Dígito 1** del display: verás la "A" (eco de entrada)[cite: 220].
3.  Pulsa **BTN-R**.
4.  [cite_start]Mira el **Dígito 0** del display: verás la letra cifrada resultante[cite: 219].
5.  Observa los **Dígitos 3-2**: Los contadores han avanzado (el mecanismo ha girado).

### Paso 4: Descifrado (Verificación)
1.  Anota la letra cifrada y la posición de los rotores.
2.  Pulsa **RESET** (para volver al estado inicial de rotores).
3.  Sube **SW15** (Modo Descifrar).
4.  Pon en SW[4:0] la letra cifrada que obtuviste en el paso 3.
5.  Pulsa **BTN-R**.
6.  Resultado: En el display derecho debería aparecer la "A" original.

---

## 3. Solución de Problemas Frecuentes

* [cite_start]**El display parpadea o se ve tenue:** Es normal, se debe al refresco del multiplexado a alta velocidad[cite: 223].
* **La salida no cambia al mover los switches:** El sistema es síncrono. Debes pulsar **BTN-R** para procesar el cambio.
* **Las letras no coinciden con un simulador web:** Nuestra implementación usa tablas ROM simplificadas y aritmética modular propia, no es una réplica 1:1 de la Enigma M3 militar (sin *Steckerbrett*).
