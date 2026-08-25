import os
import wave
import struct
import math

os.makedirs('assets/audio', exist_ok=True)
SAMPLE_RATE = 44100

def write_wav(filename, samples):
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1) # Mono
        wav_file.setsampwidth(2) # 16-bit
        wav_file.setframerate(SAMPLE_RATE)
        for s in samples:
            val = max(-32767, min(32767, int(s * 32767)))
            wav_file.writeframes(struct.pack('<h', val))

# 1. Pop Sound (Cozy bubble pop 480Hz -> 140Hz)
def gen_pop():
    duration = 0.08
    n_samples = int(duration * SAMPLE_RATE)
    samples = []
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        freq = 480.0 - (340.0 * (t / duration))
        env = math.exp(-t * 35.0)
        s = math.sin(2.0 * math.pi * freq * t) * env
        samples.append(s)
    write_wav('assets/audio/pop.wav', samples)

# 2. Click Sound (Wood click / tap 900Hz)
def gen_click():
    duration = 0.04
    n_samples = int(duration * SAMPLE_RATE)
    samples = []
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        freq = 900.0 - (500.0 * (t / duration))
        env = math.exp(-t * 70.0)
        s = math.sin(2.0 * math.pi * freq * t) * env
        samples.append(s)
    write_wav('assets/audio/click.wav', samples)

# 3. Error Sound (Soft low buzz 180Hz + 120Hz)
def gen_error():
    duration = 0.16
    n_samples = int(duration * SAMPLE_RATE)
    samples = []
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        env = math.sin(math.pi * (t / duration)) * math.exp(-t * 8.0)
        s = (math.sin(2.0 * math.pi * 180.0 * t) * 0.6 + math.sin(2.0 * math.pi * 120.0 * t) * 0.4) * env
        samples.append(s)
    write_wav('assets/audio/error.wav', samples)

# 4. Undo Sound (Pitch up swoosh 160Hz -> 360Hz)
def gen_undo():
    duration = 0.06
    n_samples = int(duration * SAMPLE_RATE)
    samples = []
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        freq = 160.0 + (200.0 * (t / duration))
        env = math.exp(-t * 25.0)
        s = math.sin(2.0 * math.pi * freq * t) * env
        samples.append(s)
    write_wav('assets/audio/undo.wav', samples)

# 5. Hint Sound (Magical C-E-G Arpeggio)
def gen_hint():
    duration = 0.32
    n_samples = int(duration * SAMPLE_RATE)
    samples = [0.0] * n_samples
    notes = [523.25, 659.25, 783.99, 1046.50] # C5, E5, G5, C6
    for idx, freq in enumerate(notes):
        start_t = idx * 0.06
        for i in range(n_samples):
            t = i / SAMPLE_RATE
            if t >= start_t:
                dt = t - start_t
                env = math.exp(-dt * 12.0)
                samples[i] += math.sin(2.0 * math.pi * freq * dt) * env * 0.25
    write_wav('assets/audio/hint.wav', samples)

# 6. Victory Fanfare (Joyful Major Fanfare)
def gen_victory():
    duration = 0.65
    n_samples = int(duration * SAMPLE_RATE)
    samples = [0.0] * n_samples
    chords = [
        (0.00, [523.25, 659.25]),          # C, E
        (0.12, [659.25, 783.99]),          # E, G
        (0.24, [783.99, 1046.50]),         # G, C
        (0.36, [523.25, 659.25, 1046.50]), # Full C chord
    ]
    for start_t, freqs in chords:
        for i in range(n_samples):
            t = i / SAMPLE_RATE
            if t >= start_t:
                dt = t - start_t
                env = math.exp(-dt * 6.0)
                for f in freqs:
                    samples[i] += math.sin(2.0 * math.pi * f * dt) * env * (0.22 / len(freqs))
    write_wav('assets/audio/victory.wav', samples)

gen_pop()
gen_click()
gen_error()
gen_undo()
gen_hint()
gen_victory()
print("All 6 cozy sound effects generated successfully in assets/audio!")
