-- name: HelloWorldWithInput_cs_Fit
-- status: correct
-- teardown_command: rm -f HelloWorldWithInput_cs_Fit.log HelloWorldWithInput_cs_Fit_res.csv

version = oms2_getVersion()
-- print(version)

oms2_setLogFile("HelloWorldWithInput_cs_Fit.log")
oms2_setTempDirectory(".")
oms2_newFMIModel("HelloWorldWithInput_cs_Fit")
oms2_setResultFile("HelloWorldWithInput_cs_Fit", "HelloWorldWithInput_cs_Fit_res.csv")
oms2_setCommunicationInterval("HelloWorldWithInput_cs_Fit", 0.1)
-- setTolerance(model, 1e-5); -- 2018-04-25 Not yet supported in oms2 API

-- add FMU
status = oms2_addFMU("HelloWorldWithInput_cs_Fit", "../FMUs/HelloWorldWithInput_cs.fmu", "HelloWorldWithInput")

-- create system identification model for model
simodel = omsi_newSysIdentModel("HelloWorldWithInput_cs_Fit");
-- omsi_describe(simodel)

-- Data generated from simulating HelloWorldWithInput.mo for 1.0s with Euler and 0.1s step size
kNumSeries = 1;
kNumObservations = 11;
data_time = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1};
inputvars = {"HelloWorldWithInput_cs_Fit.HelloWorldWithInput:u"};
data_u =    {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1}; -- input u=time
measurementvars = {"HelloWorldWithInput_cs_Fit.HelloWorldWithInput:x"};
data_x = {1, 0.91, 0.839, 0.7851, 0.74659, 0.721931, 0.7097379, 0.70876411, 0.717887699, 0.7360989291, 0.76248903619}
-- data_x was generated by the commented code below.
-- WARNING: Conventional simulation results of the source Modelica model with OMC (Euler, 0.1 step size), show quite some deviation!
-- oms2_initialize("HelloWorldWithInput_cs_Fit")
-- oms2_setReal("HelloWorldWithInput_cs_Fit.HelloWorldWithInput:x_start", 1.0)
-- oms2_setReal("HelloWorldWithInput_cs_Fit.HelloWorldWithInput:a", -1.0)
-- for i=1,11 do
--   print("data_u[i]:" .. data_u[i])
--   oms2_setReal("HelloWorldWithInput_cs_Fit.HelloWorldWithInput:u", data_u[i])
--   oms2_stepUntil("HelloWorldWithInput_cs_Fit", data_time[i])
-- end


omsi_initialize(simodel, kNumSeries, data_time, inputvars, measurementvars)
-- omsi_describe(simodel)

omsi_addParameter(simodel, "HelloWorldWithInput_cs_Fit.HelloWorldWithInput:x_start", 0.5);
omsi_addParameter(simodel, "HelloWorldWithInput_cs_Fit.HelloWorldWithInput:a", -0.5);
omsi_addInput(simodel, "HelloWorldWithInput_cs_Fit.HelloWorldWithInput:u", data_u);
omsi_addMeasurement(simodel, 0, "HelloWorldWithInput_cs_Fit.HelloWorldWithInput:x", data_x);
-- omsi_describe(simodel)

omsi_setOptions_max_num_iterations(simodel, 25)
omsi_solve(simodel, "")

status, simodelstate = omsi_getState(simodel);
-- print(status, simodelstate)

status, startvalue1, estimatedvalue1 = omsi_getParameter(simodel, "HelloWorldWithInput_cs_Fit.HelloWorldWithInput:a")
status, startvalue2, estimatedvalue2 = omsi_getParameter(simodel, "HelloWorldWithInput_cs_Fit.HelloWorldWithInput:x_start")
-- print("HelloWorldWithInput.a startvalue=" .. startvalue1 .. ", estimatedvalue=" .. estimatedvalue1)
-- print("HelloWorldWithInput.x_start startvalue=" .. startvalue2 .. ", estimatedvalue=" .. estimatedvalue2)
is_OK1 = estimatedvalue1 > -1.1 and estimatedvalue1 < -0.9
is_OK2 = estimatedvalue2 > 0.9 and estimatedvalue2 < 1.1
print("HelloWorldWithInput.a estimation is OK: " .. tostring(is_OK1))
print("HelloWorldWithInput.x_start estimation is OK: " .. tostring(is_OK2))

omsi_freeSysIdentModel(simodel)

oms2_unloadModel("HelloWorldWithInput_cs_Fit")

-- Result:
-- HelloWorldWithInput.a estimation is OK: true
-- HelloWorldWithInput.x_start estimation is OK: true
-- info:    Logging information has been saved to "HelloWorldWithInput_cs_Fit.log"
-- endResult
