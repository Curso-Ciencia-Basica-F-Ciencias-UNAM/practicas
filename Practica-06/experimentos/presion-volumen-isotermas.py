import pandas as pd
import matplotlib.pyplot as plt

#%%

datos = pd.read_csv("./presion-volumen-isotemras-table.csv", skiprows=6)

vels_inicial = datos["max-vel-inicial"].unique()

plt.figure(figsize=(5,4))

for vel in vels_inicial:
    datos_vel = datos[datos["max-vel-inicial"] == vel]
    temp = datos_vel.temperatura.mean()
    color=next(plt.gca()._get_lines.prop_cycler)['color']
    plt.plot(datos_vel.volumen,
             datos_vel.presion ,
             '.',
             color =color,
             alpha = 0.4)
    plt.plot(datos_vel.volumen.unique(),
             datos_vel.groupby("volumen").presion.mean(),
             label="%.2f" %(temp),
             color = color)
plt.legend(title="temperatura")
plt.xlim(0,200)
plt.xlabel("volumen")
plt.ylabel("presión")
plt.tight_layout()
plt.show()
