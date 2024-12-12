import sys
import numpy as np
import matplotlib.pyplot as plt
import os

# Get the directory of the current script and change the working directory
script_dir = os.path.dirname(os.path.realpath(__file__))
os.chdir(script_dir)


def calculate_angle(x, y):
    dot_product = np.einsum('ij,ij->i', x, y)
    norm_x = np.linalg.norm(x, axis=1)
    norm_y = np.linalg.norm(y, axis=1)
    angle_radians = np.arccos(dot_product / (norm_x * norm_y))
    return np.degrees(angle_radians)

def calculate_volume(a, b, c):
    volume = np.einsum('ij,ij->i', a, np.cross(b, c))
    return np.abs(volume)

# Determine dump_interval from run.in file
def get_dump_interval():
    dump_interval = 10  # Default value
    if os.path.exists('run.in'):
        with open('run.in', 'r') as file:
            for line in file:
                if "dump_thermo" in line:
                    try:
                        dump_interval = int(line.split()[1])
                        break
                    except (IndexError, ValueError):
                        pass
    return dump_interval

data = np.loadtxt('thermo.out')

dump_interval = get_dump_interval()
time = np.arange(0, len(data) * dump_interval / 1000, dump_interval / 1000)

# read data
temperature = data[:, 0]
kinetic_energy = data[:, 1]
potential_energy = data[:, 2]
pressure_x = data[:, 3]
pressure_y = data[:, 4]
pressure_z = data[:, 5]

num_columns = data.shape[1]

if num_columns == 12:
    box_length_x = data[:, 9]
    box_length_y = data[:, 10]
    box_length_z = data[:, 11]
    volume = box_length_x * box_length_y * box_length_z
elif num_columns == 18:
    ax, ay, az = data[:, 9], data[:, 10], data[:, 11]
    bx, by, bz = data[:, 12], data[:, 13], data[:, 14]
    cx, cy, cz = data[:, 15], data[:, 16], data[:, 17]

    a_vectors = np.column_stack((ax, ay, az))
    b_vectors = np.column_stack((bx, by, bz))
    c_vectors = np.column_stack((cx, cy, cz))

    box_length_x = np.sqrt(ax**2 + ay**2 + az**2)
    box_length_y = np.sqrt(bx**2 + by**2 + bz**2)
    box_length_z = np.sqrt(cx**2 + cy**2 + cz**2)

    box_angle_alpha = calculate_angle(b_vectors, c_vectors)
    box_angle_beta = calculate_angle(c_vectors, a_vectors)
    box_angle_gamma = calculate_angle(a_vectors, b_vectors)

    volume = calculate_volume(a_vectors, b_vectors, c_vectors)
else:
    raise ValueError("Unsupported number of columns in thermo.out. Expected 12 or 18.")

# Calculate averages after 50% of simulation time
start_index = len(time) // 2
avg_temperature = np.mean(temperature[start_index:])
avg_pressure_x = np.mean(pressure_x[start_index:])
avg_pressure_y = np.mean(pressure_y[start_index:])
avg_pressure_z = np.mean(pressure_z[start_index:])
avg_length_x = np.mean(box_length_x[start_index:])
avg_length_y = np.mean(box_length_y[start_index:])
avg_length_z = np.mean(box_length_z[start_index:])
avg_ax = np.mean(ax[start_index:])
avg_ay = np.mean(ay[start_index:])
avg_az = np.mean(az[start_index:])
avg_bx = np.mean(bx[start_index:])
avg_by = np.mean(by[start_index:])
avg_bz = np.mean(bz[start_index:])
avg_cx = np.mean(cx[start_index:])
avg_cy = np.mean(cy[start_index:])
avg_cz = np.mean(cz[start_index:])
if num_columns == 18:
    avg_angle_alpha = np.mean(box_angle_alpha[start_index:])
    avg_angle_beta = np.mean(box_angle_beta[start_index:])
    avg_angle_gamma = np.mean(box_angle_gamma[start_index:])
avg_volume = np.mean(volume[start_index:]) / 1000  # Convert to x10^3 Å^3

