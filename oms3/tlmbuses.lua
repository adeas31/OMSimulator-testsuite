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
status = oms3_newModel("model")
status = oms3_addSystem("model.tlm", oms_system_tlm)
status = oms3_addSystem("model.tlm.wc1", oms_system_wc)
status = oms3_addConnector("model.tlm.wc1.y", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc1.x", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc1.v", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc1.f", input, oms_signal_type_real)

status = oms3_addSystem("model.tlm.wc2", oms_system_wc)
status = oms3_addConnector("model.tlm.wc2.y", input, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc2.x", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc2.v", output, oms_signal_type_real)
status = oms3_addConnector("model.tlm.wc2.f", input, oms_signal_type_real)

status = oms3_addTLMBus("model.tlm.wc1.bus1", "input", 1, default)
printStatus(status, 0)

status = oms3_addConnectorToTLMBus("model.tlm.wc1.bus1","model.tlm.wc1.y", "value")
printStatus(status, 0)

-- Test adding non-existing connector
status = oms3_addConnectorToTLMBus("model.tlm.wc1.bus1","model.tlm.wc1.z", "value")
printStatus(status, 3)

-- Test adding connector with illegal type
status = oms3_addConnectorToTLMBus("model.tlm.wc1.bus1","model.tlm.wc1.y", "effort")
printStatus(status, 3)

status = oms3_addTLMBus("model.tlm.wc1.bus2", "mechanical", 1, default)
printStatus(status, 0)

status = oms3_addConnectorToTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.x", "state")
printStatus(status, 0)

status = oms3_addConnectorToTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.v", "flow")
printStatus(status, 0)

status = oms3_addConnectorToTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.f", "effort")
printStatus(status, 0)

status = oms3_addTLMBus("model.tlm.wc2.bus2", "output", 1, default)
printStatus(status, 0)

status = oms3_addConnectorToTLMBus("model.tlm.wc2.bus2","model.tlm.wc2.y", "value")
printStatus(status, 0)

status = oms3_addTLMConnection("model.tlm.wc1.bus1","model.tlm.wc2.bus2", 0.001,0.3,100,0)
printStatus(status, 0)

src, status = oms3_list("model.tlm")
print(src)

status = oms3_delete("model")
printStatus(status, 0)

-- Result:
-- info:    Set temp directory to    <suppressed>
-- info:    Set working directory to <suppressed>
-- info:    Set temp directory to    <suppressed>
-- info:    New model "model" with corresponding temp directory <suppressed>
-- status:  [correct] ok
-- status:  [correct] ok
-- error:   [addConnectorToTLMBus] Connector not found in system: z
-- status:  [correct] error
-- error:   [addConnector] Unknown TLM variable type: effort
-- status:  [correct] error
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
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
-- 	  <ssd:System name="wc2">
-- 	    <ssd:SimulationInformation>
-- 	      <FixedStepMaster description="oms-ma" stepSize="1e-1" />
-- 	    </ssd:SimulationInformation>
-- 	    <ssd:Elements />
-- 	    <ssd:Connectors>
-- 	      <ssd:Connector name="y" kind="input" type="Real" />
-- 	      <ssd:Connector name="x" kind="output" type="Real" />
-- 	      <ssd:Connector name="v" kind="output" type="Real" />
-- 	      <ssd:Connector name="f" kind="input" type="Real" />
-- 	    </ssd:Connectors>
-- 	    <ssd:Connections />
-- 	    <ssd:Annotations>
-- 	      <ssd:Annotation type="org.openmodelica">
-- 	        <OMSimulator:Bus name="bus2" type="tlm" domain="output" dimensions="1" interpolation="none">
-- 	          <Signals>
-- 	            <Signal name="y" type="value" />
-- 	          </Signals>
-- 	        </OMSimulator:Bus>
-- 	      </ssd:Annotation>
-- 	    </ssd:Annotations>
-- 	  </ssd:System>
-- 		<ssd:System name="wc1">
-- 			<ssd:SimulationInformation>
-- 				<FixedStepMaster description="oms-ma" stepSize="1e-1" />
-- 			</ssd:SimulationInformation>
-- 			<ssd:Elements />
-- 			<ssd:Connectors>
-- 				<ssd:Connector name="y" kind="output" type="Real" />
-- 				<ssd:Connector name="x" kind="output" type="Real" />
-- 				<ssd:Connector name="v" kind="output" type="Real" />
-- 				<ssd:Connector name="f" kind="input" type="Real" />
-- 			</ssd:Connectors>
-- 			<ssd:Connections />
-- 			<ssd:Annotations>
-- 				<ssd:Annotation type="org.openmodelica">
-- 					<OMSimulator:Bus name="bus1" type="tlm" domain="input" dimensions="1" interpolation="none">
-- 						<Signals>
-- 							<Signal name="y" type="value" />
-- 						</Signals>
-- 					</OMSimulator:Bus>
-- 					<OMSimulator:Bus name="bus2" type="tlm" domain="mechanical" dimensions="1" interpolation="none">
-- 						<Signals>
-- 							<Signal name="x" type="state" />
-- 							<Signal name="v" type="flow" />
-- 							<Signal name="f" type="effort" />
-- 						</Signals>
-- 					</OMSimulator:Bus>
-- 				</ssd:Annotation>
-- 			</ssd:Annotations>
-- 		</ssd:System>
-- 	</ssd:Elements>
-- 	<ssd:Connectors />
-- 	<ssd:Connections />
--  <ssd:Annotations>
--    <ssd:Annotation type="org.openmodelica">
--      <OMSimulator:BusConnections>
--        <OMSimulator:TLMBusConnection startElement="wc1" startConnector="bus1" endElement="wc2" endConnector="bus2" delay="0.001000" alpha="0.300000" linearimpedance="100.000000" angularimpedance="0.000000" />
--      </OMSimulator:BusConnections>
--    </ssd:Annotation>
--  </ssd:Annotations>
-- </ssd:System>
-- 
-- status:  [correct] ok
-- info:    0 warnings
-- info:    2 errors
-- endResult
