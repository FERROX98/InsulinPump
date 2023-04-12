import os
import sys
import math
import numpy as np
import time
import os.path
import random
from OMPython import OMCSessionZMQ
os.chdir("Prj/Models")
def random_value():
        ki= 0.0075
        kp2= 0.0008
        kp3 = 0.006
        Vg = 1
        Vmx = 0.034
        Km0 = 466.2
        k2 = 0.043
        k1 = 0.066
        Ib =54
        lista=[ki,kp2,kp3,Vg,Vmx,Km0,k2,k1,Ib]
        lista_nomi=["ki","kp2","kp3","Vg","Vmx","Km0","k2","k1","Ib"]
        
        for x,el in enumerate(lista):
                range_=(el/100)*10
                random_disturb=random.uniform(range_*-1, range_)
                el=el+random_disturb
                lista[x]=el
                #print(el)
        out=''
        for x in range(len(lista)):
                out+=lista_nomi[x]+"="+str(lista[x])+" "
        print(out)
        return (lista,lista_nomi)


def calcola_(age,intervallo,pesi_1,pesi_2,altezze_1,altezze_2):
        if abs(age-intervallo[0])<abs(age-intervallo[1]): # calcolo a quale eta si avvicina di piu 
                peso=int(np.random.uniform(pesi_1[0],pesi_1[1])) #assegno un random preso nella prima fascia di peso
                altezza=int(np.random.uniform(altezze_1[0],altezze_1[1])) #assegno un random preso nella prima fascia di altezze
        else:
                peso=int(np.random.uniform(pesi_2[0],pesi_2[1]))
                altezza=int(np.random.uniform(altezze_2[0],altezze_2[1]))
        return(peso,altezza)
        
omc = OMCSessionZMQ()
omc.sendExpression("getVersion()")
omc.sendExpression("cd(Models)")
omc.sendExpression("loadModel(Modelica)")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"connectors.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"patient.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"mealgen.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Pump.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"rag.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Monitor.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"System.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("buildModel(System, stopTime=2000)")
omc.sendExpression("getErrorString()")

#  begin testing
s=["maschio","femmina"]
####################

#test
age=8
sex=0
weight=90
height=165
np.random.seed(1)



with open ("log", 'wt') as f:
        print("Begin log")
        f.write("Begin log"+"\n")
        f.flush()
        os.fsync(f)
        

inizio = time.time() # per cpu time
# number of samples
num_pass = 0
num_fail = 0
for i in range(100):
        print ("Iterazione ",i)
        age = int(np.random.uniform(6,101))
        sex = int(np.random.uniform(0,2))
        
        if (age<13):#
                x=calcola_(age,(6,12),(55,70),(55,75),(62,90),(100,165))
                weight=x[0]
                height=x[1]         
        elif (12<age<17):#
                x=calcola_(age,(13,16),(55,76),(55,88),(110,171),(110,187))
                weight=x[0]
                height=x[1]   
        elif (16<age<22):#
                x=calcola_(age,(17,21),(55,93),(55,100),(140,187),(145,190))
                weight=x[0]
                height=x[1]  
        elif (21<age<25):#
                x=calcola_(age,(22,24),(56,96),(59,100),(140,195),(145,200))
                weight=x[0]
                height=x[1]  
        elif (24<age<35):#
                x=calcola_(age,(25,34),(59,100),(60,101),(150,200),(150,200))
                weight=x[0]
                height=x[1]  
        elif (33<age<46):#
                x=calcola_(age,(34,45),(59,100),(60,101),(150,200),(150,200))
                weight=x[0]
                height=x[1]  
        else:            #
                x=calcola_(age,(46,101),(59,100),(60,101),(150,200),(150,200))
                weight=x[0]
                height=x[1]  
      
        y = 0.0        

        #print ("CARATTERISTICHE (eta=",age,",sesso=",sex,",peso=",weight,",altezza=",height,")")
        #print("eta=",age,",sesso=",sex,",peso=",weight,",altezza=",height,")")
      
        print("pa.Weight="+str(weight)+" "+"pa.age="+str(age)+" "+"pa.Height="+str(height)+" "+"pa.sex="+str(sex))
        random_disturb=random_value()
        with open ("modelica_rand.in", 'w') as f:
                
                f.write("pa.Weight="+str(weight)+"\n"+"pa.age="+str(age)+"\n"+"pa.Height="+str(height)+"\n"+"pa.sex="+str(sex)+"\n"+"rag.BW="+str(weight)+"\n")
                for x,el in enumerate(random_disturb[0]):
                         #print("x",x,"el",el,"nome",random_disturb[1][x])
                         f.write("pa."+random_disturb[1][x]+"="+str(el)+"\n")
                f.flush()
                os.fsync(f)
       
        omc.sendExpression("system(\"./System -overrideFile=modelica_rand.in\")")
      
        os.system("rm -f modelica_rand.in")    # .... to be on the safe side
      

        y = omc.sendExpression("val(m.y, 2000.0, \"System_res.mat\")") #legge m.y al tempo 50
        os.system("rm -f System_res.mat") # .... to be on the safe side
        time.sleep(1)
        if (y <= 0.5):
                num_pass = num_pass + 1.0
                print("Test Passed y="+str(y)+"\n")
                with open ("log_100", 'a') as f:
                        f.write("Test Passed y="+str(y)+"\n")
                        f.flush()
                        os.fsync(f)
        else:
                with open ("log", 'a') as f:
                        f.write("\nTest NOT PASSED y="+str(y))
                num_fail = num_fail + 1.0
                omc.sendExpression("plot({pa.G,m.y,pu.insulin_out,pa.delta}, externalWindow=true)")
                print ("Test Fallito PAZIENTE CON CARATTERISTICHE (eta=",age,",sesso=",sex,",peso=",weight,",altezza=",height,")")
                break
            
print ("num pass = ", num_pass, ", num fail = ", num_fail, ", total tests = ",  num_pass + num_fail)
print ("pass prob = ", num_pass/(num_pass + num_fail), ", fail prob = ", num_fail/(num_pass + num_fail))
print ("CPU Time = ", time.time() - inizio)
           
os.system("./clean.sh")

