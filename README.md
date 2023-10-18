# Intelligenza-Artificiale-Prolog-Asp-
Progetto di programmazione Prolog e Asp

Il progetto Prolog consistono nell'implementare un sistema intelligente in grado di risolvere il problema del labirinto con più uscite.
è stata sviluppata in Prolog una strategia di ricerca non informata (Iterative deepening) e due strategie di ricerca informate (ida* e A*), nello spazio degli stati.
Il sistema è composto da almeno tre file: 
- un file contenente le definizioni dei predicati trasforma/3 e applicabile/2; 
- un file contenente i fatti che descrivono il dominio, lo stato iniziale e i goal; 
- un file contenente l’implementazione della strategia di ricerca.
Attraverso il predicato prova(Sol) viene restituito l'output con il risultato.

Il progetto Asp, invece, prevede l’utilizzo del paradigma ASP (Answer Set Programming) per la generazione con Clingo del calendario di una competizione sportiva, in particolare 
di un campionato avente le seguenti caratteristiche:
- sono iscritte 20 squadre;
- il campionato prevede 38 giornate, 19 di andata e 19 di ritorno NON simmetriche, ossia la giornata 1 di ritorno non coincide necessariamente con la giornata 1 di andata a campi invertiti; 
- ogni squadra fa riferimento ad una città, che offre la struttura in cui la squadra gioca gli incontri in casa;
- ogni squadra affronta due volte tutte le altre squadre, una volta in casa e una volta fuori casa, ossia una volta nella propria città di riferimento e una volta in quella dell’altra squadra;
- Due delle 20 squadre fanno riferimento alla medesima città e condividono la stessa struttura di gioco, quindi non possono giocare entrambe in casa nella stessa giornata. Ovviamente, fanno eccezione le due giornate in cui giocano l'una contro l'altra (derby).
