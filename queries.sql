DROP SCHEMA prova;
CREATE SCHEMA prova;
USE prova; 

CREATE TABLE Agriturismo(
	Codice INT AUTO_INCREMENT,
	Nome VARCHAR(80),
	PRIMARY KEY(Codice)
);

CREATE TABLE Stalla(
	ID INT AUTO_INCREMENT,
	Agriturismo INT NOT NULL,
	FOREIGN KEY (Agriturismo) REFERENCES Agriturismo(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE Locale(
	Codice INT AUTO_INCREMENT, 
	SogliaCompostiVolatili DOUBLE, 
	SogliaSporcizia DOUBLE,
	Larghezza DOUBLE,
	Lunghezza DOUBLE,
	Altezza DOUBLE,
	PuntoCardinale DOUBLE,
	Pavimentazione VARCHAR(80),
	FrequenzaMonitoraggio DOUBLE,
	Stalla INT NOT NULL,
	FOREIGN KEY (Stalla) REFERENCES Stalla(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE Specie(
	Nome VARCHAR(80),
	PRIMARY KEY(Nome)
);

CREATE TABLE Animale(
	Codice INT AUTO_INCREMENT, 
	Sesso VARCHAR(20) DEFAULT "Non definito", 
	Data_Nascita DATE NOT NULL, 
	Altezza DOUBLE DEFAULT 0, 
	Peso DOUBLE DEFAULT 0, 
	Locale INT NOT NULL, 
	Specie VARCHAR(80) NOT NULL, 
	Acquistato BIT NOT NULL,
	FOREIGN KEY (Specie) REFERENCES Specie(Nome),
	FOREIGN KEY (Locale) REFERENCES Locale(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Fornitore(
	PartitaIVA VARCHAR(80), 
	Nome VARCHAR(50) NOT NULL, 
	RagioneSociale VARCHAR(80), 
	Indirizzo VARCHAR(60), 
	PRIMARY KEY(PartitaIVA)
);

CREATE TABLE Acquisto(
	Animale INT, 
	Fornitore VARCHAR(80), 
	DataAcquisto DATE, 
	DataArrivo DATE, 
	FOREIGN KEY (Animale) REFERENCES Animale(Codice),
	FOREIGN KEY (Fornitore) REFERENCES Fornitore(PartitaIVA),
	PRIMARY KEY(Animale, Fornitore)
);

CREATE TABLE Parentela(
	Genitore INT,
	Figlio INT,
	FOREIGN KEY (Genitore) REFERENCES Animale(Codice),
	FOREIGN KEY (Figlio) REFERENCES Animale(Codice),
	PRIMARY KEY(Genitore, Figlio)
);

CREATE TABLE Locazione(
	Locale INT, 
	Specie VARCHAR(80), 
	N_Massimo INT, 
	FOREIGN KEY (Locale) REFERENCES Locale(Codice),
	FOREIGN KEY (Specie) REFERENCES Specie(Nome),
	PRIMARY KEY(Locale, Specie)
);

CREATE TABLE Allestimento(
	ID INT AUTO_INCREMENT,
	Locale INT NOT NULL,
	FOREIGN KEY (Locale) REFERENCES Locale(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE Dispositivo(
	Codice INT AUTO_INCREMENT,
	Tipo VARCHAR(80),
	Allestimento INT NOT NULL,
	FOREIGN KEY (Allestimento) REFERENCES Allestimento(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE Abbeveratoio(
	Codice INT AUTO_INCREMENT,
	Allestimento INT,
	FOREIGN KEY (Allestimento) REFERENCES Allestimento(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE StatoAbbeveratoio(
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Abbeveratoio INT,
	Quantità DOUBLE DEFAULT 0,
	Vitamine DOUBLE DEFAULT 0,
	SaliMinerali DOUBLE DEFAULT 0,
	FOREIGN KEY (Abbeveratoio) REFERENCES Abbeveratoio(Codice),
	PRIMARY KEY(Timestamp, Abbeveratoio)
);

CREATE TABLE Mangiatoia(
	Codice INT AUTO_INCREMENT,
	Allestimento INT NOT NULL,
	FOREIGN KEY (Allestimento) REFERENCES Allestimento(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE StatoMangiatoia(
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Mangiatoia INT,
	QuantitàForaggio DOUBLE DEFAULT 0,
	FOREIGN KEY (Mangiatoia) REFERENCES Mangiatoia(Codice),
	PRIMARY KEY(Timestamp, Mangiatoia)
);

CREATE TABLE Foraggio(
	Codice INT,
	Tipo VARCHAR(80),
	Fibre DOUBLE DEFAULT 0,
	Proteine DOUBLE DEFAULT 0,
	Glucidi DOUBLE DEFAULT 0,
	EnergiaKG DOUBLE,
	Conservazione VARCHAR(80),
	PRIMARY KEY(Codice)
);

CREATE TABLE Pasto(
	Timestamp TIMESTAMP,
	Mangiatoia INT,
	Foraggio INT,
	Orario TIME, 
	FOREIGN KEY (Mangiatoia) REFERENCES Mangiatoia(Codice),
	FOREIGN KEY (Foraggio) REFERENCES Foraggio(Codice),
	PRIMARY KEY(Timestamp, Mangiatoia, Foraggio)
);

CREATE TABLE Componente(
	Codice INT,
	Tipo VARCHAR(80),
	PRIMARY KEY(Codice)
);

CREATE TABLE Veterinario(
	Codice INT AUTO_INCREMENT,
	Nome VARCHAR(80) NOT NULL,
	Cognome VARCHAR(80) NOT NULL,
	PRIMARY KEY(Codice)
);

CREATE TABLE Specializzazione(
	Tipo VARCHAR(80),
	PRIMARY KEY(Tipo)
);

CREATE TABLE Abilita(
	Veterinario INT,
	Specializzazione VARCHAR(80),
	FOREIGN KEY (Veterinario) REFERENCES Veterinario(Codice),
	FOREIGN KEY (Specializzazione) REFERENCES Specializzazione(Tipo),
	PRIMARY KEY(Veterinario, Specializzazione)
);

CREATE TABLE Composizione(
	Foraggio INT,
	Componente INT,
	Percentuale DOUBLE DEFAULT 0,
	FOREIGN KEY (Foraggio) REFERENCES Foraggio(Codice),
	FOREIGN KEY (Componente) REFERENCES Componente(Codice),
	PRIMARY KEY(Foraggio, Componente)
);

CREATE TABLE StatoLocale(
	Locale INT,
	Timestamp TIMESTAMP,
	Gradi DOUBLE DEFAULT 0,
	Umidita DOUBLE DEFAULT 0,
	FOREIGN KEY (Locale) REFERENCES Locale(Codice),
	PRIMARY KEY(Locale, Timestamp)
);

CREATE TABLE StatoPulizia(
	Timestamp TIMESTAMP,
	Locale INT,
	LivelloSporcizia INT DEFAULT 0,
	LivelloAzoto INT DEFAULT 0,
	LivelloMetano INT DEFAULT 0,
	FOREIGN KEY (Locale) REFERENCES Locale(Codice),
	PRIMARY KEY(Timestamp, Locale)
);

CREATE TABLE Personale(
	Codice INT AUTO_INCREMENT,
	Nome VARCHAR(80) NOT NULL,
	Cognome VARCHAR(80) NOT NULL,
	Ruolo VARCHAR(70) NOT NULL,
	PRIMARY KEY(Codice)
);

CREATE TABLE RichiestaPulizia(
	Personale INT,
	Timestamp TIMESTAMP,
	Locale INT,
	Stato VARCHAR(80),
	FOREIGN KEY (Personale) REFERENCES Personale(Codice),
	FOREIGN KEY (Timestamp) REFERENCES StatoPulizia(Timestamp),
	FOREIGN KEY (Locale) REFERENCES StatoPulizia(Locale),
	PRIMARY KEY(Personale, Timestamp, Locale)
);

CREATE TABLE PosizioneGPS(
	ID INT,
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Latitudine DOUBLE NOT NULL,
	Longitudine DOUBLE NOT NULL,
	PRIMARY KEY(ID)
);

CREATE TABLE Geolocalizzazione(
	PosizioneGPS INT,
	Animale INT,
	FOREIGN KEY (PosizioneGPS) REFERENCES PosizioneGPS(ID),
	FOREIGN KEY (Animale) REFERENCES Animale(Codice),
	PRIMARY KEY(PosizioneGPS, Animale)
);

CREATE TABLE Zona(
	ID INT AUTO_INCREMENT,
	Agriturismo INT NOT NULL,
	FOREIGN KEY (Agriturismo) REFERENCES Agriturismo(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE Pascolo(
	Codice INT,
	OraInizio TIME NOT NULL,
	OraFine TIME,
	Data DATE,
	Zona INT NOT NULL,
	FOREIGN KEY (Zona) REFERENCES Zona(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE Attivita(
	Pascolo INT,
	Animale INT,
	OraRientro TIME,
	FOREIGN KEY (Pascolo) REFERENCES Pascolo(Codice),
	FOREIGN KEY (Animale) REFERENCES Animale(Codice),
	PRIMARY KEY(Pascolo, Animale)
);

CREATE TABLE Recinzione(
	Codice INT AUTO_INCREMENT,
	Zona INT NOT NULL,
	FOREIGN KEY (Zona) REFERENCES Zona(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE Cardine(
	Tipo VARCHAR(80),
	PRIMARY KEY(Tipo)
);

CREATE TABLE Confine(
	Recinzione INT,
	Cardine VARCHAR(80),
	Longitudine DOUBLE NOT NULL,
	Latitudine DOUBLE NOT NULL,
	FOREIGN KEY (Recinzione) REFERENCES Recinzione(Codice),
	FOREIGN KEY (Cardine) REFERENCES Cardine(Tipo),
	PRIMARY KEY(Recinzione, Cardine)
);

CREATE TABLE SchedaMedica(
	Animale INT,
	DataUltimoAggiornamento DATE,
	FOREIGN KEY (Animale) REFERENCES Animale(Codice),
	PRIMARY KEY(Animale)
);

CREATE TABLE Indicatore(
	Nome VARCHAR(80),
	PRIMARY KEY(Nome)
);

CREATE TABLE Punteggio(
	SchedaMedica INT,
	Indicatore VARCHAR(80),
	Livello INT DEFAULT 0,
	FOREIGN KEY (SchedaMedica) REFERENCES SchedaMedica(Animale),
	FOREIGN KEY (Indicatore) REFERENCES Indicatore(Nome),
	PRIMARY KEY(SchedaMedica, Indicatore)
);

CREATE TABLE Lesione(
	ID INT AUTO_INCREMENT,
	Tipologia VARCHAR(80),
	Entita VARCHAR(80),
	ParteCorpo VARCHAR(80),
	PRIMARY KEY(ID)
);

CREATE TABLE Possibilita(
	Lesione INT,
	SchedaMedica INT,
	FOREIGN KEY (Lesione) REFERENCES Lesione(ID),
	FOREIGN KEY (SchedaMedica) REFERENCES SchedaMedica(Animale),
	PRIMARY KEY(Lesione, SchedaMedica)
);

CREATE TABLE DisturboComportamentale(
	Nome VARCHAR(80),
	Entita VARCHAR(80),
	PRIMARY KEY(Nome)
);

CREATE TABLE Riscontro(
	DisturboComportamentale VARCHAR(80),
	SchedaMedica INT,
	FOREIGN KEY (DisturboComportamentale) REFERENCES DisturboComportamentale(Nome),
	FOREIGN KEY (SchedaMedica) REFERENCES SchedaMedica(Animale),
	PRIMARY KEY(DisturboComportamentale, SchedaMedica)
);

CREATE TABLE Terapia(
	Codice INT AUTO_INCREMENT,
	DataInizio DATE,
	DataFine DATE,
	Esito VARCHAR(80) DEFAULT 'Non specificato',
	Veterinario INT,
	FOREIGN KEY (Veterinario) REFERENCES Veterinario(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Quarantena(
	Animale INT,
	DataInizio DATE,
	DataFine DATE,
	ConseguenzaTerapia INT,
	FOREIGN KEY (ConseguenzaTerapia) REFERENCES Terapia(Codice),
	PRIMARY KEY(Animale, DataInizio)
);

CREATE TABLE Medicinale(
	Nome VARCHAR(80),
	PrincipioAttivo VARCHAR(70),
	Tipo VARCHAR(100),
	PRIMARY KEY(Nome)
);

CREATE TABLE Somministrazione(
	Terapia INT,
	Medicinale VARCHAR(80),
	DataInizio DATE,
	DataFine DATE,
	FOREIGN KEY (Terapia) REFERENCES Terapia(Codice),
	FOREIGN KEY (Medicinale) REFERENCES Medicinale(Nome),
	PRIMARY KEY(Terapia, Medicinale, DataInizio)
);

CREATE TABLE Orario(
	Ora TIME,
	PRIMARY KEY(Ora)
);

CREATE TABLE Dosaggio(
	Terapia INT,
	Medicinale VARCHAR(80),
	DataInizio DATE,
	Orario TIME,
	Dose DOUBLE DEFAULT 1,
	FOREIGN KEY (Terapia, Medicinale, DataInizio) REFERENCES Somministrazione(Terapia, Medicinale, DataInizio),
	UNIQUE(Terapia, Dose),
	UNIQUE(Terapia, Orario),
	PRIMARY KEY(Terapia, Medicinale, DataInizio, Orario)
);

CREATE TABLE VisitaDiControllo(
	ID INT AUTO_INCREMENT,
	Descrizione VARCHAR(100),
	Data DATE,
	Animale INT NOT NULL,
	Veterinario INT NOT NULL, 
	FOREIGN KEY (Animale) REFERENCES Animale(Codice),
	FOREIGN KEY (Veterinario) REFERENCES Veterinario(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE Risultato(
	VisitaDiControllo INT,
	Indicatore VARCHAR(80),
	Punteggio INT DEFAULT 0,
	FOREIGN KEY (VisitaDiControllo) REFERENCES VisitaDiControllo(ID),
	FOREIGN KEY (Indicatore) REFERENCES Indicatore(Nome),
	PRIMARY KEY(VisitaDiControllo, Indicatore)
);

CREATE TABLE Disfunzione(
	Codice INT AUTO_INCREMENT,
	Nome VARCHAR(80) NOT NULL,
	Tipo VARCHAR(70),
	Gravita INT,
	Data DATE,
	DataGuarigione DATE,
	VisitaRiferimento INT,
	FOREIGN KEY (VisitaRiferimento) REFERENCES VisitaDiControllo(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE Prescrizione(
	Disfunzione INT,
	Terapia INT,
	FOREIGN KEY (Disfunzione) REFERENCES Disfunzione(Codice),
	FOREIGN KEY (Terapia) REFERENCES Terapia(Codice),
	PRIMARY KEY(Disfunzione, Terapia)
);

CREATE TABLE Riproduzione(
	ID INT AUTO_INCREMENT,
	Data DATE,
	Orario TIME,
	Stato VARCHAR(80),
	Veterinario INT NOT NULL,
	FOREIGN KEY (Veterinario) REFERENCES Veterinario(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE Partecipazione(
	Animale INT,
	Riproduzione INT,
	FOREIGN KEY (Animale) REFERENCES Animale(Codice),
	FOREIGN KEY (Riproduzione) REFERENCES Riproduzione(ID),
	PRIMARY KEY(Animale, Riproduzione)
);

CREATE TABLE Complicanza(
	Codice INT AUTO_INCREMENT,
	Data DATE,
	Tipo VARCHAR(80),
	Riproduzione INT NOT NULL,
	FOREIGN KEY (Riproduzione) REFERENCES Riproduzione(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE SchedaDiGestazione(
	Riproduzione INT,
	Veterinario INT NOT NULL,
	DataSottoscrizione DATE,
	FOREIGN KEY (Riproduzione) REFERENCES Riproduzione(ID),
	FOREIGN KEY (Veterinario) REFERENCES Veterinario(Codice),
	PRIMARY KEY(Riproduzione)
);

CREATE TABLE InterventoDiControllo(
	ID INT AUTO_INCREMENT,
	Stato VARCHAR(80) NOT NULL,
	DataProgrammata DATE,
	DataEffettiva DATE,
	SchedaDiGestazione INT NOT NULL,
	Esito BIT,
    Veterinario INT,
	FOREIGN KEY (SchedaDiGestazione) REFERENCES SchedaDiGestazione(Riproduzione),
    FOREIGN KEY (Veterinario) REFERENCES Veterinario(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE Conseguenza(
	InterventoDiControllo INT,
	Terapia INT,
	FOREIGN KEY (InterventoDiControllo) REFERENCES InterventoDiControllo(ID),
	FOREIGN KEY (Terapia) REFERENCES Terapia(Codice),
	PRIMARY KEY(InterventoDiControllo, Terapia)
);


CREATE TABLE EsameDiagnostico(
	Codice INT AUTO_INCREMENT,
	Nome VARCHAR(80) NOT NULL,
	Macchinario VARCHAR(80),
	DescrizioneProcedura VARCHAR(200),
	Data DATE NOT NULL,
	PRIMARY KEY(Codice)
);

CREATE TABLE Decisione(
	InterventoDiControllo INT,
	EsameDiagnostico INT,
	FOREIGN KEY (InterventoDiControllo) REFERENCES InterventoDiControllo(ID),
	FOREIGN KEY (EsameDiagnostico) REFERENCES EsameDiagnostico(Codice),
	PRIMARY KEY(InterventoDiControllo, EsameDiagnostico)
);

CREATE TABLE Mungitrice(
	Codice INT AUTO_INCREMENT,
    Modello VARCHAR(80),
    Marca VARCHAR(80),
	PRIMARY KEY(Codice)
);

CREATE TABLE Mungitura(
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Mungitrice INT,
	FOREIGN KEY (Mungitrice) REFERENCES Mungitrice(Codice),
	PRIMARY KEY(Timestamp, Mungitrice)
);

CREATE TABLE Latte(
	Animale INT,
	Quantita DOUBLE,
	Timestamp TIMESTAMP,
	Mungitrice INT,
	FOREIGN KEY (Animale) REFERENCES Animale(Codice),
	FOREIGN KEY (Timestamp) REFERENCES Mungitura(Timestamp),
	FOREIGN KEY (Mungitrice) REFERENCES Mungitura(Mungitrice),
	PRIMARY KEY(Animale, Quantita, Timestamp, Mungitrice)
);


CREATE TABLE Silos(
	Codice INT AUTO_INCREMENT,
	Capacita DOUBLE,
	PRIMARY KEY(Codice)
);

CREATE TABLE Raccolta(
	Animale INT,
	Quantita DOUBLE,
    Timestamp TIMESTAMP,
	Mungitrice INT,
	Silos INT,
	FOREIGN KEY (Animale, Quantita, Timestamp, Mungitrice) REFERENCES Latte(Animale, Quantita, Timestamp,Mungitrice),
	FOREIGN KEY (Silos) REFERENCES Silos(Codice),
	PRIMARY KEY(Animale, Quantita, Timestamp, Mungitrice, Silos)
);

CREATE TABLE Sostanza(
	Nome VARCHAR(80),
	PRIMARY KEY(Nome)
);

CREATE TABLE Presenza(
	Animale INT,
	Quantita DOUBLE,
	Timestamp TIMESTAMP,
	Mungitrice INT,
	Sostanza VARCHAR(80),
	Densita DOUBLE DEFAULT 0,
	FOREIGN KEY (Animale, Quantita, Timestamp, Mungitrice) REFERENCES Latte(Animale, Quantita, Timestamp, Mungitrice),
	FOREIGN KEY (Sostanza) REFERENCES Sostanza(Nome),
	PRIMARY KEY(Animale, Quantita, Timestamp, Mungitrice, Sostanza)
);

CREATE TABLE Posizione(
	PosizioneGPS INT,
	Mungitrice INT,
	FOREIGN KEY (PosizioneGPS) REFERENCES PosizioneGPS(ID),
	FOREIGN KEY (Mungitrice) REFERENCES Mungitrice(Codice),
	PRIMARY KEY(PosizioneGPS, Mungitrice)
);

CREATE TABLE Laboratorio(
	Codice INT AUTO_INCREMENT,
	Dimensione DOUBLE DEFAULT 0,
	Agriturismo INT,
	FOREIGN KEY (Agriturismo) REFERENCES Agriturismo(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Lotto(
	Codice INT AUTO_INCREMENT,
	Data DATE,
	DataScadenza DATE,
	DurataComplessiva DOUBLE,
	Laboratorio INT NOT NULL,
	FOREIGN KEY (Laboratorio) REFERENCES Laboratorio(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Ricetta(
	Nome VARCHAR(80),
	Descrizione VARCHAR(200),
	ZonaGeoGraficaOrigine VARCHAR(100),
	TempoStagionatura INT, -- giorni
	PRIMARY KEY(Nome)
);

CREATE TABLE Prodotto(
	Nome VARCHAR(80),
	GradoDiReperibilita INT,
	Prezzo DOUBLE NOT NULL,
	Tipo VARCHAR(80),
	Ricetta VARCHAR(80) NOT NULL,
    NumeroVendite INT DEFAULT 0,
	FOREIGN KEY (Ricetta) REFERENCES Ricetta(Nome),
	PRIMARY KEY (Nome)
);

CREATE TABLE Processo(
	Codice INT AUTO_INCREMENT,
	PRIMARY KEY(Codice)
);

CREATE TABLE Unita(
	Codice INT AUTO_INCREMENT,
	Peso DOUBLE DEFAULT 0, 
	Prodotto VARCHAR(80),
	Processo INT NOT NULL,
	Lotto INT NOT NULL,
	FOREIGN KEY (Prodotto) REFERENCES Prodotto(Nome),
	FOREIGN KEY (Processo) REFERENCES Processo(Codice),
	FOREIGN KEY (Lotto) REFERENCES Lotto(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Impiego(
	Lotto INT,
	Silos INT,
	FOREIGN KEY (Lotto) REFERENCES Lotto(Codice),
	FOREIGN KEY (Silos) REFERENCES Silos(Codice),
	PRIMARY KEY(Lotto, Silos)
);

CREATE TABLE Dipendente(
	Codice INT AUTO_INCREMENT,
	Nome VARCHAR(80) NOT NULL,
	PRIMARY KEY(Codice)
);

CREATE TABLE Lavoro(
	Dipendente INT,
	Lotto INT,
	FOREIGN KEY (Dipendente) REFERENCES Dipendente(Codice),
	FOREIGN KEY (Lotto) REFERENCES Lotto(Codice),
	PRIMARY KEY(Dipendente, Lotto)
);

CREATE TABLE FaseIdeale(
	ID INT AUTO_INCREMENT,
	Durata INT, -- minuti 
	Ricetta VARCHAR(80),
	FOREIGN KEY (Ricetta) REFERENCES Ricetta(Nome),
	PRIMARY KEY(ID)
);

CREATE TABLE ParametroIdeale(
	Nome VARCHAR(80),
	PRIMARY KEY(Nome)
);

CREATE TABLE CombinazioneIdeale(
	FaseIdeale INT,
	ParametroIdeale VARCHAR(80), 
	Valore DOUBLE DEFAULT 0,
	FOREIGN KEY (FaseIdeale) REFERENCES FaseIdeale(ID),
	FOREIGN KEY (ParametroIdeale) REFERENCES ParametroIdeale(Nome),
	PRIMARY KEY(FaseIdeale, ParametroIdeale)
);

CREATE TABLE FaseEffettiva(
	ID INT AUTO_INCREMENT,
	Durata INT, -- minuti
	Processo INT NOT NULL,
	FOREIGN KEY (Processo) REFERENCES Processo(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE ParametroEffettivo(
	Nome VARCHAR(80),
	PRIMARY KEY(Nome)
);

CREATE TABLE Combinazione(
	FaseEffettiva INT,
	ParametroEffettivo VARCHAR(80), 
	Valore DOUBLE DEFAULT 0,
	FOREIGN KEY (FaseEffettiva) REFERENCES FaseEffettiva(ID),
	FOREIGN KEY (ParametroEffettivo) REFERENCES ParametroEffettivo(Nome),
	PRIMARY KEY(FaseEffettiva, ParametroEffettivo)
);

CREATE TABLE Magazzino(
	ID INT AUTO_INCREMENT,
	Agriturismo INT NOT NULL,
	FOREIGN KEY (Agriturismo) REFERENCES Agriturismo(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE ScaffalaturaMagazzino(
	Codice INT AUTO_INCREMENT,
	Capienza INT,
	Magazzino INT NOT NULL, 
	FOREIGN KEY (Magazzino) REFERENCES Magazzino(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE Cantina(
	ID INT AUTO_INCREMENT,
	Agriturismo INT NOT NULL,
	FOREIGN KEY (Agriturismo) REFERENCES Agriturismo(Codice),
	PRIMARY KEY(ID)
);

CREATE TABLE ScaffalaturaCantina(
	Codice INT AUTO_INCREMENT,
	Capienza INT,
	Cantina INT NOT NULL, 
	FOREIGN KEY (Cantina) REFERENCES Cantina(ID),
	PRIMARY KEY(Codice)
);

CREATE TABLE Sistemazione(
	Unita INT,
	ScaffalaturaMagazzino INT,
	Posizione INT DEFAULT 0,
	FOREIGN KEY (Unita) REFERENCES Unita(Codice),
	FOREIGN KEY (ScaffalaturaMagazzino) REFERENCES ScaffalaturaMagazzino(Codice),
	UNIQUE(ScaffalaturaMagazzino, Posizione),
	PRIMARY KEY(Unita, ScaffalaturaMagazzino)
);

CREATE TABLE Stagionatura(
	Unita INT,
	ScaffalaturaCantina INT,
	DataInizio DATE NOT NULL,
	Durata INT, -- giorni
	Posizione INT DEFAULT 0,
	FOREIGN KEY (Unita) REFERENCES Unita(Codice),
	FOREIGN KEY (ScaffalaturaCantina) REFERENCES ScaffalaturaCantina(Codice),
	UNIQUE(ScaffalaturaCantina, Posizione),
	PRIMARY KEY(Unita, ScaffalaturaCantina)
);

CREATE TABLE StatoCantina(
	Data DATE,
	Cantina INT,
	Gradi DOUBLE,
	Umidita DOUBLE,
	QualitaAria DOUBLE,
	FOREIGN KEY (Cantina) REFERENCES Cantina(ID),
	PRIMARY KEY(Data, Cantina)
);

CREATE TABLE ClienteRegistrato(
	CodiceFiscale VARCHAR(20),
	Nome VARCHAR(30) NOT NULL,
	Cognome VARCHAR(40) NOT NULL,
	Indirizzo VARCHAR(50) NOT NULL,
	CodiceCartaDiCredito VARCHAR(70) NOT NULL,
	PRIMARY KEY(CodiceFiscale)
);

CREATE TABLE ClienteNonRegistrato(
	CodiceFiscale VARCHAR(20),
	CodiceCartaPagamento VARCHAR(70) NOT NULL,
	PRIMARY KEY(CodiceFiscale)
);

CREATE TABLE NumeroDiTelefono(
	Numero BIGINT,
	Cliente VARCHAR(20) NOT NULL,
	FOREIGN KEY (Cliente) REFERENCES ClienteRegistrato(CodiceFiscale),
	PRIMARY KEY(Numero)
);

CREATE TABLE Documento(
	Tipologia VARCHAR(20),
	Numero VARCHAR(30),
	Scadenza DATE NOT NULL,
	EnteDiRilascio VARCHAR(80) NOT NULL, 
	Cliente VARCHAR(20) NOT NULL,
	FOREIGN KEY (Cliente) REFERENCES ClienteRegistrato(CodiceFiscale),
	PRIMARY KEY(Tipologia, Numero)
);

CREATE TABLE Prenotazione(
	ID INT AUTO_INCREMENT,
	DataArrivo DATE NOT NULL,
	DataPartenza DATE,
    CostoComplessivo INT DEFAULT 0,
	PRIMARY KEY(ID)
);

CREATE TABLE Scelta(
	Prenotazione INT,
	ClienteNonRegistrato VARCHAR(20),
	FOREIGN KEY(Prenotazione) REFERENCES Prenotazione(ID),
	FOREIGN KEY(ClienteNonRegistrato) REFERENCES ClienteNonRegistrato(CodiceFiscale),
	PRIMARY KEY(Prenotazione, ClienteNonRegistrato)
);

CREATE TABLE Riserva(
	Prenotazione INT,
	ClienteRegistrato VARCHAR(20),
	FOREIGN KEY(Prenotazione) REFERENCES Prenotazione(ID),
	FOREIGN KEY(ClienteRegistrato) REFERENCES ClienteRegistrato(CodiceFiscale),
	PRIMARY KEY(Prenotazione, ClienteRegistrato)
);

CREATE TABLE ServizioAggiuntivo(
	Tipologia VARCHAR(70),
	Costo DOUBLE NOT NULL,
	PRIMARY KEY(Tipologia)
);

CREATE TABLE Richiesta(
	ServizioAggiuntivo VARCHAR(70),
	Prenotazione INT,
	Giorno DATE,
	FOREIGN KEY (ServizioAggiuntivo) REFERENCES ServizioAggiuntivo(Tipologia),
	FOREIGN KEY (Prenotazione) REFERENCES Prenotazione(ID),
	PRIMARY KEY(ServizioAggiuntivo, Prenotazione, Giorno)
);

CREATE TABLE Camera(	
	Codice INT AUTO_INCREMENT,
	Prezzo DOUBLE NOT NULL,
	PostiLettoSingoli INT DEFAULT 1,
	PostiLettoMatrimoniali INT DEFAULT 0,
	Agriturismo INT NOT NULL,
	FOREIGN KEY (Agriturismo) REFERENCES Agriturismo(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Soggiorno(	
	Camera INT,
	Prenotazione INT,
	FOREIGN KEY (Camera) REFERENCES Camera(Codice),
	FOREIGN KEY (Prenotazione) REFERENCES Prenotazione(ID),
	PRIMARY KEY(Camera, Prenotazione)
);

CREATE TABLE Guida(
	Codice INT,
	Nome VARCHAR(30),
	Cognome VARCHAR(40),
	PRIMARY KEY(Codice)
);

CREATE TABLE Escursione(
	Codice INT,
	Giorno DATE NOT NULL,
	OrarioDiInizio TIME NOT NULL,
	Costo DOUBLE NOT NULL,
	Guida INT NOT NULL,
	FOREIGN KEY (Guida) REFERENCES Guida(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Extra(	
	Prenotazione INT,
	Escursione INT,
	DataPrenotazione DATE,
	FOREIGN KEY (Prenotazione) REFERENCES Prenotazione(ID),
	FOREIGN KEY (Escursione) REFERENCES Escursione(Codice),
	PRIMARY KEY(Prenotazione, Escursione)
);

CREATE TABLE Itinerario(
	Codice INT AUTO_INCREMENT,
	PRIMARY KEY(Codice)
);

CREATE TABLE Mappa(
	Escursione INT,
	Itinerario INT,
	FOREIGN KEY (Escursione) REFERENCES Escursione(Codice),
	FOREIGN KEY (Itinerario) REFERENCES Itinerario(Codice),
	PRIMARY KEY(Escursione, Itinerario)
);

CREATE TABLE Area(
	Nome VARCHAR(50),
	Dimensione DOUBLE NOT NULL,
	Agriturismo INT NOT NULL,
	FOREIGN KEY (Agriturismo) REFERENCES Agriturismo(Codice),
	PRIMARY KEY(Nome)
);

CREATE TABLE Visita(
	Itinerario INT,
	Area VARCHAR(50),
	OraInizio TIME,
	OraFine TIME,
	FOREIGN KEY (Itinerario) REFERENCES Itinerario(Codice),
	FOREIGN KEY (Area) REFERENCES Area(Nome),
	PRIMARY KEY(Itinerario, Area)
);

CREATE TABLE Pagamento(
	ID INT AUTO_INCREMENT,
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CodiceCarta VARCHAR(80) NOT NULL,
	Importo DOUBLE NOT NULL,
	MetodoPagamento VARCHAR(80),
	Prenotazione INT NOT NULL,
	FOREIGN KEY (Prenotazione) REFERENCES Prenotazione(ID),
	PRIMARY KEY(ID)
);

CREATE TABLE Account(
	NomeUtente VARCHAR(80),
	Password VARCHAR(100) NOT NULL,
	DomandaPassword VARCHAR(200),
	RispostaPassword VARCHAR(200),
	Cliente VARCHAR(20) NOT NULL,
	DataIscrizione DATE,
	FOREIGN KEY (Cliente) REFERENCES ClienteRegistrato(CodiceFiscale),
	PRIMARY KEY(NomeUtente)
);

CREATE TABLE Ordine(
	Codice INT AUTO_INCREMENT,
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Stato VARCHAR(80) DEFAULT "in processazione",
	Account VARCHAR(80) NOT NULL,
	FOREIGN KEY (Account) REFERENCES Account(NomeUtente),
	PRIMARY KEY(Codice)
);

CREATE TABLE SceltaOrdine(
	Prodotto VARCHAR(80),
	Ordine INT,
	Quantita INT DEFAULT 1,
	FOREIGN KEY (Prodotto) REFERENCES Prodotto(Nome),
	FOREIGN KEY (Ordine) REFERENCES Ordine(Codice),
	PRIMARY KEY(Prodotto, Ordine)
);

CREATE TABLE ComposizioneOrdine(
	Unita INT,
	Ordine INT,
	FOREIGN KEY (Unita) REFERENCES Unita(Codice),
	FOREIGN KEY (Ordine) REFERENCES Ordine(Codice),
	PRIMARY KEY(Unita, Ordine)
);

CREATE TABLE Spedizione(
	Codice INT AUTO_INCREMENT,
	Stato VARCHAR(80),
	PRIMARY KEY(Codice)
);

CREATE TABLE Trasporto(
	Spedizione INT,
	Unita INT,
	DataConsegnaPrevista DATE NOT NULL,
	DataConsegnaEffettiva DATE,
	FOREIGN KEY (Spedizione) REFERENCES Spedizione(Codice),
	FOREIGN KEY (Unita) REFERENCES Unita(Codice),
	PRIMARY KEY(Spedizione, Unita)
);

CREATE TABLE Hub(
	Codice INT AUTO_INCREMENT,
	Zona VARCHAR(80),
	PRIMARY KEY(Codice)
);

CREATE TABLE Controllo(
	Spedizione INT,
	Hub INT,
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (Spedizione) REFERENCES Spedizione(Codice),
	FOREIGN KEY (Hub) REFERENCES Hub(Codice),
	PRIMARY KEY(Spedizione, Hub)
);

CREATE TABLE Recensione(
	Codice INT AUTO_INCREMENT,
	Commenti VARCHAR(200),
	Unita INT NOT NULL,
	Gusto INT,
	Conservazione INT,
	QualitaPercepita INT,
	GradimentoGenerale INT,
	FOREIGN KEY (Unita) REFERENCES Unita(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE ParametriDiQualita(
	Nome VARCHAR(80),
	PRIMARY KEY(Nome)
);

CREATE TABLE Reso(
	Codice INT AUTO_INCREMENT,
	Data DATE,
	Unita INT NOT NULL,
	FOREIGN KEY (Unita) REFERENCES Unita(Codice),
	PRIMARY KEY(Codice)
);

CREATE TABLE Analisi(
	Reso INT,
	Parametro VARCHAR(80),
	Punteggio DOUBLE,
	FOREIGN KEY (Reso) REFERENCES Reso(Codice),
	FOREIGN KEY (Parametro) REFERENCES ParametriDiQualita(Nome),
	PRIMARY KEY(Reso, Parametro)
);

-- VINCOLI

-- 1

DROP TRIGGER IF EXISTS CheckAcquisto;
DELIMITER $$
CREATE TRIGGER CheckAcquisto
BEFORE INSERT ON Acquisto FOR EACH ROW
	BEGIN
		DECLARE Acquisto INT DEFAULT 0;
		SELECT A.Acquistato INTO Acquisto
		FROM Animale A
		WHERE A.Codice = NEW.Animale;
		IF Acquisto = 0 THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "L animale in questione non è stato oggetto di acquisto";
		END IF;
	END $$
DELIMITER ;

-- 2
DROP TRIGGER IF EXISTS CheckLocale;
DELIMITER $$
CREATE TRIGGER CheckLocale
BEFORE INSERT ON Animale FOR EACH ROW
	BEGIN
		DECLARE Specie VARCHAR(80) DEFAULT "";
		
		SELECT L.Specie INTO Specie
		FROM Locazione L
		WHERE L.Locale = NEW.Locale;
		IF Specie = "" THEN
			INSERT INTO Locazione(Locale, Specie)
			VALUES(NEW.Locale, Specie);
		ELSEIF Specie <> NEW.Specie THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Un locale può ospitare solo animali della stessa specie! 	
								Questo locale possiede già animali di un’altra specie." ;
		END IF;
	END $$
DELIMITER ;

-- 3
DROP TRIGGER IF EXISTS CheckScheda;
DELIMITER $$
CREATE TRIGGER CheckScheda
BEFORE INSERT ON SchedaDiGestazione FOR EACH ROW
	BEGIN
		DECLARE Stato VARCHAR(80) DEFAULT ‘’;
		SELECT R.Stato INTO Stato
		FROM Riproduzione R
		WHERE R.ID = NEW.Riproduzione;
		IF Stato <> ‘successo’ THEN 
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Impossibile associare una scheda di gestazione ad una 
						scheda che non abbia avuto successo";
		END IF;
	END $$
DELIMITER ;

-- 4

DROP TRIGGER IF EXISTS CheckIntervento;
DELIMITER $$
CREATE TRIGGER CheckIntervento
BEFORE INSERT ON InterventoDiControllo FOR EACH ROW
	BEGIN
		IF NEW.DataProgrammata > CURRENT_DATE THEN
			SET NEW.Esito = "Programmato";
		END IF;
	END $$
DELIMITER ;

-- 5
DROP TRIGGER IF EXISTS CheckInterventoTerapia;
DELIMITER $$
CREATE TRIGGER CheckInterventoTerapia
BEFORE INSERT ON Conseguenza FOR EACH ROW
	BEGIN
		DECLARE Esito VARCHAR(80) DEFAULT ‘’;
		SELECT I.Esito INTO Esito
		FROM InterventoDiControllo I
		WHERE I.ID = NEW.InterventoDiControllo;

		IF Esito <> "Negativo" THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Terapia sottoscrivibile solo se l’intervento di controllo
						 abbia avuto esito negativo";
		END IF;
	END $$
DROP TRIGGER IF EXISTS CheckInterventoEsame$$
CREATE TRIGGER CheckInterventoEsame
BEFORE INSERT ON Decisione FOR EACH ROW
	BEGIN
		DECLARE Esito VARCHAR(80) DEFAULT ‘’;
		SELECT I.Esito INTO Esito
		FROM InterventoDiControllo I
		WHERE I.ID = NEW.InterventoDiControllo;

		IF Esito <> "Negativo" THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Esame sottoscrivibile solo se l’intervento di controllo
						 abbia avuto esito negativo";
		END IF;
	END $$
DELIMITER ;

-- 6
DROP TRIGGER IF EXISTS CheckLatte;
DELIMITER $$
CREATE TRIGGER CheckLatte
BEFORE INSERT ON Latte FOR EACH ROW
	BEGIN
		DECLARE Sesso VARCHAR(20) DEFAULT "";
		SELECT A.Sesso INTO SESSO
		FROM Animale A
		WHERE A.Codice = NEW.Animale;
		IF Sesso <> "F" THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Il latte può essere prodotto solo da animali di sesso femminile";
		END IF;
	END$$
DELIMITER ;

-- 7
DROP TRIGGER IF EXISTS CheckMagazzino;
DELIMITER $$
CREATE TRIGGER CheckMagazzino
BEFORE INSERT ON Sistemazione FOR EACH ROW
	BEGIN
		DECLARE Num INT DEFAULT 0;

		SELECT COUNT(*) INTO Num
		FROM Stagionatura S
		WHERE S.Unita = NEW.Unita;

		IF Num <> 0 THEN 
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Questa unità si trova già all’interno di una cantina!";
		END IF;
	END$$
DROP TRIGGER IF EXISTS CheckCantina$$
CREATE TRIGGER CheckCantina
BEFORE INSERT ON Stagionatura FOR EACH ROW
	BEGIN
		DECLARE Num INT DEFAULT 0;

		SELECT COUNT(*) INTO Num
		FROM Sistemazione S
		WHERE S.Unita = NEW.Unita;

		IF Num <> 0 THEN 
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Questa unità si trova già all’interno di un magazzino!";
		END IF;
	END$$
DELIMITER ;

-- 8
DROP TRIGGER IF EXISTS CheckMetodoPagamento;
DELIMITER $$
CREATE TRIGGER CheckMetodoPagamento
BEFORE INSERT ON Pagamento FOR EACH ROW
	BEGIN
		DECLARE NonReg INT DEFAULT 0;

		SELECT COUNT(*) INTO NonReg
		FROM Prenotazione PR
			INNER JOIN
            Scelta S ON S.Prenotazione = PR.ID
            INNER JOIN
			ClienteNonRegistrato C ON S.ClienteNonRegistrato = C.CodiceFiscale
		WHERE PR.ID = NEW.Prenotazione;

		IF NonReg <> 0  AND NEW.MetodoPagamento <> "Paypal" AND 
			NEW.MetodoPagamento <> "Carta di Credito" THEN 
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Gli unici metodi di pagamento ammessi sono PayPal o Carta di Credito poiché si tratta di un utente non registrato";
		END IF;
	END$$
DELIMITER ;

-- 9
DROP TRIGGER IF EXISTS CheckServizioAggiuntivo;
DELIMITER $$
CREATE TRIGGER CheckServizioAggiuntivo
BEFORE INSERT ON Richiesta FOR EACH ROW
	BEGIN
		DECLARE Num INT DEFAULT 0;

		SELECT COUNT(*) INTO Num
		FROM Soggiorno S
			INNER JOIN
			Camera C ON S.Camera = C.Codice
		WHERE S.Prenotazione = NEW.Prenotazione
			AND ( C.PostiLettoMatrimoniali >= 1 OR
			          C.PostiLettoSingoli > 1 );

		IF Num = 0 THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Servizi aggiuntivi possono essere prenotati solo in presenza di suite";
		END IF;
	END $$
DELIMITER ;

-- 10
DROP TRIGGER IF EXISTS CheckMetodoPagamento2;
DELIMITER $$
CREATE TRIGGER CheckMetodoPagamento2
BEFORE INSERT ON Pagamento FOR EACH ROW
	BEGIN
		IF NEW.MetodoPagamento <> "Contanti" AND 
		NEW.MetodoPagamento <> "Carta di credito" AND 
		NEW.MetodoPagamento <> "Carta di debito" AND
		NEW.MetodoPagamento <> "PayPal" THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Metodi di pagamento accettati : Contanti, Carta di Credito, Carta di debito, Paypal";
		END IF;
	END $$
DELIMITER ;

-- 11
DROP TRIGGER IF EXISTS CheckEscursione;
DELIMITER $$
CREATE TRIGGER CheckEscursione
BEFORE INSERT ON Extra FOR EACH ROW
	BEGIN
		DECLARE Giorno INT;
		SELECT Giorno INTO Giorno
        FROM Escursione 
        WHERE Codice = NEW.Escursione;
        
		IF NEW.DataPrenotazione > Giorno - INTERVAL 2 DAY THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Le escursioni devono essere prenotate con almeno 48 ore di anticipo";
		END IF;
	END $$
DELIMITER ;

-- 12
DROP TRIGGER IF EXISTS CheckStatoOrdine;
DELIMITER $$
CREATE TRIGGER CheckStatoOrdine
BEFORE INSERT ON Ordine FOR EACH ROW
	BEGIN
		IF NEW.Stato <> "in processazione" THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Lo stato inserito non è valido, lo stato iniziale deve essere ‘in processazione'";
		END IF;
	END $$

DROP TRIGGER IF EXISTS CheckAggiornamentoStatoOrdine$$
CREATE TRIGGER CheckAggiornamentoStatoOrdine
BEFORE UPDATE ON Ordine FOR EACH ROW
	BEGIN
		IF (OLD.Stato <> "in processazione" AND NEW.Stato = "in preparazione") 
		OR (OLD.Stato <> "in preparazione" AND NEW.Stato = "spedito")
		OR (OLD.Stato <> "spedito" AND NEW.Stato = "evaso")  THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Lo stato inserito non è valido";
		END IF;
	END $$
DELIMITER ;

-- 13
DROP TRIGGER IF EXISTS CheckStatoSpedizione;
DELIMITER $$
CREATE TRIGGER CheckStatoSpedizione
BEFORE INSERT ON Spedizione FOR EACH ROW
	BEGIN
		IF NEW.Stato <> "spedito" AND NEW.Stato <> "in transito" AND NEW.Stato <> "in consegna"
		AND NEW.Stato <> "consegnata" THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Lo stato inserito non è valido";
		END IF;
	END $$

DROP TRIGGER IF EXISTS CheckAggiornamentoStatoSpedizione$$
CREATE TRIGGER CheckAggiornamentoStatoSpedizione
BEFORE UPDATE ON Spedizione FOR EACH ROW
	BEGIN
		IF NEW.Stato <> "spedito" AND NEW.Stato <> "in transito" AND NEW.Stato <> "in consegna"
		AND NEW.Stato <> "consegnata" THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Lo stato inserito non è valido";
		END IF;
	END $$
DELIMITER ;

-- 14
DROP TRIGGER IF EXISTS CheckReso;
DELIMITER $$
CREATE TRIGGER CheckReso
BEFORE INSERT ON Reso FOR EACH ROW
	BEGIN
		DECLARE Data DATE;

		SELECT T.DataConsegnaEffettiva INTO Data
		FROM Trasporto T
		WHERE T.Unita = NEW.Unita;

		IF NEW.Data >= Data + INTERVAL 2 DAY THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "L’utente ha tempo 48 ore per l’eventuale reso";
		END IF;
	END $$
DELIMITER ;

-- 15
DROP TRIGGER IF EXISTS CheckClientePrenotazioneRiserva;
DELIMITER $$
CREATE TRIGGER CheckClientePrenotazioneRiserva
BEFORE INSERT ON Riserva FOR EACH ROW
	BEGIN
		IF EXISTS ( 	
			SELECT *
			FROM Scelta
			WHERE Prenotazione = NEW.Prenotazione ) 
		THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "La prenotazione è già stata legata ad un cliente";
		END IF;
	END $$
DELIMITER ;
DROP TRIGGER IF EXISTS CheckClientePrenotazioneScelta;
DELIMITER $$
CREATE TRIGGER CheckClientePrenotazioneScelta
BEFORE INSERT ON Scelta FOR EACH ROW
	BEGIN
		IF EXISTS ( 	
			SELECT *
			FROM Riserva
			WHERE Prenotazione = NEW.Prenotazione ) 
		THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "La prenotazione è già stata legata ad un cliente";
		END IF;
	END $$
DELIMITER ;

-- 16
DROP TRIGGER IF EXISTS CheckPosizioneAnimale;
DELIMITER $$
CREATE TRIGGER CheckPosizioneAnimale
BEFORE INSERT ON Geolocalizzazione FOR EACH ROW
	BEGIN
		IF EXISTS ( 	
			SELECT *
			FROM Posizione
			WHERE PosizioneGPS = NEW. PosizioneGPS ) 
		THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "La posizione è già stata legata ad una mungitrice";
		END IF;
	END $$
DELIMITER ;
DROP TRIGGER IF EXISTS CheckPosizioneMungitrice;
DELIMITER $$
CREATE TRIGGER CheckPosizioneMungitrice
BEFORE INSERT ON Posizione FOR EACH ROW
	BEGIN
		IF EXISTS ( 	
			SELECT *
			FROM Geolocalizzazione
			WHERE PosizioneGPS = NEW.PosizioneGPS ) 
		THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "La posizione è stata già legata ad un animale";
		END IF;
	END $$
DELIMITER ;

-- 17
DROP TRIGGER IF EXISTS CheckCapienza;
DELIMITER $$
CREATE TRIGGER CheckCapienza
BEFORE INSERT ON Animale FOR EACH ROW
	BEGIN
		IF ( SELECT COUNT(*)
		      FROM Animale
		      WHERE Locale = NEW.Locale )  = ( SELECT N_Massimo
											   FROM Locazione L
											   WHERE L.Locale = NEW.Locale)	THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Il locale scelto risulta essere già pieno";
		END IF;
	END $$
DELIMITER ;
DROP TRIGGER IF EXISTS CheckCapienzaAggiornamento;
DELIMITER $$
CREATE TRIGGER CheckCapienzaAggiornamento
BEFORE UPDATE ON Animale FOR EACH ROW
	BEGIN
		IF ( SELECT COUNT(*)
		      FROM Animale
		      WHERE Locale = NEW.Locale )  = ( SELECT N_Massimo
							FROM Locazione L
							WHERE L.Locale = NEW.Locale)	THEN
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Il locale scelto risulta essere già pieno";
		END IF;
	END $$
DELIMITER ;

-- ridondanze

-- Ridondanza 1
DROP TRIGGER IF EXISTS RIDInserimentoSoggiorno;
DELIMITER $$
CREATE TRIGGER RIDInserimentoSoggiorno
BEFORE INSERT ON Soggiorno FOR EACH ROW
	BEGIN
		DECLARE PREZZO INT DEFAULT 0;
        DECLARE DURATA INT DEFAULT 0;
        
        SELECT DATEDIFF(P.DATAPARTENZA, P.DATAARRIVO) INTO DURATA
        FROM PRENOTAZIONE P
        WHERE P.ID = NEW.PRENOTAZIONE;
        
		SELECT C.PREZZO INTO PREZZO
		FROM CAMERA C
		WHERE C.CODICE = NEW.CAMERA;
        
        UPDATE PRENOTAZIONE
        SET COSTOCOMPLESSIVO = COSTOCOMPLESSIVO + (PREZZO * DURATA)
        WHERE ID = NEW.PRENOTAZIONE;
	END $$
DELIMITER ;

DROP TRIGGER IF EXISTS RIDInserimentoRichiesta;
DELIMITER $$
CREATE TRIGGER RIDInserimentoRichiesta
BEFORE INSERT ON Richiesta FOR EACH ROW
	BEGIN
		DECLARE COSTO INT DEFAULT 0;
        
		SELECT S.COSTO INTO COSTO
		FROM SERVIZIOAGGIUNTIVO S
		WHERE S.TIPOLOGIA = NEW.SERVIZIOAGGIUNTIVO;
        
        UPDATE PRENOTAZIONE
        SET COSTOCOMPLESSIVO = COSTOCOMPLESSIVO + COSTO
        WHERE ID = NEW.PRENOTAZIONE;
	END $$
DELIMITER ;

DROP TRIGGER IF EXISTS RIDInserimentoEscursione;
DELIMITER $$
CREATE TRIGGER RIDInserimentoEscursione
BEFORE INSERT ON Extra FOR EACH ROW
	BEGIN
		DECLARE COSTO INT DEFAULT 0;
        
		SELECT E.COSTO INTO COSTO
		FROM ESCURSIONE E
		WHERE E.CODICE = NEW.ESCURSIONE;
        
        UPDATE PRENOTAZIONE
        SET COSTOCOMPLESSIVO = COSTOCOMPLESSIVO + COSTO
        WHERE ID = NEW.PRENOTAZIONE;
	END $$
DELIMITER ;

-- Ridondanza 2

DROP TRIGGER IF EXISTS RIDInserimentoOrdine;
DELIMITER $$
CREATE TRIGGER RIDInserimentoOrdine
BEFORE INSERT ON ComposizioneOrdine FOR EACH ROW
	BEGIN
		DECLARE PRODOTTO VARCHAR(80);
        DECLARE DATAORDINE DATE;
	
		SELECT U.PRODOTTO INTO PRODOTTO
		FROM UNITA U
		WHERE U.CODICE = NEW.UNITA;
        
        SELECT DATE(O.TIMESTAMP) INTO DATAORDINE
        FROM ORDINE O
        WHERE O.CODICE = NEW.ORDINE;
        
        IF DATAORDINE = CURRENT_DATE THEN
			UPDATE PRODOTTO
			SET NUMEROVENDITE = NUMEROVENDITE + 1
			WHERE NOME = PRODOTTO;
		END IF;
	END $$
DELIMITER ;

DROP TRIGGER IF EXISTS RIDInserimentoReso;
DELIMITER $$
CREATE TRIGGER RIDInserimentoReso
BEFORE INSERT ON Reso FOR EACH ROW
	BEGIN
		DECLARE PRODOTTO VARCHAR(80);
		
		SELECT U.PRODOTTO INTO PRODOTTO
		FROM UNITA U
		WHERE U.CODICE = NEW.UNITA;
        
        IF NEW.DATA = CURRENT_DATE THEN 
			
			UPDATE PRODOTTO
			SET NUMEROVENDITE = NUMEROVENDITE - 1
			WHERE NOME = PRODOTTO;
		END IF;
	END $$
DELIMITER ;

DROP EVENT IF EXISTS AzzeraNumeroVendite;
DELIMITER $$
CREATE EVENT AzzeraNumeroVendite
ON SCHEDULE EVERY 1 DAY
STARTS '2019/09/25 23:59:59'
DO
	BEGIN
        UPDATE PRODOTTO
        SET NUMEROVENDITE = 0;
	END $$
DELIMITER ;
-- backend
-- 1
DROP EVENT IF EXISTS CiboImmangiato;
DELIMITER $$
CREATE EVENT CiboImmangiato
ON SCHEDULE EVERY 1 HOUR DO
	BEGIN
		CREATE TEMPORARY TABLE IF NOT EXISTS MangiatoieTarget(
			Mangiatoia INT,
			PRIMARY KEY(Mangiatoia)
		);
		
		TRUNCATE TABLE MangiatoieTarget;
	
		INSERT INTO MangiatoieTarget 
			SELECT SM.Mangiatoia
			FROM StatoMangiatoia SM
				INNER JOIN
				Pasto P ON ( P.Mangiatoia = SM.Mangiatoia
				     	   AND P.Timestamp = SM.Timestamp )
			WHERE SM.Timestamp >= CURRENT_TIMESTAMP - INTERVAL 1 HOUR 
				AND NOT EXISTS ( 	
					SELECT *
					FROM StatoMangiatoia SM2
						INNER JOIN
						Pasto P2 ON ( SM2.Timestamp = P2.Timestamp
						AND SM2.Mangiatoia = P2.Mangiatoia )
					WHERE SM2.Mangiatoia = SM.Mangiatoia
					AND SM2.Timestamp >= SM.Timestamp - INTERVAL 6 HOUR
					AND SM2.QuantitaForaggio <> SM.QuantitaForaggio
					AND P2.Foraggio = P.Foraggio );

		DELETE P.*
        FROM Pasto P
		WHERE DATE_FORMAT(P.Timestamp, "%Y/%m/%d-%H:%i") =
			DATE_FORMAT(CURRENT_TIMESTAMP, "%Y/%m/%d-%H:%i")
			AND P.Mangiatoia IN ( SELECT *
					       FROM MangiatoieTarget );

		UPDATE StatoMangiatoia
		SET QuantitaForaggio = 0
		WHERE DATE_FORMAT(Timestamp, "%Y/%m/%d-%H:%i") =
			DATE_FORMAT(CURRENT_TIMESTAMP, "%Y/%m/%d-%H:%i")
			AND Mangiatoia IN ( SELECT *
					       FROM MangiatoieTarget );

	END $$
DELIMITER ;
-- 2
DROP FUNCTION IF EXISTS ScaffaleMagazzinoConsigliato;
DELIMITER $$
CREATE FUNCTION ScaffaleMagazzinoConsigliato(CodiceUnita INT)
RETURNS INT DETERMINISTIC
	BEGIN
		DECLARE FINITO INT DEFAULT 0;
		DECLARE SM INT DEFAULT 0;
		DECLARE Capienza INT DEFAULT 0;
		DECLARE NumeroUnita INT DEFAULT 0;
		DECLARE NumeroUnitaLotto INT DEFAULT 0;
		
        DECLARE CUR CURSOR FOR
			SELECT D.*	
			FROM ( 
			SELECT SM.Codice, SM.Capienza, COUNT(*) AS NumeroUnita, 
				SUM(IF(U.Lotto = ( SELECT U.Lotto
								   FROM Unita U
								   WHERE U.Codice = CodiceUnita ) ,1,0)) AS NumeroUnitaLotto
			FROM Sistemazione S
				INNER JOIN
				Unita U ON U.Codice = S.Unita
				INNER JOIN
				ScaffalaturaMagazzino SM ON SM.Codice = S.ScaffalaturaMagazzino
			GROUP BY SM.Codice 
			) AS D
			ORDER BY D.NumeroUnitaLotto DESC;
        

		DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET FINITO = 1;
		
		OPEN CUR;
		scan: LOOP
			FETCH CUR INTO SM, Capienza, NumeroUnita, NumeroUnitaLotto;
			IF FINITO = 1 THEN
				LEAVE scan;
			END IF;
			IF NumeroUnita < Capienza THEN
				RETURN(SM);
			END IF;
		END LOOP scan;
		CLOSE CUR;
	END $$


DROP FUNCTION IF EXISTS ScaffaleCantinaConsigliato$$
CREATE FUNCTION ScaffaleCantinaConsigliato(CodiceUnita INT)
RETURNS INT DETERMINISTIC
	BEGIN
		DECLARE FINITO INT DEFAULT 0;
		DECLARE SC INT DEFAULT 0;
		DECLARE Capienza INT DEFAULT 0;
		DECLARE NumeroUnita INT DEFAULT 0;
		DECLARE NumeroUnitaLotto INT DEFAULT 0;
		
		DECLARE CUR CURSOR FOR
			SELECT D.*	
			FROM ( 
			SELECT SC.Codice, SC.Capienza, COUNT(*) AS NumeroUnita, 
				SUM(IF(U.Lotto = ( SELECT U.Lotto
								   FROM Unita U
								   WHERE U.Codice = CodiceUnita ),1,0)) AS NumeroUnitaLotto
			FROM Stagionatura S
				INNER JOIN
				Unita U ON U.Codice = S.Unita
				INNER JOIN
				ScaffalaturaCantina SC ON SC.Codice = S.ScaffalaturaCantina
			WHERE S.DataInizio + INTERVAL S.Durata DAY >= CURRENT_DATE
			GROUP BY SC.Codice 
			) AS D
			ORDER BY D.NumeroUnitaLotto DESC;
		
		DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET FINITO = 1;
		
		OPEN CUR;
		scan: LOOP
			FETCH CUR INTO SC, Capienza, NumeroUnita, NumeroUnitaLotto;
			IF FINITO = 1 THEN
				LEAVE scan;
			END IF;
			IF NumeroUnita < Capienza THEN
				RETURN(SC);
			END IF;
		END LOOP scan;
		CLOSE CUR;
	END $$
DELIMITER ;

-- SELECT ScaffaleCantinaConsigliato(14);
-- 3
DROP TABLE IF EXISTS ConsigliProduzione;
CREATE TABLE ConsigliProduzione(
	Prodotto VARCHAR(80),
	Quantita INT DEFAULT 0,
	PRIMARY KEY(Prodotto)
);

DROP EVENT IF EXISTS Pendenti;
DELIMITER $$
CREATE EVENT Pendenti
ON SCHEDULE EVERY 1 WEEK DO
	BEGIN
		REPLACE INTO ConsigliProduzione
			SELECT S.PRODOTTO, SUM(S.QUANTITA) + FLOOR(0.5 * SUM(S.QUANTITA))
				AS Quantita
			FROM SCELTAORDINE S
			GROUP BY S.PRODOTTO;
	END $$
DELIMITER ;

-- 4
/*
DROP TRIGGER IF EXISTS SceltaUnita;
DELIMITER $$
CREATE TRIGGER SceltaUnita
BEFORE INSERT ON ComposizioneOrdine FOR EACH ROW
	BEGIN
		DECLARE UnitaConsigliata INT;

		SELECT U.Codice INTO UnitaConsigliata
		FROM Unita U
			INNER JOIN
			Lotto L ON U.Lotto = L.Codice
		WHERE U.Prodotto = ( SELECT U.Prodotto
							 FROM Unita U
							 WHERE U.Codice = NEW.Unita )
			AND L.DataScadenza >= CURRENT_DATE + INTERVAL 20 DAY 	-- deve scadere almeno tra 20 giorni
			AND L.DataScadenza <= ALL ( 	
							SELECT L2.DataScadenza
							FROM Unita U2
								INNER JOIN
								Lotto L2 ON U2.Lotto = L2.Codice
							WHERE U2.Prodotto = U.Prodotto 
								AND L2.DataScadenza >= CURRENT_DATE
									+ INTERVAL 20 DAY )
		LIMIT 1;
		
		SET NEW.Unita = UnitaConsigliata;
	END $$
DELIMITER ;
*/
-- inserimenti

INSERT INTO Agriturismo VALUES(1,"Mercurio");
INSERT INTO Agriturismo VALUES(3,"Venere");

INSERT INTO Specie VALUES("Bos Tarus");
INSERT INTO Specie VALUES("Frisona");
INSERT INTO Specie VALUES("Dorset Horn");
INSERT INTO Specie VALUES("Cheviot");

INSERT INTO Stalla VALUES(1,1);
INSERT INTO Stalla VALUES(2,1);
INSERT INTO Stalla VALUES(32,3);

INSERT INTO Locale VALUES(3, 67.2 , 87.5 , 5.8 , 6.2, 1.8, 5.5, "Cementine", 3, 1);
INSERT INTO Locale VALUES(2, 45.6 , 34.1 , 6.8 , 7.1, 2.8, 6.2, "Parquet", 4, 1);
INSERT INTO Locale VALUES(9, 54.1 , 65.6 , 4.9 , 6.7, 2.3, 6.5, "Cementine", 2, 2);
INSERT INTO Locale VALUES(7, 61.2 , 77.9 , 5.8 , 9.1, 2.1, 6.7, "Parquet", 3, 32);
INSERT INTO Locale VALUES(12, 34.2 , 79.9 , 3.4 , 8.6, 5.1, 6.7, "Parquet", 3, 32);

INSERT INTO Locazione VALUES(3,"Bos Tarus",5);
INSERT INTO Locazione VALUES(2,"Frisona",6);
INSERT INTO Locazione VALUES(9,"Dorset Horn",5);
INSERT INTO Locazione VALUES(7,"Cheviot",6);
INSERT INTO Locazione VALUES(12,"Bos Tarus",4);

INSERT INTO Animale VALUES(1,"F","18/07/12",53,45,3,"Bos Tarus",1);
INSERT INTO Animale VALUES(2,"M","17/04/13",73,65,2,"Frisona",0);
INSERT INTO Animale VALUES(3,"M","18/12/21",83,75,3,"Bos Tarus",0);
INSERT INTO Animale VALUES(4,"F","15/01/10",93,95,9,"Dorset Horn",1);
INSERT INTO Animale VALUES(5,"F","11/09/01",63,65,7,"Cheviot",0);
INSERT INTO Fornitore VALUES("08100987652","Animal Group","Animal Group S.P.A.","Via dei Meandri 12, Pisa, Toscana, Italia");
INSERT INTO Fornitore VALUES("07105947419","F.lli Marcello Allevamento","F.lli Marcello Allevamento S.R.L.","Vione Vannini 12, Lucca, Toscana, Italia");

INSERT INTO Acquisto VALUES(1,"08100987652","18/09/19","18/09/22");
INSERT INTO Acquisto VALUES(4,"07105947419","16/02/23","16/03/02");

INSERT INTO Allestimento VALUES(1,2);
INSERT INTO Allestimento VALUES(2,3);
INSERT INTO Allestimento VALUES(3,9);
INSERT INTO Allestimento VALUES(4,7);

INSERT INTO Dispositivo VALUES(1, "Dispositivo di condizionamento aria", 2);

INSERT INTO Abbeveratoio VALUES(1, 2);
INSERT INTO Abbeveratoio VALUES(2, 4);

INSERT INTO StatoAbbeveratoio VALUES(CURRENT_TIMESTAMP, 1, 30, 2, 5);
INSERT INTO StatoAbbeveratoio VALUES(CURRENT_TIMESTAMP - INTERVAL 1 HOUR, 1, 40, 2, 5);
INSERT INTO StatoAbbeveratoio VALUES(CURRENT_TIMESTAMP, 2, 56, 1, 4);

INSERT INTO Mangiatoia VALUES(1,1);

INSERT INTO StatoMangiatoia VALUES(CURRENT_TIMESTAMP, 1, 0);

INSERT INTO Foraggio VALUES(1, "Semi", 3, 5, 7, 12.2, "Fresco");

INSERT INTO Pasto VALUES(CURRENT_TIMESTAMP - INTERVAL 1 DAY, 1, 1, "14:00");

INSERT INTO Componente VALUES(1, "Piante");

INSERT INTO Veterinario VALUES(1, "Giancarlo", "Volpe");
INSERT INTO Veterinario VALUES(2, "Serena", "Lucervo");

INSERT INTO Specializzazione VALUES("Sanità Animale");
INSERT INTO Specializzazione VALUES("Allevamento");

INSERT INTO Abilita VALUES(1, "Allevamento");
INSERT INTO Abilita VALUES(2, "Sanità Animale");

INSERT INTO Composizione VALUES(1,1,100);

INSERT INTO StatoLocale VALUES(3, CURRENT_TIMESTAMP, 24.4, 12.2);
INSERT INTO StatoLocale VALUES(2, CURRENT_TIMESTAMP, 23.9, 2.9);

INSERT INTO StatoPulizia VALUES("19/09/12 17:23", 2, 3, 5, 7); 
INSERT INTO StatoPulizia VALUES("19/09/12 12:18", 3, 1, 1, 2); 

INSERT INTO Personale VALUES(1, "Carlo", "Ippolito","Addetto alle pulizie"); 

INSERT INTO RichiestaPulizia VALUES(1, "19/09/12 17:23", 3,"Richiesto");

INSERT INTO PosizioneGPS VALUES(1,CURRENT_TIMESTAMP - INTERVAL 1 DAY, 12.3459923, 23.9870012);
INSERT INTO PosizioneGPS VALUES(2,CURRENT_TIMESTAMP - INTERVAL 1 HOUR, 11.2451238, 29.9871231);
INSERT INTO PosizioneGPS VALUES(3,CURRENT_TIMESTAMP - INTERVAL 1 HOUR, 12.3459923, 23.9870012);

INSERT INTO Geolocalizzazione VALUES(1,1);
INSERT INTO Geolocalizzazione VALUES(2,5);

INSERT INTO Zona VALUES(1,1);
INSERT INTO Zona VALUES(2,1);
INSERT INTO Zona VALUES(3,3);
INSERT INTO Zona VALUES(4,3);

INSERT INTO Pascolo VALUES(1, "12:20", "19:20", "19/09/12", 1);
INSERT INTO Pascolo VALUES(2, "10:00", "11:35", "19/08/11", 4);

INSERT INTO Attivita VALUES(1, 1, "19:00");
INSERT INTO Attivita VALUES(1, 3, "18:20");
INSERT INTO Attivita VALUES(2, 2, "10:20");
INSERT INTO Attivita VALUES(2, 5, "11:35");

INSERT INTO Recinzione VALUES(1,1);
INSERT INTO Recinzione VALUES(2,1);
INSERT INTO Recinzione VALUES(3, 1);
INSERT INTO Recinzione VALUES(4, 1);

INSERT INTO Cardine VALUES("Iniziale");
INSERT INTO Cardine VALUES("Finale");

INSERT INTO Confine VALUES(1,"Iniziale", 23.6543451,29.4323459);
INSERT INTO Confine VALUES(1,"Finale", 23.6543451, 13.2238123);

INSERT INTO SchedaMedica VALUES(1, CURRENT_DATE);
INSERT INTO SchedaMedica VALUES(2, CURRENT_DATE);
INSERT INTO SchedaMedica VALUES(3, CURRENT_DATE);
INSERT INTO SchedaMedica VALUES(4, CURRENT_DATE);
INSERT INTO SchedaMedica VALUES(5, CURRENT_DATE);

INSERT INTO Indicatore VALUES("Fegato");
INSERT INTO Indicatore VALUES("Cuore");
INSERT INTO Indicatore VALUES("Pancreas");

INSERT INTO Punteggio VALUES(1,"Fegato",8);
INSERT INTO Punteggio VALUES(2,"Pancreas",9);

INSERT INTO Lesione VALUES(1,"Cutanea","Lieve","Pelle");

INSERT INTO DisturboComportamentale VALUES("Aggressività", "Grave");

INSERT INTO Riscontro VALUES("Aggressività",4);

INSERT INTO Terapia VALUES(1,"19/09/01", "19/09/11", "Negativo", 2);
INSERT INTO Terapia VALUES(2, CURRENT_DATE, NULL, NULL, 1);

INSERT INTO Quarantena VALUES(1, "19/09/12", "19/09/14", 1);

INSERT INTO Medicinale VALUES("Cefaosporine", "Cefazolina", "Antibiotico");

INSERT INTO VisitaDiControllo VALUES(4, "Visita Periodica Animale", CURRENT_DATE, 1, 2);

INSERT INTO Disfunzione VALUES(1, "Patologia neuromuscolare", "Neuromuscolare", 8, "19/09/15", NULL, 4);
 
INSERT INTO Prescrizione VALUES(1,1);

INSERT INTO Riproduzione VALUES(1,"19/09/12","12:45","Insuccesso",2);

INSERT INTO Partecipazione VALUES(1,1);
INSERT INTO Partecipazione VALUES(3,1);

INSERT INTO Complicanza VALUES(1,"19/09/15","Problema di fecondazione",1);

INSERT INTO Mungitrice VALUES(1,"Alfa 23","FDA");
INSERT INTO Mungitrice VALUES(2,"Beta 12","FDA");

INSERT INTO Mungitura VALUES("19/09/17 12:23",1);
INSERT INTO Mungitura VALUES("19/09/12 20:00",2);

INSERT INTO Latte VALUES(1,50.2,"19/09/17 12:23", 1);
INSERT INTO Latte VALUES(4,40.2,"19/09/12 20:00", 2);

INSERT INTO Silos VALUES(1,300);

INSERT INTO Raccolta VALUES(1,50.2,"19/09/17 12:23",1,1);

INSERT INTO Sostanza VALUES("Calcio");

INSERT INTO Presenza VALUES(1,50.2,"19/09/17 12:23",1,"Calcio",30);
INSERT INTO Presenza VALUES(4,40.2,"19/09/12 20:00",2,"Calcio",40);

INSERT INTO Posizione VALUES(3,1);

INSERT INTO Laboratorio VALUES(1,400,1);

INSERT INTO Lotto VALUES(1,"19/08/18","19/10/23",23,1);
INSERT INTO Lotto VALUES(2,"19/09/17","19/11/21",30,1);

INSERT INTO Ricetta VALUES("Dalla Montagna", "Ricetta utilizzata per la produzione di diversi formaggi..", "Vicenza",9);
INSERT INTO Ricetta VALUES("La Valtellina", "Ricetta utilizzata per la produzione di diversi formaggi..", "Sondrio",8);
INSERT INTO Ricetta VALUES("Dalla Campagna", "Ricetta utilizzata per la produzione di diversi formaggi..", "Genova",6);
INSERT INTO Ricetta VALUES("La Tedesca", "Ricetta utilizzata per la produzione di diversi formaggi..", "Berlino",4);
INSERT INTO Ricetta VALUES("Ricetta Quark", "Ricetta utilizzata per la produzione di diversi formaggi..", "Livorno",11);
INSERT INTO Ricetta VALUES("Ricetta Asiago", "Ricetta utilizzata per la produzione di diversi formaggi..", "Emilia Romagna",12);

INSERT INTO Prodotto VALUES("Asiago d’Allevo", 8, 30, "Pasta dura","Dalla Montagna",0);
INSERT INTO Prodotto VALUES("Bitto", 7, 27.99, "Pasta semidura","La Valtellina",0);
INSERT INTO Prodotto VALUES("Bra duro", 8, 35, "Pasta dura","Dalla Campagna",0);
INSERT INTO Prodotto VALUES("Il Graukäse", 6, 29.99, "Pasta molle","La Tedesca",0);
INSERT INTO Prodotto VALUES("Quark", 9, 40, "Pasta molle","Ricetta Quark",0);
INSERT INTO Prodotto VALUES("Asiago", 10, 30, "Pasta molle","Ricetta Asiago",0);

INSERT INTO Processo VALUES(1);
INSERT INTO Processo VALUES(2);
INSERT INTO Processo VALUES(3);
INSERT INTO Processo VALUES(4);
INSERT INTO Processo VALUES(5);
INSERT INTO Processo VALUES(6);

INSERT INTO Unita VALUES(1,10,"Asiago d’Allevo",1,1);
INSERT INTO Unita VALUES(2,9.5,"Asiago d’Allevo",1,1);
INSERT INTO Unita VALUES(3,10,"Asiago d’Allevo",1,1);
INSERT INTO Unita VALUES(4,11,"Asiago d’Allevo",1,1);
INSERT INTO Unita VALUES(5,9,"Asiago d’Allevo",1,1);
INSERT INTO Unita VALUES(6,12,"Bitto",2,2);
INSERT INTO Unita VALUES(7,10,"Bitto",2,2);
INSERT INTO Unita VALUES(8,7.5,"Bitto",2,2);
INSERT INTO Unita VALUES(9,8,"Bitto",2,2);
INSERT INTO Unita VALUES(10,10,"Bitto",2,2);
INSERT INTO Unita VALUES(11,10.5,"Bra duro",3,2);
INSERT INTO Unita VALUES(12,9,"Bra duro",3,2);
INSERT INTO Unita VALUES(13,10,"Bra duro",3,2);
INSERT INTO Unita VALUES(14,9,"Bra duro",3,2);
INSERT INTO Unita VALUES(15,10,"Bra duro",3,2);
INSERT INTO Unita VALUES(16,10,"Il Graukäse",4,1);
INSERT INTO Unita VALUES(17,9.6,"Il Graukäse",4,1);
INSERT INTO Unita VALUES(18,10,"Il Graukäse",4,1);
INSERT INTO Unita VALUES(19,9.8,"Il Graukäse",4,1);
INSERT INTO Unita VALUES(20,10,"Il Graukäse",4,1);
INSERT INTO Unita VALUES(21,8,"Quark",5,1);
INSERT INTO Unita VALUES(22,8.6,"Quark",5,1);
INSERT INTO Unita VALUES(23,7.9,"Quark",5,1);
INSERT INTO Unita VALUES(24,8,"Quark",5,1);
INSERT INTO Unita VALUES(25,8.2,"Quark",5,1);
INSERT INTO Unita VALUES(26,10,"Asiago d’Allevo",6,1);
INSERT INTO Unita VALUES(27,9.5,"Asiago d’Allevo",6,1);
INSERT INTO Unita VALUES(28,10,"Asiago d’Allevo",6,1);
INSERT INTO Unita VALUES(29,11,"Asiago d’Allevo",6,1);
INSERT INTO Unita VALUES(30,9,"Asiago d’Allevo",6,1);

INSERT INTO Impiego VALUES(1,1);
INSERT INTO Impiego VALUES(2,1);

INSERT INTO Dipendente VALUES(1,"Luca de Giacomo");
INSERT INTO Dipendente VALUES(2, "Mayra Cortes");

INSERT INTO Lavoro VALUES(1,1);
INSERT INTO Lavoro VALUES(2,1);

INSERT INTO FaseIdeale VALUES(1,60 * 10,"Dalla Montagna");
INSERT INTO FaseIdeale VALUES(2,60 * 9,"Dalla Montagna");
INSERT INTO FaseIdeale VALUES(3,60 * 10,"La Valtellina");
INSERT INTO FaseIdeale VALUES(4,60 * 9 + 30,"La Valtellina");
INSERT INTO FaseIdeale VALUES(5,60 * 8,"Dalla Campagna");
INSERT INTO FaseIdeale VALUES(6,60 * 7,"Dalla Campagna");
INSERT INTO FaseIdeale VALUES(7,60 * 5,"La Tedesca");
INSERT INTO FaseIdeale VALUES(8,60 * 5,"La Tedesca");
INSERT INTO FaseIdeale VALUES(9,60 * 7,"Ricetta Quark");
INSERT INTO FaseIdeale VALUES(10,60 * 8,"Ricetta Quark");
INSERT INTO FaseIdeale VALUES(11,60 * 9,"Ricetta Asiago");
INSERT INTO FaseIdeale VALUES(12,60 * 8,"Ricetta Asiago");


INSERT INTO ParametroIdeale VALUES("Conservazione");
INSERT INTO ParametroIdeale VALUES("Gusto");
INSERT INTO ParametroIdeale VALUES("Forma");
INSERT INTO ParametroIdeale VALUES("Aspetto");

INSERT INTO CombinazioneIdeale VALUES(1,"Conservazione",5);
INSERT INTO CombinazioneIdeale VALUES(1,"Gusto",8);
INSERT INTO CombinazioneIdeale VALUES(2,"Forma",6);
INSERT INTO CombinazioneIdeale VALUES(2,"Aspetto",7);
INSERT INTO CombinazioneIdeale VALUES(3,"Conservazione",7);
INSERT INTO CombinazioneIdeale VALUES(3,"Gusto",9);
INSERT INTO CombinazioneIdeale VALUES(4,"Forma",7);
INSERT INTO CombinazioneIdeale VALUES(4,"Aspetto",5);
INSERT INTO CombinazioneIdeale VALUES(5,"Forma",7);
INSERT INTO CombinazioneIdeale VALUES(5,"Gusto",8);
INSERT INTO CombinazioneIdeale VALUES(6,"Conservazione",9);
INSERT INTO CombinazioneIdeale VALUES(6,"Aspetto",5);
INSERT INTO CombinazioneIdeale VALUES(7,"Forma",6);
INSERT INTO CombinazioneIdeale VALUES(7,"Aspetto",8);
INSERT INTO CombinazioneIdeale VALUES(8,"Conservazione",9);
INSERT INTO CombinazioneIdeale VALUES(8,"Gusto",9);
INSERT INTO CombinazioneIdeale VALUES(9,"Conservazione",4);
INSERT INTO CombinazioneIdeale VALUES(9,"Aspetto",5);
INSERT INTO CombinazioneIdeale VALUES(10,"Gusto",5);
INSERT INTO CombinazioneIdeale VALUES(10,"Forma",7);
INSERT INTO CombinazioneIdeale VALUES(11,"Conservazione",4);
INSERT INTO CombinazioneIdeale VALUES(11,"Aspetto",7);
INSERT INTO CombinazioneIdeale VALUES(12,"Gusto",8);
INSERT INTO CombinazioneIdeale VALUES(12,"Forma",9);

INSERT INTO FaseEffettiva VALUES(1,60 * 9,1);
INSERT INTO FaseEffettiva VALUES(2,60 * 9 + 30,1);
INSERT INTO FaseEffettiva VALUES(3,60 * 10,2);
INSERT INTO FaseEffettiva VALUES(4,60 * 8 + 30,2);
INSERT INTO FaseEffettiva VALUES(5,60 * 9,3);
INSERT INTO FaseEffettiva VALUES(6,60 * 8,3);
INSERT INTO FaseEffettiva VALUES(7,60 * 9 + 30,4);
INSERT INTO FaseEffettiva VALUES(8,60 * 8 + 30,4);
INSERT INTO FaseEffettiva VALUES(9,60 * 10 + 30,5);
INSERT INTO FaseEffettiva VALUES(10,60 * 9,5);
INSERT INTO FaseEffettiva VALUES(11,60 * 10 + 30,6);
INSERT INTO FaseEffettiva VALUES(12,60 * 9,6);

INSERT INTO ParametroEffettivo VALUES("Conservazione");
INSERT INTO ParametroEffettivo VALUES("Gusto");
INSERT INTO ParametroEffettivo VALUES("Forma");
INSERT INTO ParametroEffettivo VALUES("Aspetto");

INSERT INTO Combinazione VALUES(1,"Conservazione",6);
INSERT INTO Combinazione VALUES(1,"Gusto",8);
INSERT INTO Combinazione VALUES(2,"Forma",6);
INSERT INTO Combinazione VALUES(2,"Aspetto",6);
INSERT INTO Combinazione VALUES(3,"Conservazione",7);
INSERT INTO Combinazione VALUES(3,"Gusto",2);
INSERT INTO Combinazione VALUES(4,"Forma",8);
INSERT INTO Combinazione VALUES(4,"Aspetto",5);
INSERT INTO Combinazione VALUES(5,"Conservazione",7);
INSERT INTO Combinazione VALUES(5,"Gusto",3);
INSERT INTO Combinazione VALUES(6,"Forma",8);
INSERT INTO Combinazione VALUES(6,"Aspetto",7);
INSERT INTO Combinazione VALUES(7,"Gusto",7);
INSERT INTO Combinazione VALUES(7,"Conservazione",9);
INSERT INTO Combinazione VALUES(8,"Forma",5);
INSERT INTO Combinazione VALUES(8,"Aspetto",8);
INSERT INTO Combinazione VALUES(9,"Conservazione",5);
INSERT INTO Combinazione VALUES(9,"Forma",3);
INSERT INTO Combinazione VALUES(10,"Gusto",8);
INSERT INTO Combinazione VALUES(10,"Aspetto",7);
INSERT INTO Combinazione VALUES(11,"Conservazione",5);
INSERT INTO Combinazione VALUES(11,"Forma",8);
INSERT INTO Combinazione VALUES(12,"Gusto",7);
INSERT INTO Combinazione VALUES(12,"Aspetto",8);

INSERT INTO Magazzino VALUES(1,1);

INSERT INTO ScaffalaturaMagazzino VALUES(1,50,1);

INSERT INTO Cantina VALUES(1,3);

INSERT INTO ScaffalaturaCantina VALUES(1,40,1);

INSERT INTO Sistemazione VALUES(5,1,1);

INSERT INTO Stagionatura VALUES(15,1,"19/09/12",10,1);

INSERT INTO StatoCantina VALUES(CURRENT_DATE,1,23,10,8);

INSERT INTO ClienteRegistrato VALUES("MNGFNC89A11A390Q","Francesco", "Mangiamucche","Via degli Ontani 23","4023 1987 6543 1876");
INSERT INTO ClienteRegistrato VALUES("LNCPTR90R12A053M","Pietro", "Lancini","Via Verdi 111","4021 1227 6598 1861");

INSERT INTO ClienteNonRegistrato VALUES("LNZPRR98A12A053L","5321 1117 1908 1111");

INSERT INTO NumeroDiTelefono VALUES(3409876819,"LNCPTR90R12A053M");
INSERT INTO NumeroDiTelefono VALUES(3221834561,"MNGFNC89A11A390Q");

INSERT INTO Documento VALUES("Patente","U1R09887CD","27/09/12","Motorizzazione", "LNCPTR90R12A053M");
INSERT INTO Documento VALUES("Carta d’identità","UXX887AB","27/11/22","Comune", "MNGFNC89A11A390Q");

INSERT INTO Prenotazione VALUES(1,"19/09/15","19/09/30",0);
INSERT INTO Prenotazione VALUES(2,"19/09/19","19/09/22",0);
INSERT INTO Prenotazione VALUES(3,"19/09/10","19/09/15",0);

INSERT INTO Scelta VALUES(2,"LNZPRR98A12A053L");

INSERT INTO Riserva VALUES(1,"MNGFNC89A11A390Q");
INSERT INTO Riserva VALUES(3,"LNCPTR90R12A053M");

INSERT INTO Camera VALUES(1,40,1,0,1);
INSERT INTO Camera VALUES(2,70,1,1,3); -- suite
INSERT INTO Camera VALUES(3,80,0,1,1); -- suite

INSERT INTO Soggiorno VALUES(2,2);
INSERT INTO Soggiorno VALUES(1,1);
INSERT INTO Soggiorno VALUES(3,1);
INSERT INTO Soggiorno VALUES(1,3);
INSERT INTO Soggiorno VALUES(2,3);

INSERT INTO ServizioAggiuntivo VALUES("Piscina",30);

INSERT INTO Richiesta VALUES("Piscina",1,"19/09/17");
INSERT INTO Richiesta VALUES("Piscina",1,"19/09/18");

INSERT INTO Guida VALUES(1,"Luca","Anatra");

INSERT INTO Escursione VALUES(1,"19/09/20","15:00",20,1);

INSERT INTO Extra VALUES(1,1,"19/09/20");

INSERT INTO Itinerario VALUES(1);

INSERT INTO Mappa VALUES(1,1);

INSERT INTO Area VALUES("Area Pascolo 3",500,1);
INSERT INTO Area VALUES("Area Relax",100,3);

INSERT INTO Visita VALUES(1,"Area Pascolo 3","16:00","16:30");
INSERT INTO Visita VALUES(1,"Area Relax","16:30","17:30");

INSERT INTO Pagamento VALUES(1,"19/09/15 12:22","4023 1987 6543 1876",55,"Carta di debito",1);
INSERT INTO Pagamento VALUES(2,"19/09/19 11:12","4011 1284 1113 1226",35,"Carta di credito",2);
INSERT INTO Pagamento VALUES(3,"19/09/22 10:00","",35,"Paypal",2);
INSERT INTO Pagamento VALUES(4,"19/09/10 11:09","",55,"Contanti",3);
INSERT INTO Pagamento VALUES(5,"19/09/15 17:02","",35,"Contanti",3);

INSERT INTO Account VALUES("Lufix","Password","Quando sono nato?","Ieri","MNGFNC89A11A390Q","19/09/14");
INSERT INTO Account VALUES("StellaVerde","Stella_098","Animale preferito?","Lucertola","LNCPTR90R12A053M","19/09/09");

INSERT INTO Ordine VALUES(1,CURRENT_DATE - INTERVAL 5 DAY,"in processazione","Lufix");
INSERT INTO Ordine VALUES(2,CURRENT_DATE - INTERVAL 2 DAY,"in processazione","Lufix");
INSERT INTO Ordine VALUES(3,CURRENT_DATE - INTERVAL 4 DAY,"in processazione","StellaVerde");
INSERT INTO Ordine VALUES(4,CURRENT_DATE - INTERVAL 7 DAY,"in processazione","StellaVerde");
INSERT INTO Ordine VALUES(5,CURRENT_DATE - INTERVAL 1 DAY,"in processazione","StellaVerde");
INSERT INTO Ordine VALUES(6,CURRENT_DATE - INTERVAL 1 DAY,"in processazione","Lufix");

UPDATE Ordine
SET Stato = "in preparazione"
WHERE Codice = 3 OR Codice = 1 OR Codice = 4;

UPDATE Ordine
SET Stato = "spedito"
WHERE Codice = 1 OR Codice = 4;

INSERT INTO SceltaOrdine VALUES("Bra duro",3,7);
INSERT INTO SceltaOrdine VALUES("Bitto",3,1);

INSERT INTO ComposizioneOrdine VALUES(1,1);
INSERT INTO ComposizioneOrdine VALUES(2,1);
INSERT INTO ComposizioneOrdine VALUES(3,1);
INSERT INTO ComposizioneOrdine VALUES(26,1);
INSERT INTO ComposizioneOrdine VALUES(27,1);
INSERT INTO ComposizioneOrdine VALUES(28,1);
INSERT INTO ComposizioneOrdine VALUES(30,1);
INSERT INTO ComposizioneOrdine VALUES(29,1);
INSERT INTO ComposizioneOrdine VALUES(4,2);
INSERT INTO ComposizioneOrdine VALUES(6,2);
INSERT INTO ComposizioneOrdine VALUES(7,3);
INSERT INTO ComposizioneOrdine VALUES(8,3);
INSERT INTO ComposizioneOrdine VALUES(9,3);
INSERT INTO ComposizioneOrdine VALUES(10,3);
INSERT INTO ComposizioneOrdine VALUES(11,4);
INSERT INTO ComposizioneOrdine VALUES(12,4);
INSERT INTO ComposizioneOrdine VALUES(13,4);
INSERT INTO ComposizioneOrdine VALUES(14,4);
INSERT INTO ComposizioneOrdine VALUES(17,5);
INSERT INTO ComposizioneOrdine VALUES(19,6);

INSERT INTO Spedizione VALUES(1,"consegnata");
INSERT INTO Spedizione VALUES(2,"in transito");
INSERT INTO Spedizione VALUES(3,"consegnata");
INSERT INTO Spedizione VALUES(4,"consegnata");

INSERT INTO Trasporto VALUES(1,1,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(1,2,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(1,3,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(1,26,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(1,27,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(1,28,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(1,29,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(1,30,"19/09/23","19/09/24");
INSERT INTO Trasporto VALUES(2,11,"19/09/27",NULL);
INSERT INTO Trasporto VALUES(2,12,"19/09/27",NULL);
INSERT INTO Trasporto VALUES(2,13,"19/09/27",NULL);
INSERT INTO Trasporto VALUES(2,14,"19/09/27",NULL);
INSERT INTO Trasporto VALUES(3,4,"19/09/24","19/09/24");
INSERT INTO Trasporto VALUES(3,6,"19/09/24","19/09/24");
INSERT INTO Trasporto VALUES(4,7,"19/09/22","19/09/23");
INSERT INTO Trasporto VALUES(4,8,"19/09/22","19/09/23");
INSERT INTO Trasporto VALUES(4,9,"19/09/22","19/09/23");
INSERT INTO Trasporto VALUES(4,10,"19/09/22","19/09/23");

INSERT INTO Hub VALUES(1,"Pescara");
INSERT INTO Hub VALUES(2,"Foggia");
INSERT INTO Hub VALUES(3,"Otranto");

INSERT INTO Controllo VALUES(1,1,"19/09/24 10:17");
INSERT INTO Controllo VALUES(1,2,"19/09/23 19:11");
INSERT INTO Controllo VALUES(2,2,"19/09/25 12:34");
INSERT INTO Controllo VALUES(3,1,"19/09/23 18:30");
INSERT INTO Controllo VALUES(4,2,"19/09/22 10:18");
INSERT INTO Controllo VALUES(4,3,"19/09/23 12:34");

INSERT INTO Recensione VALUES(1,"Ottimo prodotto",1,8,9,7,10);
INSERT INTO Recensione VALUES(2,"Ottimo prodotto",2,8,9,7,10);
INSERT INTO Recensione VALUES(3,"Prodotto di scarsa qualita , consiglio di puntare di più sul Gusto",3,4,3,2,4);
INSERT INTO Recensione VALUES(4,"Poco gradita la qualita e il gusto , il formaggio emana inoltre un cattivo Odore",28,5,2,7,4);
INSERT INTO Recensione VALUES(5,"Gusto veramente diverso dal solito , odore molto strano",30,4,2,6,8);
INSERT INTO Recensione VALUES(6,"Non è quello che mi aspettavo ! Conservazione e qualita pessimi",6,5,4,8,4);
INSERT INTO Recensione VALUES(7,"Pessimi i servizi di consegna , inoltre scarso livello di conservazione e qualita",10,4,5,5,7);
INSERT INTO Recensione VALUES(8,"Magnifico",26,8,9,8,10);
INSERT INTO Recensione VALUES(9,"Veramente buono , da consigliare",27,8,8,9,9);
INSERT INTO Recensione VALUES(10,"Ottimo",29,8,9,7,10);
INSERT INTO Recensione VALUES(11,"Veramente buono, da consigliare",9,9,8,9,7);

INSERT INTO ParametriDiQualita VALUES("Conservazione");
INSERT INTO ParametriDiQualita VALUES("Gusto");
INSERT INTO ParametriDiQualita VALUES("Aspetto");
INSERT INTO ParametriDiQualita VALUES("Forma");

INSERT INTO Reso VALUES(1,"19/09/25",3);
INSERT INTO Reso VALUES(2,"19/09/25",6);
INSERT INTO Reso VALUES(3,"19/09/24",10);
INSERT INTO Reso VALUES(4,"19/09/24",28);
INSERT INTO Reso VALUES(5,"19/09/24",30);

INSERT INTO Analisi VALUES(1,"Gusto",7);
INSERT INTO Analisi VALUES(1,"Aspetto",5);
INSERT INTO Analisi VALUES(1,"Forma",5);
INSERT INTO Analisi VALUES(1,"Conservazione",5);
INSERT INTO Analisi VALUES(2,"Gusto",5);
INSERT INTO Analisi VALUES(2,"Aspetto",3);
INSERT INTO Analisi VALUES(2,"Forma",8);
INSERT INTO Analisi VALUES(2,"Conservazione",4);
INSERT INTO Analisi VALUES(3,"Gusto",4);
INSERT INTO Analisi VALUES(3,"Aspetto",5);
INSERT INTO Analisi VALUES(3,"Forma",5);
INSERT INTO Analisi VALUES(3,"Conservazione",5);
INSERT INTO Analisi VALUES(4,"Gusto",5);
INSERT INTO Analisi VALUES(4,"Aspetto",8);
INSERT INTO Analisi VALUES(4,"Forma",8);
INSERT INTO Analisi VALUES(4,"Conservazione",2);
INSERT INTO Analisi VALUES(5,"Gusto",4);
INSERT INTO Analisi VALUES(5,"Aspetto",8);
INSERT INTO Analisi VALUES(5,"Forma",1);
INSERT INTO Analisi VALUES(5,"Conservazione",2);