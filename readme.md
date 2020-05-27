# Concordantie-Catalogusnummer-Oudnummer
Een script en een CSV bestand met Concordantie tussen HUA Beeldbank Catalogusnummer en Oude nummering

Er zijn op het moment van schrijven +100.000 afbeeldingen in de beeldbank waarvan een of meerdere 'oude nummers' bekend zijn. Onderstaande loop voert meerdere queries (in blokken van 10.000 resultaten) uit op de [triplestore van Het Utrechts Archief](https://data.netwerkdigitaalerfgoed.nl/hetutrechtsarchief/mi2rdf/sparql/mi2rdf). De output kun je redirecten naar 1 groot csv bestand.

## Usage:
```bash
./download-csv.sh
```

## Query live uitvoeren via SPARQL
https://api.data.netwerkdigitaalerfgoed.nl/s/hAuhfUMyA

## SPARQL query
```sparql
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX soort: <https://archief.io/soort#>
PREFIX v: <https://archief.io/veld#>

SELECT  ?Catalogusnummer, ?oudnummer WHERE {  # subselect voor ORDER BY icm OFFSET
  SELECT ?Catalogusnummer, ?oudnummer  {
    { ?sub v:nummer ?Catalogusnummer ; v:oudnummer_1 ?_oudnummer}
    UNION
    { ?sub v:nummer ?Catalogusnummer ; v:oudnummer_2 ?_oudnummer} 
    UNION
    { ?sub v:nummer ?Catalogusnummer ; v:oudnummer_3 ?_oudnummer}
    BIND(REPLACE(?_oudnummer,"\n","") as ?oudnummer) # remove linefeed from ?_oudnumber
  }
  ORDER BY ?oudnummer
}

LIMIT 10000
OFFSET 0
```
