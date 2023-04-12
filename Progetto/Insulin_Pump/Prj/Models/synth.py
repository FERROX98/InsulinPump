import os
import sys
import math
import numpy as np
import time
import os.path

from OMPython import OMCSessionZMQ
os.chdir("Prj/Models")

omc = OMCSessionZMQ()
omc.sendExpression("getVersion()")
omc.sendExpression("cd()")
omc.sendExpression("loadModel(Modelica)")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Pump.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"mealgen.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"rag.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"patient.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Monitor.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"System.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"connectors.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("buildModel(System, stopTime=2000)")



num_pass = 0
num_fail = 0
y = 0.0
stop=False

l=0
inizio = time.time()
for a in range(1,12):
    a= a/10
    for ref in range(60,160):
        max_glu = 0
        min_glu = 1000
        max_ins = 0
        min_ins = 1000

        print ("Iterazione ",l)
        l+=1
        with open ("modelica_rand.in","w") as f:
            print("a="+str(a)+" ref="+str(ref))
            f.write("pu.a="+str(a)+"\npu.ref="+str(ref)+"\n")
        omc.sendExpression("system(\"./System -overrideFile=modelica_rand.in\")")
        os.system("rm -f modelica_rand.in")    # .... to be on the safe side

        for k in range(0,2000):
            ins = omc.sendExpression("val(pu.insulin_out, "+str(k)+", \"System_res.mat\")")
            glu = omc.sendExpression("val(pa.G, "+str(k)+", \"System_res.mat\")")
            if (glu > max_glu):
             max_glu = glu
            elif (glu < min_glu):
             min_glu = glu
            if ( ins > max_ins):
             max_ins = ins
            elif (ins < min_ins):
                min_ins = ins
        y = omc.sendExpression("val(m.y, 2000.0, \"System_res.mat\")")
        os.system("rm -f system_res.mat")      # .... to be on the safe side
        print ("insulina min=" + str(min_ins) + ",max=" + str(max_ins) + "\nglucosio min=" + str(min_glu) + ",max=" + str(max_glu))
        #Time.sleep(1)
        if (y <= 0.5):
          num_pass = num_pass + 1.0
          print("Test Passed y=",str(y)+"\n")
        else:
            num_fail = num_fail + 1.0
            print("Test failled")
            stop=True
            break

    if stop:
        break
       


print ("num pass = ", num_pass, ", num fail = ", num_fail, ", total tests = ",  num_pass + num_fail)
print ("pass prob = ", num_pass/(num_pass + num_fail), ", fail prob = ", num_fail/(num_pass + num_fail))
print ("CPU Time = ", time.time() - inizio)
os.system("./clean.sh")