# Print average values
average_results = [
    f"Average values after 50% simulation time:",
    f"Temperature: {avg_temperature:.3f} K",
    f"Pressure X: {avg_pressure_x:.3f} GPa",
    f"Pressure Y: {avg_pressure_y:.3f} GPa",
    f"Pressure Z: {avg_pressure_z:.3f} GPa",
    f"Lattice Length X: {avg_length_x:.3f} Å",
    f"Lattice Length Y: {avg_length_y:.3f} Å",
    f"Lattice Length Z: {avg_length_z:.3f} Å",
]
if num_columns == 18:
    average_results.extend([
        f"Angle Alpha: {avg_angle_alpha:.2f}°",
        f"Angle Beta: {avg_angle_beta:.2f}°",
        f"Angle Gamma: {avg_angle_gamma:.2f}°",
    ])
average_results.append(f"Volume: {avg_volume:.3f} ×10^3 Å^3")

print("\n".join(average_results))

# Save average values to a text file
with open('average_results.txt', 'w', encoding='utf-8') as f:
    f.write("\n".join(average_results))

np.savetxt('equilibrium_lattice_matrix.txt', 
           np.array([[
               f"{aver_ax:.3f}",
               f"{aver_ay:.3f}",
               f"{aver_az:.3f}",
               f"{aver_bx:.3f}",
               f"{aver_by:.3f}",
               f"{aver_bz:.3f}",
               f"{aver_cx:.3f}",
               f"{aver_cy:.3f}",
               f"{aver_cz:.3f}"
           ]]), fmt='%s')

# Subplot
fig, axs = plt.subplots(2, 3, figsize=(12, 6), dpi=100)

# Temperature
axs[0, 0].plot(time, temperature)
axs[0, 0].set_title('Temperature')
axs[0, 0].set_xlabel('Time (ps)')
axs[0, 0].set_ylabel('Temperature (K)')

# Potential Energy and Kinetic Energy
color_potential = 'tab:orange'
color_kinetic = 'tab:green'
axs[0, 1].set_title(r'$P_E$ vs $K_E$')
axs[0, 1].set_xlabel('Time (ps)')
axs[0, 1].set_ylabel(r'Potential Energy ($x10^3$ eV)', color=color_potential)
axs[0, 1].plot(time, potential_energy/1000, color=color_potential)
axs[0, 1].tick_params(axis='y', labelcolor=color_potential)

axs_kinetic = axs[0, 1].twinx()
axs_kinetic.set_ylabel('Kinetic Energy (eV)', color=color_kinetic)
axs_kinetic.plot(time, kinetic_energy, color=color_kinetic)
axs_kinetic.tick_params(axis='y', labelcolor=color_kinetic)

# Pressure
axs[0, 2].plot(time, pressure_x, label='Px')
axs[0, 2].plot(time, pressure_y, label='Py')
axs[0, 2].plot(time, pressure_z, label='Pz')
axs[0, 2].set_title('Pressure')
axs[0, 2].set_xlabel('Time (ps)')
axs[0, 2].set_ylabel('Pressure (GPa)')
axs[0, 2].legend()

# Lattice
axs[1, 0].plot(time, box_length_x, label='Lx')
axs[1, 0].plot(time, box_length_y, label='Ly')
axs[1, 0].plot(time, box_length_z, label='Lz')
axs[1, 0].set_title('Lattice Parameters')
axs[1, 0].set_xlabel('Time (ps)')
axs[1, 0].set_ylabel(r'Lattice Parameters ($\AA$)')
axs[1, 0].legend()

# Volume
axs[1, 1].plot(time, volume / 1000, label='Volume', color='tab:purple')
axs[1, 1].set_title('Volume')
axs[1, 1].set_xlabel('Time (ps)')
axs[1, 1].set_ylabel(r'Volume ($x10^3$ $\AA^3$)')
axs[1, 1].legend()

# Angles (only for triclinic systems)
if num_columns == 18:
    axs[1, 2].plot(time, box_angle_alpha, label='Alpha')
    axs[1, 2].plot(time, box_angle_beta, label='Beta')
    axs[1, 2].plot(time, box_angle_gamma, label='Gamma')
    axs[1, 2].set_title('Angles')
    axs[1, 2].set_xlabel('Time (ps)')
    axs[1, 2].set_ylabel(r'Angles ($\degree$)')
    axs[1, 2].legend()

plt.tight_layout()

if len(sys.argv) > 1 and sys.argv[1] == 'save':
    plt.savefig('thermo.png')
else:
    plt.show()
