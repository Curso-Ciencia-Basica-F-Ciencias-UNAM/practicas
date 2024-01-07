import pandas as pd
import matplotlib.pyplot as plt

datos = pd.read_csv("./presion-temperatura-table.csv", skiprows = 6)

plt.figure(figsize=(5,5))
plt.plot(datos.temperatura, datos.presion, '.k', alpha=0.1)
plt.plot(datos.groupby("max-vel-inicial").temperatura.mean(), datos.groupby("max-vel-inicial").mean().presion, '-r')
plt.title("temperatura vs presión")
plt.xlabel("temperatura")
plt.ylabel("presión")
plt.show()
