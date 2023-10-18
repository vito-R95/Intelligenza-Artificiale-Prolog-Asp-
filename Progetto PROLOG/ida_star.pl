/*
la parte iniziale definisce i costi associati a diverse azioni e il predicato 
CalcolaPassi calcola il totale delle Azioni
*/
costo(est, 1).
costo(ovest, 1).
costo(nord, 1).
costo(sud, 1).
costoTot([], 0).

costoTot([Azione|AltreAzioni], CostoTotale):-
    costoTot(AltreAzioni, CostoParziale),
    costo(Azione, CostoU),
    CostoTotale is CostoParziale + CostoU.

/*
Il predicato uscitaEuristica implementa una funzione euristica per valutare la distanza stimata tra uno stato attuale e una possibile uscita. 
Utilizza il predicato euristica/3 per calcolare l'euristica tra due stati e restituisce la distanza stimata in HMigliore.
*/
uscitaEuristica(Attuale, HMigliore):-
  findall(Finale, finale(Finale), ListaUscite),
  uscitaEuristica_C(Attuale, ListaUscite, HMigliore).

uscitaEuristica_C(Attuale, [UscitaAttuale], H):-
  euristica(Attuale, UscitaAttuale, H).

uscitaEuristica_C(Attuale, [UscitaAttuale|RestoUscite], DistAttuale):-
  uscitaEuristica_C(Attuale, RestoUscite, HMiglioreParziale),
  euristica(Attuale, UscitaAttuale, DistAttuale),
  DistAttuale < HMiglioreParziale.

 uscitaEuristica_C(Attuale, [UscitaAttuale|RestoUscite], HMiglioreParziale):-
  uscitaEuristica_C(Attuale, RestoUscite, HMiglioreParziale),
  euristica(Attuale, UscitaAttuale, DistAttuale),
  DistAttuale >= HMiglioreParziale.

%Distanza di Manhattan
euristica(pos(Riga1, Colonna1), pos(Riga2, Colonna2), H) :-
  H is abs(Riga1-Riga2) + abs(Colonna1-Colonna2).
  %Euclidea
  %H is sqrt((Riga1 - Riga2)^2 + (Colonna1 - Colonna2)^2).


/*
Il predicato aggiorna_costo_min viene utilizzato per aggiornare il costo minimo globale raggiunto durante la ricerca.
*/
aggiorna_costo_min(TCosto):-
  costo_min(TMin),
  TCosto<TMin,
  retract(costo_min(TMin)),
  assert(costo_min(TCosto)).
  

/*
il predicato prova(ListaAz) è l'entryPoint del programma, chiama il predicato limitedIda che deve restituire una sol ottima,questo predicato invoca ida_C che dopo 
 controlla se la soglia è rispettata, se l'azione è applicabile, se lo stato successivo non è stato già visitato 
 e calcola la stima del costo del percorso tramite l'euristica e il costo parziale. 
 Successivamente, richiama ricorsivamente ida_C con lo stato successivo fino a trovare la soluzione ottima o superare la soglia. 
*/
prova(ListaAz):-
  iniziale(Start),
  uscitaEuristica(Start, SogliaIniziale),
  num_righe(NR),
  num_colonne(NC),
  FCMax is NR * NC,
  assert(costo_min(FCMax)),
  limiteIda(Soluzione, SogliaIniziale, Start),
  reverse(ListaAz, Soluzione),
  costoTot(Soluzione, CostoCammino),
  /*write(Soluzione),*/
  write(CostoCammino).

limiteIda(Soluzione, Soglia, S_Attuale):-
  ida_C(node(S_Attuale, [], Soglia), Soluzione, [S_Attuale], Soglia).

limiteIda(Soluzione, Soglia, S_Attuale):-
  costo_min(NuovaSoglia),
  retract(costo_min(NuovaSoglia)),
  num_righe(NR),
  num_colonne(NC),
  FCMax is NR * NC,
  assert(costo_min(FCMax)),
  \+NuovaSoglia = Soglia,
  limiteIda(Soluzione, NuovaSoglia, S_Attuale).

ida_C(node(S_Attuale, Azioni, _), Azioni, _, _):-
  finale(S_Attuale).

ida_C(node(S_Attuale, Azioni, TCosto), Soluzione, Visitati, Soglia):-
  TCosto =< Soglia,
  applicabile(NuovaAzione, S_Attuale),
  trasforma(NuovaAzione, S_Attuale, S_Nuovo),
  \+member(S_Nuovo, Visitati),
  uscitaEuristica(S_Attuale, H_Costo),
  costoTot([NuovaAzione|Azioni], CostoU),
  TCostoNuovo is H_Costo + CostoU,
  ida_C(node(S_Nuovo, [NuovaAzione|Azioni], TCostoNuovo), Soluzione, [S_Nuovo|Visitati], Soglia).

ida_C(node(S_Attuale, Azioni, TCosto), Azioni, _, Soglia):-
  TCosto > Soglia,
  aggiorna_costo_min(TCosto),
  finale(S_Attuale).
