# Concordantie-Catalogusnummer-Oudnummer
Een script en een CSV bestand met Concordantie tussen HUA Beeldbank Catalogusnummer en Oude nummering

Er zijn op het moment van schrijven +100.000 afbeeldingen in de beeldbank waarvan een of meerdere 'oude nummers' bekend zijn. Onderstaande loop voert meerdere queries (in blokken van 10.000 resultaten) uit op de triplestore van Het Utrechts Archief. De output kun je redirecten naar 1 groot csv bestand.

## Usage:
```bash
./download-csv.sh > output.csv
```

of

```bash
echo "Catalogusnummer,Oudnummer" > HUA-catnr-oudnr.csv
./download-csv.sh >> HUA-catnr-oudnr.csv
```

## Query live uitvoeren via SPARQL
https://api.data.netwerkdigitaalerfgoed.nl/s/hAuhfUMyA