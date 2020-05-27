# er zijn op het moment van schrijven 103.739 afbeeldingen in de beeldbank waarvan 
# 'oude nummers' bekend zijn. Onderstaande loop voert meerdere queries (in blokken 
# van 10.000 resultaten) uit op de # triplestore van Het Utrechts Archief en plaatst 
# deze in 1 groot CSV bestand.

filename=Concordantie-Catalogusnummer-Oudnummer.csv

echo "Catalogusnummer,oudnummer_1,oudnummer_2,oudnummer_3" > $filename 

for i in `seq 0 10000 120000`
do 

  curl https://data.netwerkdigitaalerfgoed.nl/_api/datasets/hetutrechtsarchief/mi2rdf/services/mi2rdf/sparql -X POST --data 'query=PREFIX%20rdf%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX%20soort%3A%20%3Chttps%3A%2F%2Farchief.io%2Fsoort%23%3E%0APREFIX%20v%3A%20%3Chttps%3A%2F%2Farchief.io%2Fveld%23%3E%0A%0ASELECT%20DISTINCT%20%3FCatalogusnummer%2C%20%3Foudnummer_1%2C%20%3Foudnummer_2%2C%20%3Foudnummer_3%20WHERE%20%7B%0A%20%20%3Fsub%20%3Fpred%20%3Fobj%20.%0A%20%20BIND%28REPLACE%28str%28%3Fsub%29%2C%20%22https%3A%2F%2Farchief.io%2Fid%2F%22%2C%20%22%22%29%20AS%20%3FGUID%29%20%0A%20%20%3Fsub%20v%3Anummer%20%3FCatalogusnummer%20.%0A%20%20BIND%28IRI%28CONCAT%28%22https%3A%2F%2Fhetutrechtsarchief.nl%2Fbeeld%2F%22%2C%3FGUID%29%29%20as%20%3FPermalink%29%20.%0A%20%20%3Fsub%20v%3Aoudnummer_1%20%3Foudnummer_1%20.%0A%20%20OPTIONAL%20%7B%20%3Fsub%20v%3Aoudnummer_2%20%3Foudnummer_2%20%7D%0A%20%20OPTIONAL%20%7B%20%3Fsub%20v%3Aoudnummer_3%20%3Foudnummer_3%20%7D%0A%7D%20%0ALIMIT%2010000%0AOFFSET%200'$i -H "Accept: text/csv" | awk 'FNR>1' >> $filename

  # (awk 'FNR>1' zorgt dat de header niet meerdere keren er in komt)

done
