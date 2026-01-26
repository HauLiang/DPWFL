import scipy.io as sio
import h5py
import matplotlib.pyplot as plt
import numpy as np
import matplotlib as mpl
from scipy.io import loadmat
import re

plt.rcParams['mathtext.fontset'] = 'cm'
plt.rcParams['mathtext.rm'] = 'Times New Roman'
plt.rcParams['mathtext.it'] = 'Times New Roman:italic'
plt.rcParams['mathtext.bf'] = 'Times New Roman:bold'

font = {'family': 'Times New Roman',
        # 'weight': 'bold',
        'size': 16}

mpl.rc('font', **font)

# Data loading
data1 = loadmat('./data/epsilon_D_0.4.mat')
data2 = loadmat('./data/epsilon_D_0.5.mat')
data3 = loadmat('./data/epsilon_D_0.6.mat')
data4 = loadmat('./data/epsilon_D_10000.mat')
data_baseline = loadmat('./data/epsilon_baseline.mat')

epsilon_T1 = data1['epsilon_T'].flatten()
epsilon_T2 = data2['epsilon_T'].flatten()
epsilon_T3 = data3['epsilon_T'].flatten()
epsilon_T4 = data4['epsilon_T'].flatten()
epsilon_baseline = data_baseline['epsilon_baseline'].flatten()


fig, ax = plt.subplots()

t = np.arange(1, 1001)

line_set = ['-', '--', '-.', ':',(0, (3, 2, 1, 3))]

blues = [plt.cm.Blues(i) for i in np.linspace(0.6, 1.0, 4)]

ax.plot(t, epsilon_baseline, linestyle = line_set[0], color='darkred', linewidth=2.5, label='DP-NOMA')
ax.plot(t, epsilon_T1, linestyle = line_set[1], color=blues[0], linewidth=2, label=r'Ours ($D=0.4$)')
ax.plot(t, epsilon_T2, linestyle = line_set[2], color=blues[1], linewidth=2,  label=r'Ours ($D=0.5$)')
ax.plot(t, epsilon_T3, linestyle = line_set[3], color=blues[2], linewidth=2,  label=r'Ours ($D=0.6$)')
ax.plot(t, epsilon_T4, linestyle = line_set[4], color=blues[3], linewidth=2,  label=r'Ours ($D=\infty$)')

ax.set_xlabel('Number of iterations $T$')
ax.set_ylabel(r'Differential Privacy level $\epsilon$')
ax.grid(True)
fig.tight_layout()
fig.legend(loc = (0.17, 0.63), fontsize=13)

plt.savefig('fig_1a.pdf', format='pdf', dpi=600)
plt.show()

