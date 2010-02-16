
SuperStrict

Framework brl.blitz
Import brl.standardio

Import duct.logging

Local logger:TLogger = New TLogger.Create("%I:%M:%S%p",, "log.txt", True, True, False)

Print("Log opened: " + logger.OpenLogStream(True))

logger.LogMessage(" -----~t~tLog started~t~t-----")
logger.LogMessage("Test message!")
logger.LogWarning("Warning!")
logger.LogError("ERROR!!")

logger.LogMessage("Anything you want here..", False)

