# er zijn op het moment van schrijven +100.000 afbeeldingen in de beeldbank waarvan 
# een of meerdere 'oude nummers' bekend zijn. Onderstaande loop voert meerdere queries 
# (in blokken van 10.000 resultaten) uit op de triplestore van Het Utrechts Archief.
# de output kun je redirecten naar 1 groot csv bestand.

# Usage:
# $ ./download-csv.sh > output.csv
# of
# $ echo "Catalogusnummer,Oudnummer" > output.csv 
# $ ./download-csv.sh >> output.csv

for i in `seq 0 10000 120000`
do 
  curl -H "Accept: text/csv" https://data.netwerkdigitaalerfgoed.nl/_api/datasets/hetutrechtsarchief/mi2rdf/services/mi2rdf/sparql -X POST --data 'query=PREFIX%20xsd%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0APREFIX%20rdf%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX%20soort%3A%20%3Chttps%3A%2F%2Farchief.io%2Fsoort%23%3E%0APREFIX%20v%3A%20%3Chttps%3A%2F%2Farchief.io%2Fveld%23%3E%0A%0ASELECT%20%3FCatalogusnummer%2C%20%3Foudnummer%20%7B%0A%20%20%7B%20%3Fsub%20v%3Anummer%20%3FCatalogusnummer%20%3B%20v%3Aoudnummer_1%20%3Foudnummer%7D%0A%20%20UNION%0A%20%20%7B%20%3Fsub%20v%3Anummer%20%3FCatalogusnummer%20%3B%20v%3Aoudnummer_2%20%3Foudnummer%7D%20%0A%20%20UNION%0A%20%20%7B%20%3Fsub%20v%3Anummer%20%3FCatalogusnummer%20%3B%20v%3Aoudnummer_3%20%3Foudnummer%7D%20%0A%7D%0ALIMIT%2010000%0AOFFSET%200'$i \
   | awk 'FNR>1'  # zorgt dat de header telkens worden weggefilterd
done
