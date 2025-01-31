-- status: correct
-- teardown_command:
-- linux: yes
-- mingw: yes
-- win: yes
-- mac: yes

oms3_setCommandLineOption("--suppressPath=true")

function printStatus(status, expected)
  cmp = ""
  if status == expected then
    cmp = "correct"
  else
    cmp = "wrong"
  end

  if 0 == status then
    status = "ok"
  elseif 1 == status then
    status = "warning"
  elseif 3 == status then
    status = "error"
  end
  print("status:  [" .. cmp .. "] " .. status)
end

status = oms3_setTempDirectory(".")
printStatus(status, 0)

status = oms3_newModel("model")
status = oms3_addSystem("model.tlm", oms_system_tlm)
status = oms3_addSystem("model.tlm.wc1", oms_system_wc)
status = oms3_addSystem("model.tlm.wc2", oms_system_wc)
status = oms3_addConnector("model.tlm.wc1.u1", input, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc1.u2", input, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc1.y", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc2.y1", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc2.y2", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc2.y3", output, oms_signal_type_real)
status = oms3_addBus("model.tlm.wc1.bus1")
printStatus(status, 0)

status = oms3_addConnectorToBus("model.tlm.wc1.bus1","model.tlm.wc1.u1")
printStatus(status, 0)

status = oms3_addConnectorToBus("model.tlm.wc1.bus1","model.tlm.wc1.u2")
printStatus(status, 0)

status = oms3_addConnectorToBus("model.tlm.wc1.bus1","model.tlm.wc2.y1")
printStatus(status, 3)

status = oms3_addBus("model.tlm.wc2.bus2")
printStatus(status, 0)

status = oms3_addConnectorToBus("model.tlm.wc2.bus2","model.tlm.wc2.y1")
printStatus(status, 0)

status = oms3_addConnectorToBus("model.tlm.wc2.bus2","model.tlm.wc2.y2")
printStatus(status, 0)

status = oms3_addConnection("model.tlm.wc1.u1","model.tlm.wc2.y1")
printStatus(status, 0)

status = oms3_addConnection("model.tlm.wc1.bus1","model.tlm.wc2.bus2")
printStatus(status, 3)

status = oms3_addConnection("model.tlm.wc1.u2","model.tlm.wc2.y2")
printStatus(status, 0)

status = oms3_addConnection("model.tlm.wc1.bus1","model.tlm.wc2.bus2")
printStatus(status, 0)


src, status = oms3_list("model.tlm")
print(src)

status = oms3_delete("model")
printStatus(status, 0)

-- Result:
-- info:    Set temp directory to    <suppressed>
-- info:    Set working directory to <suppressed>
-- info:    Set temp directory to    <suppressed>
-- status:  [correct] ok
-- info:    New model "model" with corresponding temp directory <suppressed>
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- error:   [addConnectorToBus] Connector and bus must belong to the same system
-- status:  [correct] error
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- error:   [addConnection] All connectors in each bus must be connected to a connector in the other bus before creating bus connection.
-- status:  [correct] error
-- status:  [correct] ok
-- status:  [correct] ok
-- <?xml version="1.0"?>
-- <ssd:System name="tlm">
-- 	<ssd:SimulationInformation>
--    <ssd:Annotations>
--   		<ssd:Annotation type="org.openmodelica">
--   			<tlm:Master />
--   		</ssd:Annotation>
--    </ssd:Annotations>
-- 	</ssd:SimulationInformation>
-- 	<ssd:Elements>
-- 		<ssd:System name="wc2">
-- 			<ssd:SimulationInformation>
-- 				<FixedStepMaster description="oms-ma" stepSize="1e-1" />
-- 			</ssd:SimulationInformation>
-- 			<ssd:Elements />
-- 			<ssd:Connectors>
-- 				<ssd:Connector name="y1" kind="output" type="Real" />
-- 				<ssd:Connector name="y2" kind="output" type="Real" />
-- 				<ssd:Connector name="y3" kind="output" type="Real" />
-- 			</ssd:Connectors>
-- 			<ssd:Connections />
-- 			<ssd:Annotations>
-- 				<ssd:Annotation type="org.openmodelica">
-- 					<OMSimulator:Bus name="bus2">
-- 						<Signals>
-- 							<Signal name="y1" />
-- 							<Signal name="y2" />
-- 						</Signals>
-- 					</OMSimulator:Bus>
-- 				</ssd:Annotation>
-- 			</ssd:Annotations>
-- 		</ssd:System>
-- 		<ssd:System name="wc1">
-- 			<ssd:SimulationInformation>
-- 				<FixedStepMaster description="oms-ma" stepSize="1e-1" />
-- 			</ssd:SimulationInformation>
-- 			<ssd:Elements />
-- 			<ssd:Connectors>
-- 				<ssd:Connector name="u1" kind="input" type="Real" />
-- 				<ssd:Connector name="u2" kind="input" type="Real" />
-- 				<ssd:Connector name="y" kind="output" type="Real" />
-- 			</ssd:Connectors>
-- 			<ssd:Connections />
-- 			<ssd:Annotations>
-- 				<ssd:Annotation type="org.openmodelica">
-- 					<OMSimulator:Bus name="bus1">
-- 						<Signals>
-- 							<Signal name="u1" />
-- 							<Signal name="u2" />
-- 						</Signals>
-- 					</OMSimulator:Bus>
-- 				</ssd:Annotation>
-- 			</ssd:Annotations>
-- 		</ssd:System>
-- 	</ssd:Elements>
-- 	<ssd:Connectors />
-- 	<ssd:Connections>
-- 		<ssd:Connection startElement="wc1" startConnector="u1" endElement="wc2" endConnector="y1" />
-- 		<ssd:Connection startElement="wc1" startConnector="u2" endElement="wc2" endConnector="y2" />
-- 	</ssd:Connections>
-- 	<ssd:Annotations>
-- 		<ssd:Annotation type="org.openmodelica">
-- 			<OMSimulator:BusConnections>
-- 				<OMSimulator:BusConnection startElement="wc1" startConnector="bus1" endElement="wc2" endConnector="bus2" />
-- 			</OMSimulator:BusConnections>
-- 		</ssd:Annotation>
-- 	</ssd:Annotations>
-- </ssd:System>
-- 
-- status:  [correct] ok
-- info:    0 warnings
-- info:    2 errors
-- endResult
