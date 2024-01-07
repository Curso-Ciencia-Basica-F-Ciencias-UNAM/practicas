import pandas as pd
import matplotlib.pyplot as plt

datos = pd.read_csv("./presion-volumen-table.csv", skiprows = 6)

plt.figure(figsize=(5,5))
plt.plot(datos.volumen, datos.presion, '.k', alpha=0.1)
plt.plot(datos.volumen.unique(), datos.groupby("volumen").mean().presion, '-r')
plt.title("volumen vs presión")
plt.xlabel("volumen")
plt.ylabel("presión")
plt.show()
