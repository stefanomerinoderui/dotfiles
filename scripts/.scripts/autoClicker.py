#!/home/stefano/Projects/.venv/bin/python

import time
import threading
from pynput.mouse import Button, Controller
from pynput.keyboard import Listener, KeyCode

# Configuración
DELAY = 0.05  # Intervalo entre clics en segundos (0.05 = ~20 clics por segundo)
BUTTON = Button.left  # Botón del ratón: Button.left, Button.right o Button.middle
TOGGLE_KEY = KeyCode.from_char('f8')  # Tecla para activar/desactivar (F8)

# Variables de control
mouse = Controller()
running = False

def clicker():
    """ Bucle que realiza los clics mientras 'running' sea True """
    while True:
        if running:
            mouse.click(BUTTON)
            time.sleep(DELAY)
        else:
            time.sleep(0.1)

def toggle_event(key):
    """ Detecta la tecla de activación/desactivación """
    global running
    # Verificar si es la tecla asignada (F8 o KeyCode equivalente)
    if key == TOGGLE_KEY or (hasattr(key, 'name') and key.name == 'f8'):
        running = not running
        estado = "ACTIVADO" if running else "DESACTIVADO"
        print(f"[Autoclicker] -> {estado}")

def main():
    # Crear e iniciar el hilo secundario para los clics
    click_thread = threading.Thread(target=clicker, daemon=True)
    click_thread.start()

    print("==========================================")
    print("      Autoclicker para Wayland / Linux   ")
    print("==========================================")
    print(f" Presiona [ F8 ] para activar o pausar.")
    print(f" Tasa de clic: {DELAY}s de espera por clic.")
    print(" Presiona Ctrl + C en la terminal para salir.")
    print("------------------------------------------")

    # Escuchar eventos de teclado globales
    with Listener(on_press=toggle_event) as listener:
        try:
            listener.join()
        except KeyboardInterrupt:
            print("\n[Autoclicker] Finalizado.")

if __name__ == "__main__":
    main()
