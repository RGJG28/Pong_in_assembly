# Pong in assembly
Videojuego pong escrito en lenguaje ensamblador para arquitectura x86(32 bits)

## Instalación de dependencias
- [DOSBox](https://www.dosbox.com/download.php?main=1) 
- Tasm
1. Debera descargar e instalar el programa DOSBox
2. Descargar la carpeta Tasm y moverla a la raiz del disco c:
3. 
## Instrucciones
1. Ejecutar el programa DOSBox, cambiar el teclado y montar una unidad
```bash
keyb la
mount c c:\tasm
c:
```
2. Ejecutar las siguientes lineas
```bash
tasm \pong.asm
tlink pong.obj
pong.exe
```
3. Seleccionar el modo de juego preferido

