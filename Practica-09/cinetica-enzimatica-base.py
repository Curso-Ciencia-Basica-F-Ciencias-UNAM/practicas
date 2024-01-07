import matplotlib.pyplot as plt
import numpy as np

## k-1 en la explicación del modelo ahora es k3

def dC(Et,C,S,P,k1,k3,k2):
    return k1*(Et-C)*S - k3*C - k2*C

def dS(Et,C,S,P,k1,k3,k2):
    return k3*C - k1*(Et-C)*S

def dP(Et,C,S,P,k1,k3,k2):
    return k2*C

delta_t = 0.001
T_min = 0
T_max = 2

## condiciones iniciales
Et = 1
S0 = 10
C0, P0 = 0, 0

k1 = 30
k3 = 1
k2 = 10

S1 = S0 + delta_t * dS(Et,C0,S0,P0,k1,k3,k2)
C1 = C0 + delta_t * dC(Et,C0,S0,P0,k1,k3,k2)
P1 = P0 + delta_t * dP(Et,C0,S0,P0,k1,k3,k2)
E1 = Et - C0

# print("S1 = %.2f" %(S1))
# print("C1 = %.2f" %(C1))
# print("P1 = %.2f" %(P1))
# print("E1 = %.2f" %(E1))


def cinetica_enzimatica(S0,C0,P0,Et,T_min,T_max,delta_t):

    T = [ delta_t * i for i in range(round((T_max - T_min ) / delta_t))]

    S = [S0]
    C = [C0]
    P = [P0]
    E = [Et]

    for i in range(len(T)):
        S.append(S[i] + delta_t * dS(Et,C[i],S[i],P[i],k1,k3,k2))
        C.append(C[i] + delta_t * dC(Et,C[i],S[i],P[i],k1,k3,k2))
        P.append(P[i] + delta_t * dP(Et,C[i],S[i],P[i],k1,k3,k2))
        E.append(Et - C[i])
    return S,C,P,E,T

S,C,P,E,T = cinetica_enzimatica(S0,C0,P0,Et,T_min,T_max,delta_t)

plt.figure()
plt.plot(T,S[:-1], label="S")
plt.plot(T,E[:-1], label="E")
plt.plot(T,C[:-1], label="C")
plt.plot(T,P[:-1], label="P")
plt.xlabel("tiempo")
plt.ylabel("concentración")
plt.legend()
plt.show()

#%%

Solutos = [0,1,2,3,4,5,6,7,8,9,10]
plt.figure()
for soluto in Solutos:
    S,C,P,E,T = cinetica_enzimatica(soluto,C0,P0,Et,T_min,T_max,delta_t)
    # plt.plot(T,S[:-1], label="S")
    # plt.plot(T,E[:-1], label="E")
    # plt.plot(T,C[:-1], label="C")
    plt.plot(T,P[:-1], label="%.2f" %(soluto))

plt.xlabel("tiempo")
plt.ylabel("concentración")
plt.legend()
plt.show()

#%%

Solutos = np.linspace(0,10,100)

def v0(Et,S,k1,k3,k2):
    return (k2*k1*Et*S) / (k1*S + k3 + k2)

V0 = []
for soluto in Solutos:
    V0.append(v0(Et,soluto,k1,k3,k2))

plt.plot(S,V0)
plt.hlines(k2*Et,Solutos[0],Solutos[-1],'k',':')
plt.xlabel("[S]")
plt.ylabel("$V_0$")
# plt.xlim((S[0],S[-1]))
plt.show()
