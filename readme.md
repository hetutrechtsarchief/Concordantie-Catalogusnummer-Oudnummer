# Concordantie-Catalogusnummer-Oudnummer
Een script en een CSV bestand met Concordantie tussen HUA Beeldbank Catalogusnummer en Oude nummering

Er zijn op het moment van schrijven +100.000 afbeeldingen in de beeldbank waarvan een of meerdere 'oude nummers' bekend zijn. Onderstaande loop voert meerdere queries (in blokken van 10.000 resultaten) uit op de [triplestore van Het Utrechts Archief](https://data.netwerkdigitaalerfgoed.nl/hetutrechtsarchief/mi2rdf/sparql/mi2rdf). De output gaat naar 1 groot csv, md, html en pdf bestand.

## Lijst genereren
```bash
./maak-lijst.sh
```

## Download het resultaat
* In de [output](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/tree/master/output) map staan een csv, md, html en pdf bestand die je kunt downloaden en doorzoeken.
* Download hier [het resultaat als CSV](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/output/HUA-catnr-oudnr.csv) (3,5MB, 115.399 regels).
* Download hier [het resultaat als PDF](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/output/HUA-catnr-oudnr.pdf) (5MB, 2500 pagina's).

* [HUA-catnr-oudnr.csv](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/output/HUA-catnr-oudnr.csv)
* [HUA-catnr-oudnr.md](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/output/HUA-catnr-oudnr.md)
* [HUA-catnr-oudnr.pdf](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/output/HUA-catnr-oudnr.pdf)
* [HUA-catnr-oudnr.html](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/output/HUA-catnr-oudnr.html)

## SPARQL Query live uitvoeren
https://api.data.netwerkdigitaalerfgoed.nl/s/zb80tB6Xo

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
