/*
la parte iniziale definisce i costi associati a diverse azioni e il predicato 
CalcolaPassi calcola il totale delle Azioni
*/
costo(sud, 1).  
costo(ovest, 1).
costo(nord, 1).
costo(est, 1).
costoPassi([], 0).

costoPassi([Azione|AltreAzioni], G_costo_totale):-
    costoPassi(AltreAzioni, G_costo_parziale),
    costo(Azione, G_costo),
    G_costo_totale is G_costo_parziale + G_costo.

/*
prova(ListaAz) è l'entry point del programma e richiama il predicato id passandogli una lista di azioni, inizialmente vuota e una Soglia di valore 0.
Successivamente viene chiamato il predicato Depth_Limit_search che è utilizzato per cercare un cammino con una determinata soglia.
*/
prova(ListaAz):-
  id(ListaAz, 0).

id(ListaAz, Soglia):-
  depth_limit_search(ListaAz, Soglia),
  costoPassi(ListaAz, CostoCammino),
  write(CostoCammino).

/*
Se la soglia corrente non è sufficente per trovare un cammino allora il predicato id aumenta la soglia di 1 e verifica che la soglia Nuova sia minore della 
Soglia Massima.
A questo punto viene chiamato ricorsivamente il predicato id con la nuova soglia. 
*/
id(ListaAz, Soglia):-
  NuovaSoglia is Soglia + 1,
  num_righe(NR),
  num_colonne(NC),
  SogliaMax is (NR * NC) / 2,
  NuovaSoglia < SogliaMax,
  id(ListaAz, NuovaSoglia).

/*
A questo la ricerca dfs chiamata dal predicato depth_limit_search puo avere inizio e si gestiscono i casi base
-1 se la soglia è 0 allora termina e quindi lo stato corrente è lo stato finale
-2 se la soglia è >0 allora prosegue la ricerca verificando se è possibile applicare una determinata Azione allo stato S, se è possibile viene calcolato il nuovo stato 
   e viene verificato che il Nuovo Stato non sia gia stato verificato (\+member(SNuovo,Visitati)).
   infine si decrementa la soglia e si chiama ricorsivamente il predicato di ricerca dfs con il nuovo stato, la coda delle azioni rimanenti e la lista aggiornata degli stati visitati
*/
depth_limit_search(ListaAz, Soglia):-
  iniziale(S),
  dfs_aux(S, ListaAz, [S], Soglia).

dfs_aux(S,[],_,_):-
  finale(S).

dfs_aux(S,[Azione|AzioniTail], Visitati, Soglia):-
    Soglia>0,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia-1,
    dfs_aux(SNuovo, AzioniTail,[SNuovo|Visitati], NuovaSoglia).