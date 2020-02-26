				   Copyright @ 2019 Grecu Andrei-George, All rights reserved
				   
	Abstract Syntax Tree Prefixes

	TEXT : https://ocw.cs.pub.ro/courses/iocla/teme/tema-1

	Structure:
		main --- rfunction --- atoi --- len
				   \__ eval

	Explanation:
		Main:		Se pune root-ul pe stiva si se apeleaza functia recursiva.
				Rezultatul va fi pus in locul root-ului initial, in eax, se dereferentiaza si se afiseaza. 

		rfunction: 	Se verifica intai stanga. Daca este 0, inseamna ca root-ul este copil si se calculeaza atoi
			pentru el. Daca nu, se apeleaza din nou functia pentru stanga.
				La intoarcerea din recursivitate, se apeleaza functia recursiva pentru dreapta.
				La final, se face evaluarea pentru copii root-ului, cu operatia din root.

		atoi:		Se calculeaza intai lungimea stringului si se salveaza in ecx. In cazul in care primul caracter
			e "-", adica numarul este negativ, se retine in registrul edi valoarea 1 pentru o midificare ulterioara a integer-ului
			rezultat. Se ia char cu char si se transforma in decimal, scazand din fiecare 0x30, "offset-ul".
				Dupa prelucrarea stringului, se verifica registrul edi, si daca acesta e 1, numarul se neaga, adica forma
			finala este de numar negativ.

		len:		Se calculeaza lungimea string-ului.

		eval:		Se verifica semnul din root si se alege operatia corespunzatoare.
				Se prelucreaza datele, eax - valoarea din stanga, edx - valoarea din dreapta, si se retine rezultatul in eax.




















