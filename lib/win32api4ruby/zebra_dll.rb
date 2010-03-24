# -*- coding: UTF-8 -*-

require 'win32api4ruby/base'

module Win32api4ruby
	#Klasse für den Zugriff auf die Zebra DLL (ZBRPrinter.dll)
	class ZebraDll < Base
		ZEBRA_DLL = DL.dlopen('ZBRPrinter.dll')


		ZBRGetHandle = ZEBRA_DLL['ZBRGetHandle', 'LpPpp']
		def self.get_handle(hPrinter, printerName, printerType, err)
#	int ZBRGetHandle(
#			HANDLE *hPrinter,
#			char *printerName,
#			int *printerType,
#			int *err)
			api_call(ZBRGetHandle, hPrinter, printerName, printerType, err)
		end

		ZBRCloseHandle = ZEBRA_DLL['ZBRCloseHandle', 'LLp']
		def self.close_handle(hPrinter, err)
#	Syntax: int ZBRCloseHandle(
#			HANDLE hPrinter,
#			int *err)
			api_call(ZBRCloseHandle, hPrinter, err)
		end

		ZBRPRNSendCmd = ZEBRA_DLL['ZBRPRNSendCmd', 'LLLPp']
		#Sendet ein Kommando an den Drucker (sh. Zebra Programmers Guide). Die Methode blockiert, bis das
		#Kommando ausgeführt wurde.
		def self.send_cmd(hPrinter, printerType, cmd, err)
#	int ZBRPRNSendCmd(
#			HANDLE hPrinter,
#			int printerType,
#			char *cmd,
#			int *err)
			api_call(ZBRPRNSendCmd, hPrinter, printerType, cmd, err)
		end

		ZBRPRNSendCmdEx = ZEBRA_DLL['ZBRPRNSendCmdEx', 'LLLPppp']
		#Sendet ein Kommando an den Drucker (sh. Zebra Programmers Guide) und gibt die Antwort zurück. Die Methode
		#blockiert, bis das Kommando ausgeführt wurde.
		def self.send_cmdex(hPrinter, printerType, cmd, response, respSize, err)
#	int ZBRPRNSendCmdEx(
#			HANDLE hPrinter,
#			int printerType,
#			char *cmd,
#			char *response
#			int *respSize
#			int *err)
			api_call(ZBRPRNSendCmdEx, hPrinter, printerType, cmd, response, respSize, err)
		end
	end
end