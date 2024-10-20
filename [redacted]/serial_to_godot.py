import serial
import socket
import time

# Serial port settings
SERIAL_PORT = '/dev/tty.usbserial-0001'
BAUD_RATE = 115200

# Socket settings
HOST = '127.0.0.1'
PORT = 65432


def main():
    # Set up serial connection
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    time.sleep(2)  # Wait for connection to establish

    # Set up socket
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen(1)
        print(f"Listening for Godot on {HOST}:{PORT}")
        while True:
            conn, addr = s.accept()
            with conn:
                print('Connected by', addr)
                try:
                    while True:
                        # Read line from serial
                        if ser.in_waiting > 0:
                            line = ser.readline().decode('utf-8').strip()
                            print(f"Serial data: {line}")
                            # Send data to Godot
                            conn.sendall(line.encode('utf-8'))
                except Exception as e:
                    print(f"Connection error: {e}")
                    break
            print("Connection lost... looking for new connection")
    ser.close()


if __name__ == "__main__":
    main()
