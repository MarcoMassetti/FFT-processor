import os
import subprocess
import random
from math import floor



#---------------- DEFINIZIONE FUNZIONI ----------------- 
def genera_random_input(_din, _n): #Generazione sequenze di input casuali
	bit_guardia = 2
	for i in range(_n): #Generazione di n sequenze
		data = []
		for j in _din: #Generazione di n variabili
			#possibili = [-2**(j-1-bit_guardia), 2**(j-1-bit_guardia) - 1] #Input ai limiti della dinamica
			#data.append(random.choice(possibili))
			data.append(random.randint(-2**(j-1-bit_guardia), 2**(j-1-bit_guardia) - 1)) #Salvataggio dati per calcolo output
			file_in.write(print_binary(data[-1], 20)) #Srittura sequenza sul file

		file_in.write("\n")
		genera_output(data) #Calcolo output previsto



def print_binary(_value, _bits): #Stampa del valore binario in formato sfixed
	str_format = '{0:0'+str(_bits)+'b}'
	if(_value < 0):
		_value = 2**_bits + _value
	to_return = str_format.format(_value)
	to_return = to_return[:1] + "." + to_return[1:] + " "

	return to_return



def genera_output(_data): #Calcola output previsto
	Ar = _data[0]
	Ai = _data[1]
	Br = _data[2]
	Bi = _data[3]
	Wr = _data[4] / 2**19
	Wi = _data[5] / 2**19

	M1 = Br*Wr
	M2 = Bi*Wi
	M3 = Br*Wi
	M4 = Bi*Wr
	M5 = 2*Ar
	M6 = 2*Ai
	
	S1 = Ar + M1
	S2 = S1 - M2
	S3 = Ai + M3
	S4 = S3 + M4
	S5 = M5 - S2
	S6 = M6 - S4

	A1r = S2
	A1i = S4
	B1r = S5
	B1i = S6
	
	A1r = floor((A1r + 1) / 2)
	A1i = floor((A1i + 1) / 2)
	B1r = floor((B1r + 1) / 2)
	B1i = floor((B1i + 1) / 2)

	file_out.write(print_binary(A1r, 20) + print_binary(A1i, 20) + print_binary(B1r, 20) + print_binary(B1i, 20) + "\n")



def verifica_output(): #Confronta l'output ottenuto con quello previsto

	simulation_output = open('output_results.log', 'r') #Apertura risultato della simulazione
	reference_output = open('output_vectors.log', 'r') #Apertura output atteso
	input_file = open('input_vectors.log', 'r') #Apertura sequenze di input
	inputs = input_file.readlines() #Lettura sequenza di input
	
	i = 0 #Conteggio linee lette

	for line in simulation_output: #Lettura risultato simulazione una riga alla volta
		line2 = reference_output.readline() #Lettura risultato atteso una riga alla volta
		if line != line2: #Verifica differenze tra i due outout
			log_file.write("Input = " + inputs[i][:-1] + ', Output ottenuto = ' + line[:-1] + ", Output atteso = " + line2) #Segnala la differenza nel file di log

		i += 1 #Incremento contatore linea

	simulation_output.close()
	reference_output.close()
	input_file.close()



#---------------- INIZIO SCRIPT ----------------- 
try: 	

	Din = (20, 20, 20, 20, 22, 22) #Numero di bit delle variabili da generare

	file_in = open('input_vectors.log', 'w') #Apertura file per scrittura variabili di ingresso
	file_out = open('output_vectors.log', 'w') #Apertura file per scrittura dei risultati attesi


	genera_random_input(Din, 10000) #Generazione sequenze di input casuali

	file_in.close()
	file_out.close()

	process = subprocess.call(["vsim", "-c", "-do", "compile.do"]) #Avvio simulazione

	log_file = open('log.log', 'w') #Apertura file per scrittura differenze tra risultati attesi e ottenuti
	verifica_output() #Calcola output previsto
	log_file.close()

except:   
   print("Errore") 
   input("PREMERE ENTER PER USCIRE")

