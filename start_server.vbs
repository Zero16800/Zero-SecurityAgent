Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "E:\ZeroClaw\dayZero"
WshShell.Environment("PROCESS")("PYTHONIOENCODING") = "utf-8"
WshShell.Environment("PROCESS")("PYTHONPATH") = "E:\ZeroClaw\dayZero"
WshShell.Run "python -m security_agent.web_ui --port 5000", 0, False
