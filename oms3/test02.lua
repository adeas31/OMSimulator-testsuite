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

function printType(t)
  if oms_system_tlm == t then
    print("type: oms_system_tlm")
  elseif oms_system_wc == t then
    print("type: oms_system_wc")
  elseif oms_system_sc == t then
    print("type: oms_system_sc")
  else
    print("Unknown type")
  end
end

status = oms3_newModel("test")
printStatus(status, 0)

status = oms3_addSystem("test.eoo", oms_system_tlm)
printStatus(status, 0)

status = oms3_addSystem("test.eoo.foo", oms_system_wc)
printStatus(status, 0)

status = oms3_addSystem("test.eoo.foo.goo", oms_system_sc)
printStatus(status, 0)

type, status = oms3_getSystemType("test")
printType(type)
printStatus(status, 3)

type, status = oms3_getSystemType("test.eoo")
printType(type)
printStatus(status, 0)

type, status = oms3_getSystemType("test.eoo.foo")
printType(type)
printStatus(status, 0)

type, status = oms3_getSystemType("test.eoo.foo.goo")
printType(type)
printStatus(status, 0)

status = oms3_delete("test")
printStatus(status, 0)

-- Result:
-- info:    Set temp directory to    <suppressed>
-- info:    Set working directory to <suppressed>
-- info:    New model "test" with corresponding temp directory <suppressed>
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- error:   [oms3_getSystemType] Model "test" does not contain system ""
-- Unknown type
-- status:  [correct] error
-- type: oms_system_tlm
-- status:  [correct] ok
-- type: oms_system_wc
-- status:  [correct] ok
-- type: oms_system_sc
-- status:  [correct] ok
-- status:  [correct] ok
-- info:    0 warnings
-- info:    1 errors
-- endResult
