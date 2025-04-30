import serial
import time
import sys

def main():
    if len(sys.argv) != 4:
        print('Bad usage')
        sys.exit()
    SERIAL_PORT = sys.argv[1]
    BAUD_RATE = int(sys.argv[2])
    ITERCOUNT = int(sys.argv[3])
    try:
        with serial.Serial(SERIAL_PORT, BAUD_RATE) as ser:
            while True:
                ser.write(bytes(b'#'))
                ack = ser.read()
                beg = time.time_ns()
                c = ser.read()
                end = time.time_ns()
                if c.decode('utf-8') != '#':
                    print("incorrect character")
                else:
                    print((end - beg) / ITERCOUNT)
    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except KeyboardInterrupt:
        print("Stopped by user.")

if __name__ == "__main__":
    main()
