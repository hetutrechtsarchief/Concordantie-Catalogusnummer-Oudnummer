# Concordantie Catalogusnummer vs. Oudnummer
Deze repo bevat code (en het resultaat daarvan) om een Concordantielijst te maken van HUA Beeldbank Catalogusnummer en Oude nummering uit het verleden.

Er zijn op het moment van schrijven +/- 115.000 afbeeldingen in de beeldbank waarvan een of meerdere 'oude nummers' bekend zijn. Naar deze nummers wordt nogal eens verwezen in oude documenten maar worden niet door HUA in de Beeldbank getoond of doorzoekbaar gemaakt.

Het script in deze repo voert een query uit op de [Linked Open Data API in de triplestore van Het Utrechts Archief](https://data.netwerkdigitaalerfgoed.nl/hetutrechtsarchief/mi2rdf/sparql/mi2rdf) en download het resultaat in blokjes van 10.000 regels. Het resultaat wordt weggeschreven als CSV, Markdown (md), HTML en PDF.

## Download het resultaat
* In de [docs/](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/tree/master/docs) map staan een csv, md, html en pdf bestand die je kunt downloaden en doorzoeken.
* Download hier [het resultaat als CSV](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/docs/HUA-catnr-oudnr.csv) (3,5MB, 115.399 regels).
* Download hier [het resultaat als PDF](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/docs/HUA-catnr-oudnr.pdf) (5MB, 2500 pagina's).
* Hier staat ook een [PDF met uitleg over de Rubrieken](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/docs/Rubrieken.pdf).

## Voorbeeld
Stel je bent op zoek naar nummer het oude nummer TA.Id-2-12. ‘Id’ blijkt te staan voor ‘Id St. Mariakerk – Algemeen’ (zie [Rubrieken document](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/docs/Rubrieken.pdf)) en in de [(doorzoekbare) Concordantielijst](https://github.com/hetutrechtsarchief/Concordantie-Catalogusnummer-Oudnummer/raw/master/docs/HUA-catnr-oudnr.pdf) kom je er achter dat ‘Id 2.12’ het oude nummer is van de afbeelding met [Catalogusnummer 216457](https://hetutrechtsarchief.nl/collectie/beeldmateriaal/catalogusnummer/216457). 

Succes!
Rick Companje
27 mei 2020

## Technische informatie

### Zelf de lijst genereren
Voer het shell script uit dat via CURL de benodigde SPARQL queries uitvoert.
```bash
./maak-lijst.sh
```

of probleer online zelf de SPARQL Query uit: https://api.data.netwerkdigitaalerfgoed.nl/s/zb80tB6Xo

### De gebruikte SPARQL query
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
