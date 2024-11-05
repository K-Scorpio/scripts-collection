from scapy.all import rdpcap, TCP
import base64

PCAP_FILE = "capture.pcap"
TARGET_PORT = 1337
SEPARATOR = "AAAAAAAAAA"
XOR_KEY = "MySup3rXoRKeYForCommandandControl".encode("utf-8")

def xor_crypt(data, key):
    key_length = len(key)
    return bytes([byte ^ key[i % key_length] for i, byte in enumerate(data)])

def decode_and_decrypt(payload):
    try:
        parts = payload.split(SEPARATOR)
        if len(parts) < 2:
            return None  

        encoded_part = parts[1]
        decoded_part = base64.b64decode(encoded_part.encode("utf-8"))

        decrypted_data = xor_crypt(decoded_part, XOR_KEY)

        return decrypted_data.decode("utf-8")
    except Exception as e:
        print(f"Error decoding payload: {e}")
        return None

packets = rdpcap(PCAP_FILE)
for packet in packets:
    if packet.haslayer(TCP):
        if packet[TCP].sport == TARGET_PORT:
            payload = bytes(packet[TCP].payload).decode("utf-8", errors="ignore")
            decoded_command = decode_and_decrypt(payload)
            if decoded_command:
                print("Decoded C2 Command:", decoded_command)
        elif packet[TCP].dport == TARGET_PORT:
        
            payload = bytes(packet[TCP].payload).decode("utf-8", errors="ignore")
            decoded_response = decode_and_decrypt(payload)
            if decoded_response:
                print("Decoded C2 Response:", decoded_response)
