block Pump

InputReal glucose;        //amount of glucose of the patient
OutputReal insulin_out;   //amount of insulin to give the patient

Real z, err;

parameter Real T = 600;    //10 minuti
parameter Real a = 1.0;
parameter Real b = 0.001;
parameter Real ref = 100;

initial equation
insulin_out = 0;
z = 0;

equation
err = (glucose - ref);

algorithm

when sample(0, T) then

z := pre(z) + T*err;

insulin_out :=  max(0, a*err + b*pre(z));

end when;

end Pump;
